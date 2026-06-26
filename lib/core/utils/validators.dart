import 'app_constants.dart';






class AppValidators {
  AppValidators._();

  
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
  );

  static final _phoneRegex = RegExp(
    r'^\+?[0-9]{7,15}$',
  );

  static final _uppercaseRegex  = RegExp(r'[A-Z]');
  static final _lowercaseRegex  = RegExp(r'[a-z]');
  static final _digitRegex      = RegExp(r'[0-9]');
  static final _specialRegex    = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

  
  
  

  
  
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  
  
  

  
  
  
  
  
  
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    if (!_uppercaseRegex.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!_lowercaseRegex.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!_digitRegex.hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  
  
  

  
  
  
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  
  
  

  
  
  
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    final cleaned = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (!_phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  
  
  

  
  static String? validateConfirmPassword(
    String? password,
    String? confirm,
  ) {
    if (confirm == null || confirm.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirm) {
      return 'Passwords do not match';
    }
    return null;
  }

  
  
  

  
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > AppConstants.maxNameLength) {
      return 'Name must not exceed ${AppConstants.maxNameLength} characters';
    }
    return null;
  }

  
  
  

  
  static String? validateMaxLength(
    String? value,
    String fieldName,
    int maxLength,
  ) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }
    return null;
  }

  
  
  

  
  
  
  
  static String passwordStrength(String password) {
    if (password.isEmpty) return 'Weak';

    int score = 0;

    
    if (password.length >= AppConstants.minPasswordLength) score++;
    if (password.length >= 12) score++;

    
    if (_uppercaseRegex.hasMatch(password)) score++;
    if (_lowercaseRegex.hasMatch(password)) score++;
    if (_digitRegex.hasMatch(password)) score++;
    if (_specialRegex.hasMatch(password)) score++;

    if (score >= 5) return 'Strong';
    if (score >= 3) return 'Medium';
    return 'Weak';
  }

  
  
  static double passwordStrengthValue(String password) {
    final label = passwordStrength(password);
    switch (label) {
      case 'Strong':
        return 1.0;
      case 'Medium':
        return 0.55;
      default:
        return 0.25;
    }
  }
}
