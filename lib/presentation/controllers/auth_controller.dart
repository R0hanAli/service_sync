import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../data/datasources/local/sqlite_helper.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool rememberMe = false.obs;

  
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  final SQLiteHelper _db = SQLiteHelper.instance;

  
  static final UserModel _mockUser = UserModel(
    id: 'usr_001',
    fullName: 'Alex Rodriguez',
    email: 'alex.rodriguez@servicesync.com',
    phone: '+1-555-0147',
    role: 'technician',
    profileImage: '',
    createdAt: '2024-01-15T00:00:00.000',
  );

  
  @override
  void onInit() {
    super.onInit();
    checkSession();
  }

  
  bool get isAdmin => currentUser.value?.role == 'admin';
  bool get isTechnician => currentUser.value?.role == 'technician';

  
  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    this.rememberMe.value = rememberMe;
    if (email.trim().isEmpty || password.trim().isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      
      if (password == 'demo1234') {
        final user = _mockUser.copyWith(email: email.trim());
        currentUser.value = user;
        isLoggedIn.value = true;

        
        await _storage.write(
            key: 'session_token', value: 'mock_token_\${user.id}');
        await _storage.write(
            key: 'user_data', value: jsonEncode(user.toMap()));

        if (rememberMe) {
          await _storage.write(key: 'remember_email', value: email.trim());
        }

        _showSuccess(
            'Welcome back, \${user.fullName.split(' ').first}! 👋');
        await Future.delayed(const Duration(milliseconds: 400));
        Get.offAllNamed('/dashboard');
      } else {
        errorMessage.value = 'Invalid credentials. Use password: demo1234';
        _showError('Invalid email or password. (Hint: use demo1234)');
      }
    } catch (e) {
      errorMessage.value = 'Login failed. Please try again.';
      _showError('Something went wrong. Please try again.');
      debugPrint('[AuthController] login error: \$e');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String role,
    required String password,
  }) async {
    if (fullName.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      _showError('Please fill in all required fields.');
      return;
    }

    if (password.length < 8) {
      _showError('Password must be at least 8 characters.');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.delayed(const Duration(milliseconds: 900));

      final newUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName.trim(),
        email: email.trim().toLowerCase(),
        phone: phone.trim(),
        role: role,
        profileImage: '',
        createdAt: DateTime.now().toIso8601String(),
      );

      
      await _db.insertUser(newUser.toMap());

      
      currentUser.value = newUser;
      isLoggedIn.value = true;

      await _storage.write(
          key: 'session_token', value: 'token_\${newUser.id}');
      await _storage.write(
          key: 'user_data', value: jsonEncode(newUser.toMap()));

      _showSuccess('Account created successfully! Welcome aboard 🎉');
      await Future.delayed(const Duration(milliseconds: 400));
      Get.offAllNamed('/dashboard');
    } catch (e) {
      errorMessage.value = 'Registration failed. Please try again.';
      _showError('Registration failed. Please try again.');
      debugPrint('[AuthController] register error: \$e');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _storage.delete(key: 'session_token');
      await _storage.delete(key: 'user_data');
      currentUser.value = null;
      isLoggedIn.value = false;
      errorMessage.value = '';
      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint('[AuthController] logout error: \$e');
      
      currentUser.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> forgotPassword(String email) async {
    if (email.trim().isEmpty) {
      _showError('Please enter your email address.');
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      _showSuccess('Password reset link sent to \${email.trim()} 📧');
    } catch (e) {
      _showError('Failed to send reset email. Please try again.');
      debugPrint('[AuthController] forgotPassword error: \$e');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> checkSession() async {
    try {
      final token = await _storage.read(key: 'session_token');
      final userDataStr = await _storage.read(key: 'user_data');

      if (token != null && userDataStr != null) {
        final userMap = jsonDecode(userDataStr) as Map<String, dynamic>;
        currentUser.value = UserModel.fromMap(userMap);
        isLoggedIn.value = true;
        debugPrint(
            '[AuthController] Session restored for \${currentUser.value?.fullName}');
        Get.offAllNamed('/dashboard');
      }
    } catch (e) {
      debugPrint('[AuthController] checkSession: no active session (\$e)');
    }
  }

  
  Future<String?> getRememberedEmail() async {
    return _storage.read(key: 'remember_email');
  }

  Future<void> saveThemePreference(bool isDark) async {
    await _storage.write(key: 'theme_dark', value: isDark.toString());
  }

  Future<bool> getThemePreference() async {
    final val = await _storage.read(key: 'theme_dark');
    return val == 'true';
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
      icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
      isDismissible: true,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2ED573).withValues(alpha: 0.92),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      icon:
          const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
      isDismissible: true,
    );
  }
}
