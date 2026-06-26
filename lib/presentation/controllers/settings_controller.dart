import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class SettingsController extends GetxController {
  
  final RxBool isDarkMode = true.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool soundEnabled = true.obs;
  final RxBool vibrationEnabled = true.obs;
  final RxBool emergencyAlertsEnabled = true.obs;
  final RxBool biometricEnabled = false.obs;

  
  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  
  Future<void> _loadPreferences() async {
    try {
      final authCtrl = Get.find<AuthController>();
      isDarkMode.value = await authCtrl.getThemePreference();
    } catch (_) {
      isDarkMode.value = true;
    }
  }

  
  Future<void> toggleTheme(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    try {
      final authCtrl = Get.find<AuthController>();
      await authCtrl.saveThemePreference(value);
    } catch (_) {}
  }

  
  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    _showToast(value ? 'Notifications enabled' : 'Notifications disabled');
  }

  void toggleSound(bool value) {
    soundEnabled.value = value;
    _showToast(value ? 'Sound on' : 'Sound off');
  }

  void toggleVibration(bool value) {
    vibrationEnabled.value = value;
    _showToast(value ? 'Vibration on' : 'Vibration off');
  }

  void toggleEmergencyAlerts(bool value) {
    emergencyAlertsEnabled.value = value;
    _showToast(value ? 'Emergency alerts on' : 'Emergency alerts off');
  }

  void toggleBiometric(bool value) {
    biometricEnabled.value = value;
    _showToast(value ? 'Biometric login enabled' : 'Biometric login disabled');
  }

  
  void logout() {
    Get.find<AuthController>().logout();
  }

  void _showToast(String msg) {
    Get.snackbar(
      '',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A1F4E).withValues(alpha: 0.9),
      colorText: Colors.white,
      borderRadius: 14,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      duration: const Duration(seconds: 2),
      isDismissible: true,
    );
  }
}
