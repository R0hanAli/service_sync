
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/job_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../../data/models/service_request_model.dart';

const _kDark   = Color(0xFF0A0E27);
const _kSurface= Color(0xFF1A1F4E);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kAmber  = Color(0xFFF59E0B);
const _kGreen  = Color(0xFF10B981);
const _kRed    = Color(0xFFEF4444);

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});
  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late JobController _jobCtrl;
  final TextEditingController _searchCtrl = TextEditingController();

  static const _tabs = ['All', 'Pending', 'Accepted', 'In Progress', 'Completed', 'Rejected'];
  static const _statuses = ['all', 'pending', 'accepted', 'inProgress', 'completed', 'rejected'];

  @override
  void initState() {
    super.initState();
    _jobCtrl = Get.find<JobController>();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        _jobCtrl.filterByStatus(_statuses[_tabCtrl.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDark,
      body: Stack(
        children: [
          _buildBackground(),
          NestedScrollView(
            headerSliverBuilder: (_, __) => [
              _buildAppBar(),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildTabBar()),
            ],
            body: _buildJobList(),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF0A0E27), Color(0xFF0D1333), Color(0xFF12163A)],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 110,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [_kSurface.withOpacity(0.85), _kDark.withOpacity(0.7)]),
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08))),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withOpacity(0.15))),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Service Jobs', style: GoogleFonts.outfit(
                              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                            Obx(() => Text(
                              '${_jobCtrl.totalCount} jobs assigned',
                              style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54))),
                          ],
                        ),
                      ),
                      Obx(() {
                        final notifCtrl = Get.find<NotificationController>();
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _iconBtn(Icons.notifications_outlined, () => Get.toNamed('/notifications')),
                            if (notifCtrl.unreadCount.value > 0)
                              Positioned(
                                right: -2, top: -2,
                                child: Container(
                                  width: 16, height: 16,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: _kDark, width: 1.5)),
                                  child: Center(
                                    child: Text('${notifCtrl.unreadCount.value}',
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
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

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.15))),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextField(
            controller: _searchCtrl,
            onChanged: _jobCtrl.searchJobs,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search jobs, customers, addresses...',
              hintStyle: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38, size: 20),
              suffixIcon: Obx(() => _jobCtrl.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: Colors.white38, size: 18),
                      onPressed: () { _searchCtrl.clear(); _jobCtrl.searchJobs(''); })
                  : const SizedBox.shrink()),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _kCyan, width: 1.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _tabs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            return Obx(() {
              final isSelected = _jobCtrl.selectedFilter.value == _statuses[i];
              return GestureDetector(
                onTap: () {
                  _tabCtrl.animateTo(i);
                  _jobCtrl.filterByStatus(_statuses[i]);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(colors: [_kBlue, _kCyan])
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.12)),
                    boxShadow: isSelected
                        ? [BoxShadow(color: _kCyan.withOpacity(0.3), blurRadius: 10)]
                        : [],
                  ),
                  child: Text(_tabs[i],
                    style: GoogleFonts.outfit(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.white60)),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildJobList() {
    return Obx(() {
      if (_jobCtrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: _kCyan));
      }
      final jobs = _jobCtrl.filteredJobs;
      if (jobs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.work_off_outlined, size: 64, color: Colors.white24),
              const SizedBox(height: 16),
              Text('No jobs found', style: GoogleFonts.outfit(
                color: Colors.white38, fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text('Try a different filter or search term',
                style: GoogleFonts.outfit(color: Colors.white24, fontSize: 13)),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: _jobCtrl.loadJobs,
        color: _kCyan,
        backgroundColor: _kSurface,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          itemCount: jobs.length,
          itemBuilder: (_, i) => _JobCard(job: jobs[i], onTap: () {
            _jobCtrl.selectJob(jobs[i]);
            Get.toNamed('/job-details');
          }),
        ),
      );
    });
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed('/qr-verify'),
      backgroundColor: _kBlue,
      icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
      label: Text('Scan QR', style: GoogleFonts.outfit(
        color: Colors.white, fontWeight: FontWeight.w600)),
      elevation: 4,
    );
  }
}


class _JobCard extends StatelessWidget {
  const _JobCard({required this.job, required this.onTap});
  final ServiceRequestModel job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(job.status);
    final priorityColor = _priorityColor(job.priority);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.04)]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.10), width: 0.5),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: priorityColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(job.id,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12, color: _kCyan, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                                ),
                                _StatusChip(status: job.status, color: statusColor),
                                const SizedBox(width: 8),
                                _PriorityChip(priority: job.priority, color: priorityColor),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(job.customerName,
                              style: GoogleFonts.outfit(
                                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                            const SizedBox(height: 2),
                            Text(job.serviceType,
                              style: GoogleFonts.outfit(fontSize: 13, color: Colors.white60)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, color: Colors.white38, size: 14),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(job.customerAddress,
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(fontSize: 12, color: Colors.white38))),
                                const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 18),
                              ],
                            ),
                          ],
                        ),
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
      case 'high':      return const Color(0xFFF97316);
      case 'medium':    return _kAmber;
      default:          return _kGreen;
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.color});
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = status == 'inProgress' ? 'In Progress'
      : status[0].toUpperCase() + status.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4))),
      child: Text(label,
        style: GoogleFonts.outfit(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority, required this.color});
  final String priority;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3))),
      child: Text(priority.toUpperCase(),
        style: GoogleFonts.outfit(fontSize: 9, color: color, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    );
  }
}

