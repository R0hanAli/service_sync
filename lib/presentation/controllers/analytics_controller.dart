import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasources/local/sqlite_helper.dart';
import '../../data/models/service_request_model.dart';

class AnalyticsController extends GetxController {
  
  final RxBool isLoading = false.obs;

  
  final RxList<double> weeklyCompletions = <double>[].obs;
  
  final RxList<double> monthlyRates = <double>[].obs;
  
  final RxMap<String, double> avgResolutionByType = <String, double>{}.obs;

  
  final RxInt totalCompleted = 0.obs;
  final RxInt totalPending = 0.obs;
  final RxInt totalRejected = 0.obs;
  final RxDouble avgCompletionRate = 0.0.obs;
  final RxDouble avgResolutionHours = 0.0.obs;

  final List<String> weekDayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  final SQLiteHelper _db = SQLiteHelper.instance;

  
  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  
  Future<void> loadAnalytics() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final maps = await _db.getAllServiceRequests();
      if (maps.isEmpty) {
        _loadMockAnalytics();
      } else {
        final jobs = maps.map((m) => ServiceRequestModel.fromMap(m)).toList();
        _computeAnalytics(jobs);
      }
    } catch (e) {
      debugPrint('[AnalyticsController] loadAnalytics error: $e');
      _loadMockAnalytics();
    } finally {
      isLoading.value = false;
    }
  }

  
  void _computeAnalytics(List<ServiceRequestModel> jobs) {
    totalCompleted.value = jobs.where((j) => j.status == 'completed').length;
    totalPending.value   = jobs.where((j) => j.status == 'pending').length;
    totalRejected.value  = jobs.where((j) => j.status == 'rejected').length;

    if (jobs.isNotEmpty) {
      avgCompletionRate.value = totalCompleted.value / jobs.length;
    }

    
    final now = DateTime.now();
    final weekly = List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return jobs
          .where((j) =>
              j.status == 'completed' &&
              j.scheduledDate != null &&
              j.scheduledDate!.year == day.year &&
              j.scheduledDate!.month == day.month &&
              j.scheduledDate!.day == day.day)
          .length
          .toDouble();
    });
    weeklyCompletions.assignAll(weekly);

    
    final monthlyData = List.generate(now.month, (i) {
      final month = i + 1;
      final monthJobs = jobs.where((j) =>
          j.scheduledDate != null &&
          j.scheduledDate!.year == now.year &&
          j.scheduledDate!.month == month);
      final total = monthJobs.length;
      final done = monthJobs.where((j) => j.status == 'completed').length;
      return total > 0 ? (done / total * 100) : 0.0;
    });
    monthlyRates.assignAll(monthlyData);
  }

  
  void _loadMockAnalytics() {
    weeklyCompletions.assignAll([3.0, 5.0, 4.0, 7.0, 6.0, 9.0, 8.0]);
    monthlyRates.assignAll([72.0, 65.0, 80.0, 78.0, 85.0, 87.0]);
    avgResolutionByType.assignAll({
      'HVAC Repair': 2.5,
      'Electrical': 1.8,
      'Plumbing': 1.2,
      'Security': 3.0,
      'Network': 4.1,
      'Appliance': 1.5,
    });
    totalCompleted.value = 9;
    totalPending.value = 4;
    totalRejected.value = 1;
    avgCompletionRate.value = 0.64;
    avgResolutionHours.value = 2.35;
  }

  Future<void> refresh() => loadAnalytics();
}
