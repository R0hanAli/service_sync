import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_constants.dart';


class AppHelpers {
  AppHelpers._();

  
  
  

  
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  
  static String formatTime(DateTime date) {
    return DateFormat(AppConstants.timeFormat).format(date);
  }

  
  
  static String formatDateTime(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormat).format(date);
  }

  
  static String formatApiDate(DateTime date) {
    return DateFormat(AppConstants.apiDateFormat).format(date);
  }

  
  
  

  
  
  
  
  
  
  
  static String getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m ${m == 1 ? 'minute' : 'minutes'} ago';
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h ${h == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      return '$d ${d == 1 ? 'day' : 'days'} ago';
    } else {
      return formatDate(date);
    }
  }

  
  
  static String getTimeAgoShort(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60)  return 'now';
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m';
    if (diff.inHours < 24)    return '${diff.inHours}h';
    if (diff.inDays < 7)      return '${diff.inDays}d';
    return DateFormat('MMM d').format(date);
  }

  
  
  

  
  
  
  
  
  
  static String getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';

    final parts = trimmed
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .toLowerCase()
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  
  
  

  
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case AppConstants.priorityEmergency:
        return const Color(0xFFEF4444); 
      case AppConstants.priorityHigh:
        return const Color(0xFFF97316); 
      case AppConstants.priorityMedium:
        return const Color(0xFFF59E0B); 
      case AppConstants.priorityLow:
      default:
        return const Color(0xFF10B981); 
    }
  }

  
  static Color getPriorityBgColor(String priority) =>
      getPriorityColor(priority).withOpacity(0.15);

  
  static IconData getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case AppConstants.priorityEmergency:
        return Icons.warning_rounded;
      case AppConstants.priorityHigh:
        return Icons.keyboard_double_arrow_up_rounded;
      case AppConstants.priorityMedium:
        return Icons.remove_rounded;
      case AppConstants.priorityLow:
      default:
        return Icons.keyboard_double_arrow_down_rounded;
    }
  }

  
  static String getPriorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case AppConstants.priorityEmergency:
        return 'Emergency';
      case AppConstants.priorityHigh:
        return 'High';
      case AppConstants.priorityMedium:
        return 'Medium';
      case AppConstants.priorityLow:
      default:
        return 'Low';
    }
  }

  
  
  

  
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.statusPending:
        return const Color(0xFFF59E0B); 
      case AppConstants.statusAccepted:
        return const Color(0xFF3B82F6); 
      case AppConstants.statusInProgress:
        return const Color(0xFF8B5CF6); 
      case AppConstants.statusCompleted:
        return const Color(0xFF10B981); 
      case AppConstants.statusRejected:
      case 'cancelled':
        return const Color(0xFFEF4444); 
      case 'on_hold':
        return const Color(0xFF6B7280); 
      default:
        return const Color(0xFF6B7280);
    }
  }

  
  static Color getStatusBgColor(String status) =>
      getStatusColor(status).withOpacity(0.15);

  
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.statusPending:
        return Icons.hourglass_empty_rounded;
      case AppConstants.statusAccepted:
        return Icons.check_circle_outline_rounded;
      case AppConstants.statusInProgress:
        return Icons.timelapse_rounded;
      case AppConstants.statusCompleted:
        return Icons.task_alt_rounded;
      case AppConstants.statusRejected:
        return Icons.cancel_outlined;
      case 'cancelled':
        return Icons.block_rounded;
      case 'on_hold':
        return Icons.pause_circle_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  
  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.statusPending:
        return 'Pending';
      case AppConstants.statusAccepted:
        return 'Accepted';
      case AppConstants.statusInProgress:
        return 'In Progress';
      case AppConstants.statusCompleted:
        return 'Completed';
      case AppConstants.statusRejected:
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      case 'on_hold':
        return 'On Hold';
      default:
        return toTitleCase(status.replaceAll('_', ' '));
    }
  }

  
  
  

  
  
  
  
  static String generateRequestId() {
    final rng = Random();
    final digits = List.generate(6, (_) => rng.nextInt(10)).join();
    return 'SR-$digits';
  }

  
  static String generateUuid() {
    final rng = Random.secure();
    String hex(int n) => rng.nextInt(n).toRadixString(16).padLeft(2, '0');
    return '${hex(256)}${hex(256)}-${hex(256)}${hex(256)}-'
        '4${hex(16)}${hex(256)}-${hex(256)}-'
        '${hex(256)}${hex(256)}${hex(256)}${hex(256)}${hex(256)}${hex(256)}';
  }

  
  
  

  
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  
  static String formatNumber(num number) {
    return NumberFormat('#,###').format(number);
  }

  
  static String formatCompact(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  
  
  

  
  static String formatFileSize(int bytes) {
    if (bytes < 1024)       return '$bytes B';
    if (bytes < 1048576)    return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
  }

  
  
  

  
  
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.shortestSide >= 600;
  }

  
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  
  static void dismissKeyboard(BuildContext context) =>
      FocusScope.of(context).unfocus();

  
  
  

  
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFEF4444)
            : const Color(0xFF10B981),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
