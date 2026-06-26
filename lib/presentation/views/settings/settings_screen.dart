
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/auth_controller.dart';

const _kDark   = Color(0xFF0A0E27);
const _kSurface = Color(0xFF1A1F4E);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kGreen  = Color(0xFF10B981);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<SettingsController>();
    return Scaffold(
      backgroundColor: _kDark,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0A0E27), Color(0xFF0D1333)]))),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSection('Appearance', [
                      _SettingsTile(
                        icon: Icons.dark_mode_outlined,
                        iconColor: _kPurple,
                        title: 'Dark Mode',
                        subtitle: 'Use dark theme across the app',
                        trailing: Obx(() => _glassSwitch(ctrl.isDarkMode.value,
                            (v) => ctrl.toggleTheme(v), _kPurple)),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSection('Notifications', [
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        iconColor: _kBlue,
                        title: 'Push Notifications',
                        subtitle: 'Receive alerts for new jobs',
                        trailing: Obx(() => _glassSwitch(ctrl.notificationsEnabled.value,
                            ctrl.toggleNotifications, _kBlue)),
                      ),
                      _SettingsTile(
                        icon: Icons.volume_up_outlined,
                        iconColor: _kGreen,
                        title: 'Sound',
                        subtitle: 'Play sound for alerts',
                        trailing: Obx(() => _glassSwitch(ctrl.soundEnabled.value,
                            ctrl.toggleSound, _kGreen)),
                      ),
                      _SettingsTile(
                        icon: Icons.vibration_rounded,
                        iconColor: _kCyan,
                        title: 'Vibration',
                        subtitle: 'Vibrate for alerts',
                        trailing: Obx(() => _glassSwitch(ctrl.vibrationEnabled.value,
                            ctrl.toggleVibration, _kCyan)),
                      ),
                      _SettingsTile(
                        icon: Icons.warning_amber_rounded,
                        iconColor: const Color(0xFFEF4444),
                        title: 'Emergency Alerts',
                        subtitle: 'Always-on emergency job notifications',
                        trailing: Obx(() => _glassSwitch(ctrl.emergencyAlertsEnabled.value,
                            ctrl.toggleEmergencyAlerts, const Color(0xFFEF4444))),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSection('Security', [
                      _SettingsTile(
                        icon: Icons.fingerprint_rounded,
                        iconColor: _kGreen,
                        title: 'Biometric Login',
                        subtitle: 'Use fingerprint / Face ID',
                        trailing: Obx(() => _glassSwitch(ctrl.biometricEnabled.value,
                            ctrl.toggleBiometric, _kGreen)),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSection('Account', [
                      _SettingsTile(
                        icon: Icons.person_outline_rounded,
                        iconColor: _kCyan,
                        title: 'My Profile',
                        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 18),
                        onTap: () => Get.toNamed('/profile'),
                      ),
                      _SettingsTile(
                        icon: Icons.lock_outline_rounded,
                        iconColor: _kBlue,
                        title: 'Change Password',
                        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 18),
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSection('About', [
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        iconColor: Colors.white38,
                        title: 'App Version',
                        trailing: Text('v1.0.0', style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13)),
                      ),
                      _SettingsTile(
                        icon: Icons.description_outlined,
                        iconColor: Colors.white38,
                        title: 'Privacy Policy',
                        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 18),
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 16),
                    
                    GestureDetector(
                      onTap: ctrl.logout,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.30))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                                const SizedBox(width: 10),
                                Text('Sign Out', style: GoogleFonts.outfit(
                                  fontSize: 16, color: const Color(0xFFEF4444), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
      title: Text('Settings', style: GoogleFonts.outfit(
        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
      centerTitle: true,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.transparent)),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title, style: GoogleFonts.outfit(
            fontSize: 12, color: Colors.white38, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.04)]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.10))),
              child: Column(
                children: children.asMap().entries.map((e) => Column(
                  children: [
                    if (e.key > 0) Divider(color: Colors.white.withOpacity(0.06), height: 1),
                    e.value,
                  ],
                )).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _glassSwitch(bool value, Function(bool) onChanged, Color activeColor) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      inactiveTrackColor: Colors.white12,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white.withOpacity(0.03),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: iconColor.withOpacity(0.25))),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(
                    fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: GoogleFonts.outfit(fontSize: 12, color: Colors.white38)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }
}
