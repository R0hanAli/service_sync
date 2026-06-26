
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/notification_controller.dart';
import '../../../data/models/notification_model.dart';

const _kDark   = Color(0xFF0A0E27);
const _kSurface = Color(0xFF1A1F4E);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kAmber  = Color(0xFFF59E0B);
const _kGreen  = Color(0xFF10B981);
const _kRed    = Color(0xFFEF4444);

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NotificationController>();
    return Scaffold(
      backgroundColor: _kDark,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0A0E27), Color(0xFF0D1333), Color(0xFF12163A)])),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(ctrl),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                sliver: Obx(() {
                  if (ctrl.isLoading.value) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator(color: _kCyan)));
                  }
                  if (ctrl.notifications.isEmpty) {
                    return SliverToBoxAdapter(child: _buildEmpty());
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _NotificationTile(
                        notif: ctrl.notifications[i],
                        onTap: () => ctrl.markAsRead(ctrl.notifications[i].id),
                        onDismiss: () => ctrl.markAsRead(ctrl.notifications[i].id),
                      ),
                      childCount: ctrl.notifications.length,
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(NotificationController ctrl) {
    return SliverAppBar(
      expandedHeight: 110,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.15))),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: ctrl.markAllAsRead,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _kBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _kBlue.withOpacity(0.35))),
              child: Text('Mark All Read', style: GoogleFonts.outfit(
                fontSize: 11, color: _kBlue, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [_kSurface.withOpacity(0.85), _kDark.withOpacity(0.7)]),
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08)))),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(60, 8, 120, 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notifications', style: GoogleFonts.outfit(
                        fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                      Obx(() => Text(
                        '${ctrl.unreadCount.value} unread',
                        style: GoogleFonts.outfit(fontSize: 12, color: _kCyan))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Icon(Icons.notifications_off_outlined, size: 64, color: Colors.white24),
        const SizedBox(height: 16),
        Text('No notifications yet', style: GoogleFonts.outfit(
          color: Colors.white38, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text('You\'re all caught up!', style: GoogleFonts.outfit(
          color: Colors.white24, fontSize: 13)),
      ],
    );
  }
}


class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notif,
    required this.onTap,
    required this.onDismiss,
  });
  final NotificationModel notif;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(notif.type);
    final icon  = _typeIcon(notif.type);
    final unread = !notif.isRead;

    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: _kGreen.withOpacity(0.2),
          borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.check_rounded, color: _kGreen, size: 24),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: unread
                      ? [color.withOpacity(0.12), color.withOpacity(0.04)]
                      : [Colors.white.withOpacity(0.06), Colors.white.withOpacity(0.02)]),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: unread ? color.withOpacity(0.30) : Colors.white.withOpacity(0.08))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.30))),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(notif.title,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14, color: Colors.white,
                                    fontWeight: unread ? FontWeight.w700 : FontWeight.w500)),
                              ),
                              if (unread)
                                Container(
                                  width: 8, height: 8,
                                  decoration: BoxDecoration(
                                    color: color, shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)]),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(notif.body,
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(fontSize: 13, color: Colors.white54, height: 1.4)),
                          const SizedBox(height: 6),
                          Text(_formatTime(notif.createdAt),
                            style: GoogleFonts.outfit(fontSize: 11, color: Colors.white30)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(dt);
  }

  Color _typeColor(String t) {
    switch (t) {
      case 'emergency':   return _kRed;
      case 'job_assigned': return _kBlue;
      case 'sync':        return _kGreen;
      case 'reminder':    return _kAmber;
      case 'approval':    return _kGreen;
      case 'feedback':    return _kAmber;
      default:            return _kPurple;
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'emergency':   return Icons.warning_amber_rounded;
      case 'job_assigned': return Icons.assignment_outlined;
      case 'sync':        return Icons.sync_rounded;
      case 'reminder':    return Icons.alarm_rounded;
      case 'approval':    return Icons.check_circle_outline_rounded;
      case 'feedback':    return Icons.star_outline_rounded;
      default:            return Icons.message_outlined;
    }
  }
}

