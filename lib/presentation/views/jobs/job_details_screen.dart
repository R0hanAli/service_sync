
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/job_controller.dart';
import '../../../data/models/service_request_model.dart';

const _kDark   = Color(0xFF0A0E27);
const _kSurface = Color(0xFF1A1F4E);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kAmber  = Color(0xFFF59E0B);
const _kGreen  = Color(0xFF10B981);
const _kRed    = Color(0xFFEF4444);
const _kOrange = Color(0xFFF97316);

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobCtrl = Get.find<JobController>();
    return Obx(() {
      final job = jobCtrl.selectedJob.value;
      if (job == null) {
        return Scaffold(
          backgroundColor: _kDark,
          body: const Center(child: Text('No job selected', style: TextStyle(color: Colors.white))),
        );
      }
      return _buildJobDetails(context, job, jobCtrl);
    });
  }

  Widget _buildJobDetails(BuildContext context, ServiceRequestModel job, JobController ctrl) {
    final priorityColor = _priorityColor(job.priority);
    final statusColor   = _statusColor(job.status);

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
          
          Positioned(top: -60, right: -60,
            child: _glowOrb(200, _kCyan.withOpacity(0.12))),
          Positioned(bottom: 100, left: -60,
            child: _glowOrb(180, _kPurple.withOpacity(0.10))),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(job, priorityColor, statusColor),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    _buildInfoCard(job, statusColor, priorityColor),
                    const SizedBox(height: 16),
                    _buildCustomerCard(job),
                    const SizedBox(height: 16),
                    _buildDescriptionCard(job),
                    const SizedBox(height: 16),
                    _buildLocationCard(job),
                    const SizedBox(height: 16),
                    _buildActionsCard(job, ctrl),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ServiceRequestModel job, Color priorityColor, Color statusColor) {
    return SliverAppBar(
      expandedHeight: 120,
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
            onTap: () => Get.toNamed('/maps'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.15))),
              child: const Icon(Icons.map_outlined, color: Colors.white, size: 18),
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
                border: Border(bottom: BorderSide(
                  color: priorityColor.withOpacity(0.3), width: 1.5))),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(60, 8, 60, 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(job.id,
                        style: GoogleFonts.outfit(
                          fontSize: 13, color: _kCyan, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      Text(job.serviceType,
                        style: GoogleFonts.outfit(
                          fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700)),
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

  Widget _buildInfoCard(ServiceRequestModel job, Color statusColor, Color priorityColor) {
    return _glassCard(
      child: Row(
        children: [
          _infoBadge('Status', _statusLabel(job.status), statusColor),
          const SizedBox(width: 12),
          _infoBadge('Priority', job.priority.toUpperCase(), priorityColor),
          const Spacer(),
          if (job.scheduledDate != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Scheduled', style: GoogleFonts.outfit(fontSize: 11, color: Colors.white38)),
                const SizedBox(height: 2),
                Text(DateFormat('MMM d, h:mm a').format(job.scheduledDate!),
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerCard(ServiceRequestModel job) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Customer', Icons.person_outline_rounded),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [_kBlue, _kPurple]),
                ),
                child: Center(
                  child: Text(job.customerName[0],
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.customerName,
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(job.customerPhone,
                      style: GoogleFonts.outfit(fontSize: 13, color: Colors.white54)),
                  ],
                ),
              ),
              _actionIconBtn(Icons.call_rounded, _kGreen, () {}),
              const SizedBox(width: 8),
              _actionIconBtn(Icons.message_outlined, _kBlue, () => Get.toNamed('/chat')),
              const SizedBox(width: 8),
              _actionIconBtn(Icons.map_outlined, _kPurple, () => Get.toNamed('/maps')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(ServiceRequestModel job) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Issue Description', Icons.description_outlined),
          const SizedBox(height: 12),
          Text(job.description,
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70, height: 1.6)),
          if (job.estimatedDuration != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _kBlue.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kBlue.withOpacity(0.25))),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, color: _kBlue, size: 18),
                  const SizedBox(width: 10),
                  Text('Estimated duration: ${job.estimatedDuration} min',
                    style: GoogleFonts.outfit(fontSize: 13, color: _kBlue, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationCard(ServiceRequestModel job) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Location', Icons.location_on_outlined),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(job.customerAddress,
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70, height: 1.5)),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Get.toNamed('/maps'),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_kBlue, _kCyan]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: _kCyan.withOpacity(0.3), blurRadius: 12)]),
                  child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(ServiceRequestModel job, JobController ctrl) {
    final actions = _getActions(job.status);
    if (actions.isEmpty) return const SizedBox.shrink();
    return Column(
      children: actions.map((a) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Obx(() => _ActionButton(
          label: a['label'] as String,
          icon: a['icon'] as IconData,
          gradient: a['gradient'] as LinearGradient,
          isLoading: ctrl.isLoading.value,
          onTap: () async {
            final fn = a['action'] as Function(String);
            await fn(job.id);
            if (job.status == 'inProgress') {
              Get.toNamed('/service-report');
            }
          },
        )),
      )).toList(),
    );
  }

  List<Map<String, dynamic>> _getActions(String status) {
    switch (status) {
      case 'pending':
        return [
          {'label': 'Accept Job',   'icon': Icons.check_circle_outline_rounded,
           'gradient': const LinearGradient(colors: [_kBlue, _kCyan]),
           'action': (String id) => Get.find<JobController>().acceptJob(id)},
          {'label': 'Reject Job',   'icon': Icons.cancel_outlined,
           'gradient': const LinearGradient(colors: [_kRed, Color(0xFFDC2626)]),
           'action': (String id) => Get.find<JobController>().rejectJob(id)},
        ];
      case 'accepted':
        return [
          {'label': 'Scan QR & Start', 'icon': Icons.qr_code_scanner_rounded,
           'gradient': const LinearGradient(colors: [_kPurple, Color(0xFF5B21B6)]),
           'action': (String id) => Get.toNamed('/qr-verify')},
        ];
      case 'inProgress':
        return [
          {'label': 'Complete Job & Write Report', 'icon': Icons.assignment_turned_in_outlined,
           'gradient': const LinearGradient(colors: [_kGreen, Color(0xFF059669)]),
           'action': (String id) => Get.find<JobController>().completeJob(id)},
        ];
      default:
        return [];
    }
  }

  
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.12))),
          child: child,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(children: [
      Icon(icon, color: _kCyan, size: 16),
      const SizedBox(width: 8),
      Text(title, style: GoogleFonts.outfit(
        fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _infoBadge(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 10, color: Colors.white38)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.4))),
          child: Text(value, style: GoogleFonts.outfit(
            fontSize: 11, color: color, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _actionIconBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3))),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _glowOrb(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, Colors.transparent])));

  String _statusLabel(String s) {
    if (s == 'inProgress') return 'In Progress';
    return s[0].toUpperCase() + s.substring(1);
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'pending':    return _kAmber;
      case 'accepted':   return _kBlue;
      case 'inProgress': return _kPurple;
      case 'completed':  return _kGreen;
      case 'rejected':   return _kRed;
      default:           return Colors.white38;
    }
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'emergency': return _kRed;
      case 'high':      return _kOrange;
      case 'medium':    return _kAmber;
      default:          return _kGreen;
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label, required this.icon, required this.gradient,
    required this.isLoading, required this.onTap,
  });
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isLoading ? 0.7 : 1.0,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(
              color: gradient.colors.first.withOpacity(0.4),
              blurRadius: 16, offset: const Offset(0, 6))]),
          child: Center(
            child: isLoading
              ? const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(label, style: GoogleFonts.outfit(
                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}

