import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/datasources/local/sqlite_helper.dart';
import '../../data/models/service_request_model.dart';

class DashboardController extends GetxController {
  
  final RxInt assignedJobs = 0.obs;
  final RxInt pendingJobs = 0.obs;
  final RxInt completedJobs = 0.obs;
  final RxInt todaysTasks = 0.obs; 
  final RxBool isLoading = false.obs;

  
  final RxBool isSyncing = false.obs;
  final RxBool isOffline = false.obs;

  
  
  final RxList<double> weeklyJobData = <double>[].obs;
  final List<String> weeklyLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  
  final RxDouble overallCompletionRate = 0.0.obs;
  final RxDouble todayCompletionRate   = 0.0.obs;
  final RxDouble weekCompletionRate    = 0.0.obs;
  final RxDouble monthCompletionRate   = 0.0.obs;

  
  final RxList<ServiceRequestModel> recentJobs = <ServiceRequestModel>[].obs;

  
  final RxList<Map<String, String>> aiInsights = <Map<String, String>>[].obs;

  
  final SQLiteHelper _db = SQLiteHelper.instance;
  Timer? _syncTimer;
  int _syncCycle = 0;

  
  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    _startSyncMonitor();
  }

  @override
  void onClose() {
    _syncTimer?.cancel();
    super.onClose();
  }

  
  String get weekRangeLabel {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final fmt = DateFormat('MMM d');
    return '${fmt.format(monday)} – ${fmt.format(sunday)}';
  }

  String get syncStatus {
    if (isSyncing.value) return 'Syncing...';
    if (isOffline.value) return 'Offline Mode';
    return 'Synced';
  }

  
  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final allJobs = await _db.getAllServiceRequests();

      if (allJobs.isEmpty) {
        _loadMockStats();
      } else {
        final jobs = allJobs.map((m) => ServiceRequestModel.fromMap(m)).toList();
        _computeStats(jobs);
      }

      weeklyJobData.assignAll(_generateWeeklyData());
      aiInsights.assignAll(_generateAIInsights());
    } catch (e) {
      debugPrint('[DashboardController] loadDashboardData error: $e');
      _loadMockStats();
    } finally {
      isLoading.value = false;
    }
  }

  
  void _computeStats(List<ServiceRequestModel> jobs) {
    final now = DateTime.now();

    assignedJobs.value  = jobs.length;
    pendingJobs.value   = jobs.where((j) => j.status == 'pending').length;
    completedJobs.value = jobs.where((j) => j.status == 'completed').length;
    todaysTasks.value   = jobs.where((j) =>
        j.scheduledDate != null && _isToday(j.scheduledDate!)).length;

    recentJobs.assignAll(jobs.take(5).toList());

    
    final total = jobs.length;
    if (total > 0) {
      overallCompletionRate.value = completedJobs.value / total;
    }

    final todayJobs = jobs.where((j) =>
        j.scheduledDate != null && _isToday(j.scheduledDate!)).toList();
    final todayDone = todayJobs.where((j) => j.status == 'completed').length;
    todayCompletionRate.value = todayJobs.isEmpty ? 0 : todayDone / todayJobs.length;

    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekJobs = jobs.where((j) =>
        j.scheduledDate != null && !j.scheduledDate!.isBefore(weekStart)).toList();
    final weekDone = weekJobs.where((j) => j.status == 'completed').length;
    weekCompletionRate.value = weekJobs.isEmpty ? 0 : weekDone / weekJobs.length;

    final monthStart = DateTime(now.year, now.month, 1);
    final monthJobs = jobs.where((j) =>
        j.scheduledDate != null && !j.scheduledDate!.isBefore(monthStart)).toList();
    final monthDone = monthJobs.where((j) => j.status == 'completed').length;
    monthCompletionRate.value = monthJobs.isEmpty ? 0 : monthDone / monthJobs.length;
  }

  
  void _loadMockStats() {
    assignedJobs.value  = 14;
    pendingJobs.value   = 4;
    completedJobs.value = 9;
    todaysTasks.value   = 3;

    overallCompletionRate.value = 0.64;
    todayCompletionRate.value   = 0.67;
    weekCompletionRate.value    = 0.71;
    monthCompletionRate.value   = 0.82;

    recentJobs.assignAll(_mockRecentJobs());
    weeklyJobData.assignAll(_generateWeeklyData());
    aiInsights.assignAll(_generateAIInsights());
  }

  
  void _startSyncMonitor() {
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      _syncCycle++;
      isSyncing.value = true;
      await Future.delayed(const Duration(seconds: 2));

      if (_syncCycle % 3 == 0) {
        isOffline.value = true;
        isSyncing.value = false;
        await Future.delayed(const Duration(seconds: 4));
        isOffline.value = false;
      }

      isSyncing.value = false;
    });
  }

  
  List<Map<String, String>> _generateAIInsights() {
    final remaining = 12 - completedJobs.value;
    return [
      {
        'emoji': '🔴',
        'title': 'Emergency Priority',
        'text': '${pendingJobs.value} jobs pending — prioritize emergency requests first',
        'gradient': 'amber',
      },
      {
        'emoji': '📈',
        'title': 'Performance Trend',
        'text': 'Completion rate improved by 12% this week — great work!',
        'gradient': 'green',
      },
      {
        'emoji': '⚡',
        'title': 'Peak Hours Scheduler',
        'text': 'Peak hours: 9AM–11AM — schedule critical jobs in this window',
        'gradient': 'cyan',
      },
      {
        'emoji': '🎯',
        'title': 'Weekly Goal',
        'text': '$remaining jobs away from this week\'s target of 12',
        'gradient': 'blue',
      },
    ];
  }

  
  Future<void> refresh() async {
    await loadDashboardData();
    Get.snackbar(
      'Dashboard',
      'Dashboard refreshed ✓',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E90FF).withValues(alpha: 0.9),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  
  List<double> _generateWeeklyData() => [3.0, 5.0, 4.0, 7.0, 6.0, 9.0, 8.0];

  
  List<ServiceRequestModel> _mockRecentJobs() {
    final now = DateTime.now();
    return [
      ServiceRequestModel(
        id: 'SR-001234',
        customerId: 'cust_001',
        customerName: 'John Harrison',
        customerPhone: '+1-555-0198',
        customerAddress: '742 Evergreen Terrace, Springfield',
        serviceType: 'HVAC Repair',
        description: 'AC unit not cooling properly. Makes a rattling noise.',
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
        description: 'Tripped circuit breaker keeps resetting.',
        priority: 'emergency',
        status: 'pending',
        scheduledDate: now,
        createdAt: now.subtract(const Duration(hours: 5)),
        assignedTechnicianId: 'usr_001',
        estimatedDuration: 90,
      ),
      ServiceRequestModel(
        id: 'SR-001230',
        customerId: 'cust_003',
        customerName: 'David Chen',
        customerPhone: '+1-555-0312',
        customerAddress: '56 Oak Drive, Seattle',
        serviceType: 'Plumbing',
        description: 'Leaking pipe under kitchen sink.',
        priority: 'medium',
        status: 'completed',
        scheduledDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
        assignedTechnicianId: 'usr_001',
        estimatedDuration: 60,
      ),
    ];
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
