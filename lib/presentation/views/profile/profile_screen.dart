
import 'dart:ui';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';

const _kDark   = Color(0xFF0A0E27);
const _kSurface = Color(0xFF1A1F4E);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kAmber  = Color(0xFFF59E0B);
const _kGreen  = Color(0xFF10B981);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _orbCtrl;
  late ProfileController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<ProfileController>();
    _orbCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl  = Get.find<AuthController>();
    final user      = authCtrl.currentUser.value;
    final initials  = user?.fullName.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join() ?? 'AR';
    final fullName  = user?.fullName ?? 'Alex Rodriguez';
    final email     = user?.email ?? 'alex@servicesync.com';
    final role      = user?.role ?? 'Senior Technician';

    return Scaffold(
      backgroundColor: _kDark,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _orbCtrl,
            builder: (_, __) {
              final t = _orbCtrl.value;
              return Stack(children: [
                Positioned(top: -60 + 30 * math.sin(t * math.pi),
                  right: -40 + 20 * math.cos(t * math.pi),
                  child: _glowOrb(240, _kBlue.withOpacity(0.20))),
                Positioned(bottom: 200 + 30 * math.cos(t * math.pi),
                  left: -40,
                  child: _glowOrb(200, _kPurple.withOpacity(0.15))),
              ]);
            },
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    _buildAvatarCard(initials, fullName, email, role),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 16),
                    _buildActivityChart(),
                    const SizedBox(height: 16),
                    _buildActions(context),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
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
      title: Text('My Profile', style: GoogleFonts.outfit(
        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => Get.toNamed('/settings'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.15))),
              child: const Icon(Icons.settings_outlined, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildAvatarCard(String initials, String fullName, String email, String role) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12))),
          child: Column(
            children: [
              
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [_kBlue, _kPurple]),
                  boxShadow: [
                    BoxShadow(color: _kBlue.withOpacity(0.4), blurRadius: 20, spreadRadius: 4),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.25), width: 2),
                ),
                child: Center(
                  child: Text(initials,
                    style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              Text(fullName,
                style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 4),
              Text(email, style: GoogleFonts.outfit(fontSize: 13, color: Colors.white54)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: _kCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _kCyan.withOpacity(0.4))),
                child: Text(role, style: GoogleFonts.outfit(
                  fontSize: 12, color: _kCyan, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
              
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(5, (i) => Icon(
                    i < _ctrl.rating.value.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: _kAmber, size: 20)),
                  const SizedBox(width: 8),
                  Text(_ctrl.rating.value.toStringAsFixed(1),
                    style: GoogleFonts.outfit(color: _kAmber, fontWeight: FontWeight.w700, fontSize: 14)),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Obx(() => Row(
      children: [
        Expanded(child: _statCard('Assigned', '${_ctrl.assignedJobs.value}', Icons.work_outline_rounded, _kBlue)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Completed', '${_ctrl.completedJobs.value}', Icons.check_circle_outline_rounded, _kGreen)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Success', '${(_ctrl.completionRate.value * 100).toInt()}%', Icons.trending_up_rounded, _kCyan)),
      ],
    ));
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.25))),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(value, style: GoogleFonts.outfit(
                fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 2),
              Text(label, style: GoogleFonts.outfit(fontSize: 11, color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityChart() {
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Weekly Activity', style: GoogleFonts.outfit(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 20),
              Obx(() => SizedBox(
                height: 120,
                child: BarChart(BarChartData(
                  barGroups: List.generate(_ctrl.weeklyActivity.length, (i) {
                    final val = _ctrl.weeklyActivity[i];
                    return BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                        toY: val,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter, end: Alignment.topCenter,
                          colors: [_kBlue.withOpacity(0.6), _kCyan]),
                        width: 18, borderRadius: BorderRadius.circular(6)),
                    ]);
                  }),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true, reservedSize: 20,
                        getTitlesWidget: (v, _) => Text(labels[v.toInt()],
                          style: GoogleFonts.outfit(fontSize: 11, color: Colors.white38)))),
                  ),
                  maxY: 12,
                )),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final items = [
      {'icon': Icons.settings_outlined,      'label': 'Settings',        'onTap': () => Get.toNamed('/settings')},
      {'icon': Icons.bar_chart_rounded,      'label': 'Analytics',       'onTap': () => Get.toNamed('/analytics')},
      {'icon': Icons.history_rounded,        'label': 'Report History',  'onTap': () => Get.toNamed('/report-history')},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'Chat with Admin', 'onTap': () => Get.toNamed('/chat')},
      {'icon': Icons.lock_outline_rounded,   'label': 'Change Password', 'onTap': () => _showChangePasswordSheet(context)},
      {'icon': Icons.logout_rounded,         'label': 'Sign Out',        'onTap': () => _ctrl.logout(), 'isDanger': true},
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12))),
          child: Column(
            children: items.asMap().entries.map((e) {
              final i = e.key; final a = e.value;
              final isDanger = a['isDanger'] == true;
              final color = isDanger ? const Color(0xFFEF4444) : Colors.white;
              return Column(
                children: [
                  if (i > 0) Divider(color: Colors.white.withOpacity(0.06), height: 1),
                  InkWell(
                    onTap: a['onTap'] as VoidCallback,
                    splashColor: Colors.white.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          Icon(a['icon'] as IconData,
                            color: isDanger ? const Color(0xFFEF4444) : Colors.white60, size: 20),
                          const SizedBox(width: 14),
                          Text(a['label'] as String,
                            style: GoogleFonts.outfit(fontSize: 15, color: color)),
                          const Spacer(),
                          if (!isDanger)
                            const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final curr = TextEditingController();
    final newP = TextEditingController();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F4E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Change Password', style: GoogleFonts.outfit(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 20),
            TextField(
              controller: curr, obscureText: true,
              style: GoogleFonts.outfit(color: Colors.white),
              decoration: _inputDeco('Current Password', Icons.lock_outline_rounded)),
            const SizedBox(height: 14),
            TextField(
              controller: newP, obscureText: true,
              style: GoogleFonts.outfit(color: Colors.white),
              decoration: _inputDeco('New Password (min. 8 chars)', Icons.lock_reset_rounded)),
            const SizedBox(height: 24),
            Obx(() => GestureDetector(
              onTap: _ctrl.isChangingPassword.value ? null : () =>
                  _ctrl.changePassword(currentPassword: curr.text, newPassword: newP.text),
              child: Container(
                height: 52, width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_kBlue, _kCyan]),
                  borderRadius: BorderRadius.circular(14)),
                child: Center(
                  child: _ctrl.isChangingPassword.value
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : Text('Update Password', style: GoogleFonts.outfit(
                        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
              ),
            )),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
    prefixIcon: Icon(icon, color: Colors.white38, size: 18),
    filled: true,
    fillColor: Colors.white.withOpacity(0.08),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.15))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.15))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kCyan)),
  );

  Widget _glowOrb(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, Colors.transparent])));
}

