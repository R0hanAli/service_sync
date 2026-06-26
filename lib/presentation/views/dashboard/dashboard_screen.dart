import 'dart:math' as math;
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/job_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../../data/models/service_request_model.dart';


const _kDarkBg = Color(0xFF0A0E27);
const _kSurface = Color(0xFF1A1F4E);
const _kCyan = Color(0xFF00D4FF);
const _kPurple = Color(0xFF7C3AED);
const _kBlue = Color(0xFF3B82F6);
const _kGreen = Color(0xFF10B981);
const _kAmber = Color(0xFFF59E0B);


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late DashboardController _ctrl;
  late AuthController _authCtrl;
  late AnimationController _orbController;
  late AnimationController _insightPageController;
  late PageController _insightPager;
  final RxInt _currentInsightPage = 0.obs;

  String _getUserInitials(String name) {
    if (name.isEmpty) return 'US';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  String _getFirstName(String name) {
    if (name.isEmpty) return 'User';
    return name.trim().split(RegExp(r'\s+'))[0];
  }

  @override
  void initState() {
    super.initState();
    _authCtrl = Get.find<AuthController>();
    _ctrl = Get.put(DashboardController());
    Get.put(JobController());

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _insightPager = PageController();
    _insightPageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    
    Future.delayed(const Duration(seconds: 2), () {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    Future.doWhile(() async {
      if (!mounted) return false;
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      final insights = _ctrl.aiInsights;
      if (insights.isEmpty) return true;
      final next = ((_currentInsightPage.value + 1) % insights.length).toInt();
      _currentInsightPage.value = next;
      if (_insightPager.hasClients) {
        _insightPager.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      return true;
    });
  }

  @override
  void dispose() {
    _orbController.dispose();
    _insightPageController.dispose();
    _insightPager.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDarkBg,
      body: Stack(
        children: [
          
          _buildAnimatedBackground(),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    _buildAIInsightsWidget(),
                    const SizedBox(height: 24),
                    _buildWeeklyPerformanceChart(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildRecentActivities(),
                    const SizedBox(height: 24),
                    _buildCompletionRateCard(),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
          
          Obx(() {
            if (!_ctrl.isSyncing.value && !_ctrl.isOffline.value) {
              return const SizedBox.shrink();
            }
            return Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildSyncBanner(),
            );
          }),
        ],
      ),
    );
  }

  
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _orbController,
      builder: (_, __) {
        final t = _orbController.value;
        return Stack(
          children: [
            Positioned(
              top: -80 + 40 * math.sin(t * math.pi),
              left: -60 + 30 * math.cos(t * math.pi),
              child: _glowOrb(280, _kBlue.withOpacity(0.25)),
            ),
            Positioned(
              top: 200 + 50 * math.cos(t * math.pi),
              right: -80 + 40 * math.sin(t * math.pi),
              child: _glowOrb(240, _kPurple.withOpacity(0.20)),
            ),
            Positioned(
              bottom: 300 + 40 * math.sin(t * math.pi * 1.5),
              left: 60 + 20 * math.cos(t * math.pi * 0.7),
              child: _glowOrb(200, _kCyan.withOpacity(0.15)),
            ),
          ],
        );
      },
    );
  }

  Widget _glowOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }

  
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _kSurface.withOpacity(0.85),
                    _kDarkBg.withOpacity(0.70),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: _kGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Online',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: _kGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Obx(() {
                              final user = _authCtrl.currentUser.value;
                              final firstName = user != null ? _getFirstName(user.fullName) : 'User';
                              return Text(
                                '${_getGreeting()}, $firstName 👋',
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('EEEE, MMMM d • h:mm a')
                                  .format(DateTime.now()),
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          
                          Obx(() {
                            final notifCtrl =
                                Get.find<NotificationController>();
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                _glassIconButton(
                                  Icons.notifications_outlined,
                                  onTap: () =>
                                      Get.toNamed('/notifications'),
                                ),
                                if (notifCtrl.unreadCount.value > 0)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFEF4444),
                                            Color(0xFFDC2626)
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: _kDarkBg, width: 1.5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${notifCtrl.unreadCount.value}',
                                          style: GoogleFonts.outfit(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                          const SizedBox(width: 10),
                          
                          Obx(() {
                            final user = _authCtrl.currentUser.value;
                            final initials = user != null ? _getUserInitials(user.fullName) : 'US';
                            final hasImage = user?.profileImage != null && user!.profileImage!.isNotEmpty;
                            return Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [_kBlue, _kPurple],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                                image: hasImage
                                    ? DecorationImage(
                                        image: NetworkImage(user.profileImage!),
                                        fit: BoxFit.cover)
                                    : null,
                              ),
                              child: hasImage
                                  ? null
                                  : Center(
                                      child: Text(
                                        initials,
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            );
                          }),
                        ],
                      ),
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

  Widget _glassIconButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  
  Widget _buildStatsRow() {
    return SizedBox(
      height: 130,
      child: Obx(() {
        if (_ctrl.isLoading.value) {
          return _buildStatsShimmer();
        }
        final stats = [
          {
            'label': 'Assigned',
            'value': _ctrl.assignedJobs.value,
            'icon': Icons.work_outline_rounded,
            'colors': [_kBlue, const Color(0xFF1D4ED8)],
          },
          {
            'label': 'Pending',
            'value': _ctrl.pendingJobs.value,
            'icon': Icons.hourglass_top_rounded,
            'colors': [_kAmber, const Color(0xFFD97706)],
          },
          {
            'label': 'Completed',
            'value': _ctrl.completedJobs.value,
            'icon': Icons.check_circle_outline_rounded,
            'colors': [_kGreen, const Color(0xFF059669)],
          },
          {
            'label': 'Today',
            'value': _ctrl.todaysTasks.value,
            'icon': Icons.calendar_today_rounded,
            'colors': [_kPurple, const Color(0xFF5B21B6)],
          },
        ];
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: stats.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final s = stats[i];
            return _StatCard(
              label: s['label'] as String,
              value: s['value'] as int,
              icon: s['icon'] as IconData,
              gradientColors: s['colors'] as List<Color>,
            );
          },
        );
      }),
    );
  }

  Widget _buildStatsShimmer() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => _ShimmerCard(width: 160, height: 120),
    );
  }

  
  Widget _buildAIInsightsWidget() {
    return Obx(() {
      if (_ctrl.isLoading.value || _ctrl.aiInsights.isEmpty) {
        return const SizedBox.shrink();
      }
      return _GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('✨', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'AI Insights',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kBlue, _kPurple],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'BETA',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: PageView.builder(
                controller: _insightPager,
                itemCount: _ctrl.aiInsights.length,
                onPageChanged: (i) => _currentInsightPage.value = i,
                itemBuilder: (_, i) {
                  final insight = _ctrl.aiInsights[i];
                  return _InsightCard(insight: insight);
                },
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _ctrl.aiInsights.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentInsightPage.value == i ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentInsightPage.value == i
                            ? _kCyan
                            : Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      );
    });
  }

  
  Widget _buildWeeklyPerformanceChart() {
    return Obx(() {
      if (_ctrl.isLoading.value) {
        return _ShimmerCard(width: double.infinity, height: 200);
      }
      return _GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Performance',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _ctrl.weekRangeLabel,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _kBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _kBlue.withOpacity(0.3)),
                  ),
                  child: Text(
                    '${_ctrl.completedJobs.value} Done',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: _kBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: _WeeklyJobsChart(
                data: _ctrl.weeklyJobData,
                labels: _ctrl.weeklyLabels,
              ),
            ),
          ],
        ),
      );
    });
  }

  
  Widget _buildQuickActions() {
    final actions = [
      {
        'label': 'View Jobs',
        'icon': Icons.work_outline_rounded,
        'colors': [_kBlue, const Color(0xFF1D4ED8)],
        'route': '/jobs',
      },
      {
        'label': 'Create Report',
        'icon': Icons.description_outlined,
        'colors': [_kGreen, const Color(0xFF059669)],
        'route': '/reports',
      },
      {
        'label': 'Notifications',
        'icon': Icons.notifications_outlined,
        'colors': [_kAmber, const Color(0xFFD97706)],
        'route': '/notifications',
        'badge': true,
      },
      {
        'label': 'My Profile',
        'icon': Icons.person_outline_rounded,
        'colors': [_kPurple, const Color(0xFF5B21B6)],
        'route': '/profile',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: actions.map((a) {
            return _QuickActionCard(
              label: a['label'] as String,
              icon: a['icon'] as IconData,
              gradientColors: a['colors'] as List<Color>,
              onTap: () => Get.toNamed(a['route'] as String),
              showBadge: a['badge'] == true,
            );
          }).toList(),
        ),
      ],
    );
  }

  
  Widget _buildRecentActivities() {
    return Obx(() {
      if (_ctrl.isLoading.value) {
        return Column(
          children: [
            _ShimmerCard(width: double.infinity, height: 90),
            const SizedBox(height: 10),
            _ShimmerCard(width: double.infinity, height: 90),
            const SizedBox(height: 10),
            _ShimmerCard(width: double.infinity, height: 90),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activities',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed('/jobs'),
                child: Text(
                  'View All',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: _kCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._ctrl.recentJobs.map(
            (job) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DashboardJobCard(job: job),
            ),
          ),
        ],
      );
    });
  }

  
  Widget _buildCompletionRateCard() {
    return Obx(() {
      if (_ctrl.isLoading.value) {
        return _ShimmerCard(width: double.infinity, height: 200);
      }
      return _GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completion Rate',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          startDegreeOffset: -90,
                          sectionsSpace: 0,
                          centerSpaceRadius: 36,
                          sections: [
                            PieChartSectionData(
                              value: _ctrl.overallCompletionRate.value * 100,
                              color: _kCyan,
                              radius: 16,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: (1 - _ctrl.overallCompletionRate.value) *
                                  100,
                              color: Colors.white.withOpacity(0.08),
                              radius: 16,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(_ctrl.overallCompletionRate.value * 100).toInt()}%',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Overall',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                
                Expanded(
                  child: Column(
                    children: [
                      _ProgressBar(
                          label: 'Today',
                          value: _ctrl.todayCompletionRate.value,
                          color: _kGreen),
                      const SizedBox(height: 12),
                      _ProgressBar(
                          label: 'This Week',
                          value: _ctrl.weekCompletionRate.value,
                          color: _kBlue),
                      const SizedBox(height: 12),
                      _ProgressBar(
                          label: 'This Month',
                          value: _ctrl.monthCompletionRate.value,
                          color: _kPurple),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  
  Widget _buildSyncBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _kAmber.withOpacity(0.25),
                _kAmber.withOpacity(0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kAmber.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _kAmber,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _ctrl.syncStatus,
                style: GoogleFonts.outfit(
                  color: _kAmber,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(Icons.sync_rounded, color: _kAmber, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}



class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _GlassCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding:
              padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final int value;
  final IconData icon;
  final List<Color> gradientColors;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradientColors,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _countAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _countAnim = Tween<double>(begin: 0, end: widget.value.toDouble())
        .animate(CurvedAnimation(
            parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 160,
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 18),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _countAnim,
                builder: (_, __) => Text(
                  '${_countAnim.value.toInt()}',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                widget.label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final Map<String, String> insight;

  const _InsightCard({required this.insight});

  Color _getColor() {
    switch (insight['gradient']) {
      case 'cyan':
        return _kCyan;
      case 'green':
        return _kGreen;
      case 'amber':
        return _kAmber;
      default:
        return _kBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text(insight['emoji'] ?? '✨',
              style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  insight['title'] ?? '',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  insight['text'] ?? '',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyJobsChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;

  const _WeeklyJobsChart({required this.data, required this.labels});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    final maxY = data.reduce(math.max) + 2;
    return BarChart(
      BarChartData(
        maxY: maxY,
        backgroundColor: Colors.transparent,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.white.withOpacity(0.06),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= labels.length) {
                  return const SizedBox.shrink();
                }
                final isToday = idx == DateTime.now().weekday - 1;
                return Text(
                  labels[idx],
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: isToday
                        ? _kCyan
                        : Colors.white.withOpacity(0.5),
                    fontWeight: isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              },
              reservedSize: 24,
            ),
          ),
        ),
        barGroups: List.generate(data.length, (i) {
          final isToday = i == DateTime.now().weekday - 1;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data[i],
                width: 18,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: isToday
                      ? [_kCyan.withOpacity(0.5), _kCyan]
                      : [
                          _kBlue.withOpacity(0.3),
                          _kBlue.withOpacity(0.8)
                        ],
                ),
              ),
            ],
          );
        }),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => _kSurface,
            getTooltipItem: (group, _, rod, __) {
              return BarTooltipItem(
                '${rod.toY.toInt()} jobs',
                GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final bool showBadge;

  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                    if (showBadge)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.white.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardJobCard extends StatelessWidget {
  final ServiceRequestModel job;

  const _DashboardJobCard({required this.job});

  Color _statusColor() {
    switch (job.status) {
      case 'inProgress':
        return _kBlue;
      case 'completed':
        return _kGreen;
      case 'pending':
        return _kAmber;
      case 'accepted':
        return _kCyan;
      case 'rejected':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  String _statusLabel() {
    switch (job.status) {
      case 'inProgress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      default:
        return job.status;
    }
  }

  Color _priorityColor() {
    switch (job.priority) {
      case 'emergency':
        return const Color(0xFFEF4444);
      case 'high':
        return _kAmber;
      case 'medium':
        return _kBlue;
      default:
        return _kGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    return GestureDetector(
      onTap: () {
        final jobCtrl = Get.find<JobController>();
        jobCtrl.selectJob(job);
        Get.toNamed('/job-detail', arguments: job);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: job.isEmergency
                    ? const Color(0xFFEF4444).withOpacity(0.4)
                    : Colors.white.withOpacity(0.14),
              ),
            ),
            child: Row(
              children: [
                
                Container(
                  width: 4,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withOpacity(0.3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            job.requestId,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: _kCyan,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          _Badge(
                              label: _statusLabel(), color: statusColor),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        job.serviceType,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded,
                              size: 12,
                              color: Colors.white.withOpacity(0.5)),
                          const SizedBox(width: 4),
                          Text(
                            job.customerName,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _priorityColor(),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            job.priority.capitalize!,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: _priorityColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ProgressBar(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  final double width;
  final double height;

  const _ShimmerCard({required this.width, required this.height});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.05 + 0.04 * _anim.value),
              Colors.white.withOpacity(0.08 + 0.06 * _anim.value),
              Colors.white.withOpacity(0.05 + 0.04 * _anim.value),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          border:
              Border.all(color: Colors.white.withOpacity(0.10)),
        ),
      ),
    );
  }
}




