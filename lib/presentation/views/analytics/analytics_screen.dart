
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/analytics_controller.dart';

const _kDark   = Color(0xFF0A0E27);
const _kSurface = Color(0xFF1A1F4E);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kAmber  = Color(0xFFF59E0B);
const _kGreen  = Color(0xFF10B981);

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AnalyticsController>();
    return Scaffold(
      backgroundColor: _kDark,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0A0E27), Color(0xFF0D1333), Color(0xFF12163A)]))),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(ctrl),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: Obx(() {
                  if (ctrl.isLoading.value) {
                    return const SliverToBoxAdapter(
                      child: SizedBox(height: 300,
                        child: Center(child: CircularProgressIndicator(color: _kCyan))));
                  }
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSummaryRow(ctrl),
                      const SizedBox(height: 20),
                      _buildWeeklyChart(ctrl),
                      const SizedBox(height: 20),
                      _buildMonthlyChart(ctrl),
                      const SizedBox(height: 20),
                      _buildResolutionByType(ctrl),
                    ]),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(AnalyticsController ctrl) {
    return SliverAppBar(
      expandedHeight: 100,
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
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: ctrl.refresh,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.15))),
              child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
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
                  padding: const EdgeInsets.fromLTRB(60, 8, 60, 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Analytics', style: GoogleFonts.outfit(
                        fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('Performance Overview', style: GoogleFonts.outfit(
                        fontSize: 12, color: Colors.white54)),
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

  Widget _buildSummaryRow(AnalyticsController ctrl) {
    return Row(children: [
      Expanded(child: _statCard('Completed', '${ctrl.totalCompleted.value}',
        Icons.check_circle_outline_rounded, _kGreen)),
      const SizedBox(width: 10),
      Expanded(child: _statCard('Pending', '${ctrl.totalPending.value}',
        Icons.hourglass_top_rounded, _kAmber)),
      const SizedBox(width: 10),
      Expanded(child: _statCard('Success Rate',
        '${(ctrl.avgCompletionRate.value * 100).toInt()}%',
        Icons.trending_up_rounded, _kCyan)),
    ]);
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.25))),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 8),
              Text(value, style: GoogleFonts.outfit(
                fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 2),
              Text(label, style: GoogleFonts.outfit(fontSize: 10, color: Colors.white54),
                textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(AnalyticsController ctrl) {
    return _glassCard(
      title: 'Weekly Completions',
      icon: Icons.bar_chart_rounded,
      child: SizedBox(
        height: 150,
        child: BarChart(BarChartData(
          barGroups: List.generate(ctrl.weeklyCompletions.length, (i) {
            final v = ctrl.weeklyCompletions[i];
            return BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: v,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter, end: Alignment.topCenter,
                  colors: [_kBlue.withOpacity(0.7), _kCyan]),
                width: 20, borderRadius: BorderRadius.circular(6)),
            ]);
          }),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Colors.white.withOpacity(0.05), strokeWidth: 1),
            drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(
              showTitles: true, reservedSize: 22,
              getTitlesWidget: (v, _) => Text(ctrl.weekDayLabels[v.toInt()],
                style: GoogleFonts.outfit(fontSize: 11, color: Colors.white38)))),
          ),
          maxY: 12,
        )),
      ),
    );
  }

  Widget _buildMonthlyChart(AnalyticsController ctrl) {
    final months = ctrl.monthLabels.sublist(0, ctrl.monthlyRates.length);
    return _glassCard(
      title: 'Monthly Completion Rate (%)',
      icon: Icons.show_chart_rounded,
      child: SizedBox(
        height: 150,
        child: LineChart(LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(ctrl.monthlyRates.length, (i) =>
                  FlSpot(i.toDouble(), ctrl.monthlyRates[i])),
              isCurved: true,
              gradient: const LinearGradient(colors: [_kPurple, _kCyan]),
              barWidth: 2.5,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [_kCyan.withOpacity(0.25), Colors.transparent])),
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) =>
                  FlDotCirclePainter(radius: 4, color: _kCyan,
                    strokeWidth: 2, strokeColor: Colors.white)),
            ),
          ],
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Colors.white.withOpacity(0.05), strokeWidth: 1),
            drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(
              showTitles: true, reservedSize: 22,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i >= months.length) return const SizedBox.shrink();
                return Text(months[i],
                  style: GoogleFonts.outfit(fontSize: 10, color: Colors.white38));
              })),
          ),
          minY: 0, maxY: 100,
        )),
      ),
    );
  }

  Widget _buildResolutionByType(AnalyticsController ctrl) {
    return _glassCard(
      title: 'Avg Resolution Time (hours)',
      icon: Icons.timer_outlined,
      child: Column(
        children: ctrl.avgResolutionByType.entries.map((e) {
          final fraction = e.value / 5;
          final color = fraction < 0.4 ? _kGreen : fraction < 0.7 ? _kAmber : _kCyan;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(children: [
                  Text(e.key, style: GoogleFonts.outfit(fontSize: 13, color: Colors.white70)),
                  const Spacer(),
                  Text('${e.value.toStringAsFixed(1)}h',
                    style: GoogleFonts.outfit(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    color: color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _glassCard({required String title, required IconData icon, required Widget child}) {
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
              Row(children: [
                Icon(icon, color: _kCyan, size: 18),
                const SizedBox(width: 8),
                Text(title, style: GoogleFonts.outfit(
                  fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

