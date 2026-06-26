import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasources/local/sqlite_helper.dart';
import '../../data/models/service_request_model.dart';

class JobController extends GetxController {
  
  final RxList<ServiceRequestModel> allJobs = <ServiceRequestModel>[].obs;
  final RxList<ServiceRequestModel> filteredJobs =
      <ServiceRequestModel>[].obs;
  final RxString selectedFilter = 'all'.obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final Rx<ServiceRequestModel?> selectedJob = Rx<ServiceRequestModel?>(null);
  final RxBool showQRScanner = false.obs;

  
  final SQLiteHelper _db = SQLiteHelper.instance;

  
  @override
  void onInit() {
    super.onInit();
    loadJobs();

    
    debounce(
      searchQuery,
      (_) => _applyFilters(),
      time: const Duration(milliseconds: 300),
    );
  }

  
  List<ServiceRequestModel> get pendingJobs =>
      allJobs.where((j) => j.status == 'pending').toList();

  List<ServiceRequestModel> get acceptedJobs =>
      allJobs.where((j) => j.status == 'accepted').toList();

  List<ServiceRequestModel> get inProgressJobs =>
      allJobs.where((j) => j.status == 'inProgress').toList();

  List<ServiceRequestModel> get completedJobs =>
      allJobs.where((j) => j.status == 'completed').toList();

  List<ServiceRequestModel> get rejectedJobs =>
      allJobs.where((j) => j.status == 'rejected').toList();

  List<ServiceRequestModel> get emergencyJobs =>
      allJobs.where((j) => j.priority == 'emergency').toList();

  int get totalCount => allJobs.length;
  int get pendingCount => pendingJobs.length;
  int get completedCount => completedJobs.length;

  bool isEmergency(ServiceRequestModel job) => job.priority == 'emergency';

  
  Future<void> loadJobs() async {
    isLoading.value = true;
    try {
      final maps = await _db.getAllServiceRequests();
      if (maps.isEmpty) {
        
        allJobs.assignAll(_mockJobs());
      } else {
        allJobs.assignAll(maps.map((m) => ServiceRequestModel.fromMap(m)));
      }
      _applyFilters();
    } catch (e) {
      debugPrint('[JobController] loadJobs error: \$e');
      allJobs.assignAll(_mockJobs());
      _applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  
  void filterByStatus(String status) {
    selectedFilter.value = status;
    _applyFilters();
  }

  
  void searchJobs(String query) {
    searchQuery.value = query;
  }

  
  void _applyFilters() {
    var result = allJobs.toList();

    
    if (selectedFilter.value != 'all') {
      result = result
          .where((j) => j.status == selectedFilter.value)
          .toList();
    }

    
    if (searchQuery.value.trim().isNotEmpty) {
      final q = searchQuery.value.trim().toLowerCase();
      result = result.where((j) {
        return j.customerName.toLowerCase().contains(q) ||
            j.id.toLowerCase().contains(q) ||
            j.serviceType.toLowerCase().contains(q) ||
            j.customerAddress.toLowerCase().contains(q);
      }).toList();
    }

    filteredJobs.assignAll(result);
  }

  
  Future<void> updateJobStatus(String jobId, String newStatus) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 400));

      
      await _db.updateServiceRequest(jobId, {'status': newStatus});

      
      await _db.addToSyncQueue({
        'operation': 'update',
        'tableName': 'service_requests',
        'payload': jsonEncode({'requestId': jobId, 'status': newStatus}),
      });

      
      final idx = allJobs.indexWhere((j) => j.id == jobId);
      if (idx != -1) {
        final updated = allJobs[idx].copyWith(status: newStatus);
        allJobs[idx] = updated;
        if (selectedJob.value?.id == jobId) {
          selectedJob.value = updated;
        }
      }

      _applyFilters();
      _showStatusSnackbar(newStatus);
    } catch (e) {
      debugPrint('[JobController] updateJobStatus error: $e');
      _showError('Failed to update job status. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> acceptJob(String jobId) =>
      updateJobStatus(jobId, 'accepted');

  Future<void> rejectJob(String jobId) =>
      updateJobStatus(jobId, 'rejected');

  Future<void> startService(String jobId) =>
      updateJobStatus(jobId, 'inProgress');

  Future<void> startJob(String jobId) =>
      startService(jobId);

  Future<void> completeJob(String jobId) async {
    await updateJobStatus(jobId, 'completed');
    
    _triggerCompletionNotification(jobId);
  }

  
  void selectJob(ServiceRequestModel job) {
    selectedJob.value = job;
  }

  void clearSelection() {
    selectedJob.value = null;
  }

  void toggleQRScanner() {
    showQRScanner.value = !showQRScanner.value;
  }

  
  void _triggerCompletionNotification(String jobId) {
    Get.snackbar(
      '✅ Job Completed!',
      'Service request \$jobId has been marked as completed.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2ED573).withValues(alpha: 0.95),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Text('VIEW',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  
  void _showStatusSnackbar(String status) {
    final messages = {
      'accepted': ('Job Accepted', 'Job is now in your queue ✓', const Color(0xFF1E90FF)),
      'rejected': ('Job Declined', 'Job has been declined.', const Color(0xFFFF6B81)),
      'inProgress': ('Service Started', 'Job is now in progress 🔧', const Color(0xFFFFA502)),
      'completed': ('Job Completed', 'Great work! Job marked complete ✅', const Color(0xFF2ED573)),
    };

    final info = messages[status];
    if (info != null) {
      Get.snackbar(
        info.$1,
        info.$2,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: info.$3.withValues(alpha: 0.92),
        colorText: Colors.white,
        borderRadius: 16,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFFF4757).withValues(alpha: 0.92),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }

  
  List<ServiceRequestModel> _mockJobs() {
    final now = DateTime.now();
    return [
      ServiceRequestModel(
        id: 'SR-001234',
        customerId: 'cust_001',
        customerName: 'John Harrison',
        customerPhone: '+1-555-0198',
        customerAddress: '742 Evergreen Terrace, Springfield',
        serviceType: 'HVAC Repair',
        description:
            'AC unit not cooling properly. Makes a rattling noise when running. Needs immediate attention.',
        priority: 'high',
        status: 'inProgress',
        scheduledDate: now,
        createdAt: now.subtract(const Duration(hours: 2)),
        assignedTechnicianId: 'usr_001',
        estimatedDuration: 120,
      ),
      ServiceRequestModel(
        id: 'SR-001235',
        customerId: 'cust_002',
        customerName: 'Maria Santos',
        customerPhone: '+1-555-0234',
        customerAddress: '123 Maple Ave, Portland',
        serviceType: 'Electrical',
        description:
            'Tripped circuit breaker keeps resetting after 5 minutes. Risk of fire hazard.',
        priority: 'emergency',
        status: 'pending',
        scheduledDate: now,
        createdAt: now.subtract(const Duration(hours: 5)),
        assignedTechnicianId: 'usr_001',
        estimatedDuration: 90,
      ),
      ServiceRequestModel(
        id: 'SR-001233',
        customerId: 'cust_006',
        customerName: 'Linda Park',
        customerPhone: '+1-555-0611',
        customerAddress: '55 Walnut Blvd, Chicago',
        serviceType: 'Appliance Repair',
        description: 'Refrigerator not maintaining temperature. Food spoiling.',
        priority: 'high',
        status: 'accepted',
        scheduledDate: now.add(const Duration(hours: 3)),
        createdAt: now.subtract(const Duration(hours: 8)),
        assignedTechnicianId: 'usr_001',
        estimatedDuration: 60,
      ),
      ServiceRequestModel(
        id: 'SR-001230',
        customerId: 'cust_003',
        customerName: 'David Chen',
        customerPhone: '+1-555-0312',
        customerAddress: '56 Oak Drive, Seattle',
        serviceType: 'Plumbing',
        description: 'Leaking pipe under kitchen sink. Needs pipe replacement.',
        priority: 'medium',
        status: 'completed',
        scheduledDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
        assignedTechnicianId: 'usr_001',
        estimatedDuration: 60,
      ),
      ServiceRequestModel(
        id: 'SR-001228',
        customerId: 'cust_004',
        customerName: 'Sophie Williams',
        customerPhone: '+1-555-0415',
        customerAddress: '89 Birch Lane, Austin',
        serviceType: 'Appliance Repair',
        description: 'Dishwasher not draining. Error code E4 displayed.',
        priority: 'low',
        status: 'completed',
        scheduledDate: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2, hours: 1)),
        assignedTechnicianId: 'usr_001',
        estimatedDuration: 45,
      ),
      ServiceRequestModel(
        id: 'SR-001236',
        customerId: 'cust_005',
        customerName: 'Robert Kim',
        customerPhone: '+1-555-0521',
        customerAddress: '321 Pine St, Denver',
        serviceType: 'HVAC Maintenance',
        description:
            'Annual HVAC system checkup and filter replacement service.',
        priority: 'low',
        status: 'pending',
        scheduledDate: now.add(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(hours: 1)),
        assignedTechnicianId: 'usr_001',
        estimatedDuration: 75,
      ),
      ServiceRequestModel(
        id: 'SR-001237',
        customerId: 'cust_007',
        customerName: 'James Thompson',
        customerPhone: '+1-555-0788',
        customerAddress: '14 Cedar Court, Miami',
        serviceType: 'Electrical',
        description: 'Install 3 new ceiling fan fixtures in living areas.',
        priority: 'medium',
        status: 'accepted',
        scheduledDate: now.add(const Duration(hours: 5)),
        createdAt: now.subtract(const Duration(hours: 3)),
        assignedTechnicianId: 'usr_001',
        estimatedDuration: 180,
      ),
    ];
  }
}
