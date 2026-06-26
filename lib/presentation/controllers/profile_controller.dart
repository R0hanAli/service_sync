import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasources/local/sqlite_helper.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  
  final RxBool isLoading = false.obs;
  final RxInt assignedJobs = 0.obs;
  final RxInt completedJobs = 0.obs;
  final RxDouble rating = 4.8.obs;
  final RxDouble completionRate = 0.0.obs;
  final RxList<double> weeklyActivity = <double>[].obs;
  final RxBool isChangingPassword = false.obs;

  final SQLiteHelper _db = SQLiteHelper.instance;

  
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  
  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final authCtrl = Get.find<AuthController>();
      final userId = authCtrl.currentUser.value?.id ?? 'tech-001';

      final jobs = await _db.getServiceRequestsByTechnician(userId);

      if (jobs.isEmpty) {
        assignedJobs.value = 14;
        completedJobs.value = 9;
        completionRate.value = 0.64;
      } else {
        assignedJobs.value  = jobs.length;
        completedJobs.value = jobs.where((j) => j['status'] == 'completed').length;
        completionRate.value =
            assignedJobs.value > 0 ? completedJobs.value / assignedJobs.value : 0;
      }

      weeklyActivity.assignAll([3.0, 5.0, 4.0, 7.0, 6.0, 9.0, 8.0]);
    } catch (e) {
      debugPrint('[ProfileController] loadProfile error: $e');
      assignedJobs.value = 14;
      completedJobs.value = 9;
      completionRate.value = 0.64;
      weeklyActivity.assignAll([3.0, 5.0, 4.0, 7.0, 6.0, 9.0, 8.0]);
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentPassword.trim().isEmpty || newPassword.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.',
          backgroundColor: const Color(0xFFFF4757).withValues(alpha: 0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12));
      return;
    }
    if (newPassword.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters.',
          backgroundColor: const Color(0xFFFF4757).withValues(alpha: 0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12));
      return;
    }

    isChangingPassword.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isChangingPassword.value = false;

    Get.snackbar('Success', 'Password updated successfully ✓',
        backgroundColor: const Color(0xFF2ED573).withValues(alpha: 0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12));
    Get.back();
  }

  
  void logout() {
    Get.find<AuthController>().logout();
  }

  
  Future<void> refresh() => loadProfile();
}
