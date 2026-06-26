import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasources/local/sqlite_helper.dart';
import '../../data/models/notification_model.dart';

class NotificationController extends GetxController {
  
  final RxList<NotificationModel> notifications =
      <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  
  final SQLiteHelper _db = SQLiteHelper.instance;
  Timer? _notificationTimer;
  final Random _random = Random();

  
  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    _startNotificationSimulator();
  }

  @override
  void onClose() {
    _notificationTimer?.cancel();
    super.onClose();
  }

  
  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      final maps = await _db.getAllNotifications();
      if (maps.isEmpty) {
        notifications.assignAll(_mockNotifications());
      } else {
        notifications.assignAll(
            maps.map((m) => NotificationModel.fromMap(m)));
      }
      _recalcUnread();
    } catch (e) {
      debugPrint('[NotificationController] loadNotifications error: \$e');
      notifications.assignAll(_mockNotifications());
      _recalcUnread();
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> markAsRead(String id) async {
    try {
      await _db.markNotificationRead(id);
      final idx = notifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        notifications[idx] = notifications[idx].copyWith(isRead: true);
      }
      _recalcUnread();
    } catch (e) {
      debugPrint('[NotificationController] markAsRead error: \$e');
    }
  }

  
  Future<void> markAllAsRead() async {
    try {
      await _db.markAllNotificationsRead();
      final updated = notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      notifications.assignAll(updated);
      unreadCount.value = 0;
      _showSuccess('All notifications marked as read ✓');
    } catch (e) {
      debugPrint('[NotificationController] markAllAsRead error: \$e');
    }
  }

  
  void addNotification(NotificationModel notif) {
    notifications.insert(0, notif);
    if (!notif.isRead) {
      unreadCount.value++;
    }
  }

  
  void _recalcUnread() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  
  void _startNotificationSimulator() {
    _notificationTimer =
        Timer.periodic(const Duration(seconds: 45), (_) async {
      final notif = _generateMockNotification();
      addNotification(notif);

      try {
        await _db.insertNotification(notif.toMap());
      } catch (e) {
        debugPrint('[NotificationController] persist simulated notif: \$e');
      }

      
      Get.snackbar(
        notif.title,
        notif.body,
        snackPosition: SnackPosition.TOP,
        backgroundColor: _notifColor(notif.type).withValues(alpha: 0.92),
        colorText: Colors.white,
        borderRadius: 16,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 4),
        icon: Icon(_notifIcon(notif.type), color: Colors.white),
        isDismissible: true,
      );
    });
  }

  
  NotificationModel _generateMockNotification() {
    final templates = [
      (
        'New Job Assigned',
        'SR-001240: Electrical repair at 78 Rosewood Dr — scheduled for today 3PM',
        'job_assigned',
      ),
      (
        '⚠️ Emergency Alert',
        'SR-001241 has been flagged as EMERGENCY — immediate response required',
        'emergency',
      ),
      (
        'Sync Complete',
        '6 service requests successfully synced to cloud ☁️',
        'sync',
      ),
      (
        'Job Reminder',
        'SR-001235 starts in 30 minutes at 123 Maple Ave, Portland',
        'reminder',
      ),
      (
        'Admin Message',
        'Team meeting at 5PM today. All technicians required to attend.',
        'message',
      ),
      (
        'Report Approved',
        'Your report for SR-001230 has been approved by admin ✅',
        'approval',
      ),
      (
        'Customer Feedback',
        'John Harrison left 5-star review: "Excellent service!" ⭐⭐⭐⭐⭐',
        'feedback',
      ),
    ];

    final template = templates[_random.nextInt(templates.length)];

    return NotificationModel(
      id: 'notif_\${DateTime.now().millisecondsSinceEpoch}',
      title: template.$1,
      body: template.$2,
      type: template.$3,
      isRead: false,
      createdAt: DateTime.now(),
      payload: {},
    );
  }

  IconData _notifIcon(String type) {
    switch (type) {
      case 'emergency':
        return Icons.warning_amber_rounded;
      case 'job_assigned':
        return Icons.assignment_outlined;
      case 'sync':
        return Icons.sync_rounded;
      case 'reminder':
        return Icons.alarm_rounded;
      case 'message':
        return Icons.message_outlined;
      case 'approval':
        return Icons.check_circle_outline_rounded;
      case 'feedback':
        return Icons.star_outline_rounded;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _notifColor(String type) {
    switch (type) {
      case 'emergency':
        return const Color(0xFFFF4757);
      case 'job_assigned':
        return const Color(0xFF1E90FF);
      case 'sync':
        return const Color(0xFF2ED573);
      case 'reminder':
        return const Color(0xFFFFA502);
      case 'approval':
        return const Color(0xFF2ED573);
      case 'feedback':
        return const Color(0xFFFFA502);
      default:
        return const Color(0xFF5352ED);
    }
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Done',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2ED573).withValues(alpha: 0.9),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  
  List<NotificationModel> _mockNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 'notif_001',
        title: '⚠️ Emergency Job Assigned',
        body: 'SR-001235: Electrical hazard at 123 Maple Ave — immediate response required',
        type: 'emergency',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 5)),
        payload: {'jobId': 'SR-001235'},
      ),
      NotificationModel(
        id: 'notif_002',
        title: 'New Job Assigned',
        body: 'SR-001236: HVAC Maintenance at 321 Pine St, Denver — scheduled tomorrow 9AM',
        type: 'job_assigned',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 1)),
        payload: {'jobId': 'SR-001236'},
      ),
      NotificationModel(
        id: 'notif_003',
        title: 'Report Approved ✅',
        body: 'Your service report RPT_20240115_001 for SR-001230 has been approved',
        type: 'approval',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        payload: {'reportId': 'RPT_20240115_001'},
      ),
      NotificationModel(
        id: 'notif_004',
        title: 'Sync Complete',
        body: '12 records synced successfully to the cloud ☁️',
        type: 'sync',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 3)),
        payload: {},
      ),
      NotificationModel(
        id: 'notif_005',
        title: 'Customer Feedback ⭐',
        body: 'David Chen rated your service 5 stars: "Very professional and quick!"',
        type: 'feedback',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
        payload: {'customerId': 'cust_003'},
      ),
      NotificationModel(
        id: 'notif_006',
        title: 'Job Reminder ⏰',
        body: 'SR-001234 starts in 30 minutes at 742 Evergreen Terrace, Springfield',
        type: 'reminder',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        payload: {'jobId': 'SR-001234'},
      ),
      NotificationModel(
        id: 'notif_007',
        title: 'Admin Message 📢',
        body: 'New safety protocol update — please review before your next shift.',
        type: 'message',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
        payload: {},
      ),
    ];
  }
}
