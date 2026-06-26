
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/calendar_controller.dart';
import '../../../data/models/service_request_model.dart';

const _kDark   = Color(0xFF0A0E27);
const _kSurface = Color(0xFF1A1F4E);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kAmber  = Color(0xFFF59E0B);
const _kGreen  = Color(0xFF10B981);
const _kRed    = Color(0xFFEF4444);

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CalendarController>();
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
              _buildAppBar(ctrl),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildCalendarGrid(ctrl),
                    const SizedBox(height: 20),
                    _buildDayAgenda(ctrl),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(CalendarController ctrl) {
    return SliverAppBar(
      expandedHeight: 110,
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
                  padding: const EdgeInsets.fromLTRB(56, 8, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Schedule', style: GoogleFonts.outfit(
                              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                            Obx(() => Text(
                              DateFormat('MMMM yyyy').format(ctrl.focusedMonth.value),
                              style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54))),
                          ],
                        ),
                      ),
                      
                      Row(children: [
                        _navBtn(Icons.chevron_left_rounded, ctrl.previousMonth),
                        const SizedBox(width: 8),
                        _navBtn(Icons.chevron_right_rounded, ctrl.nextMonth),
                      ]),
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

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.15))),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildCalendarGrid(CalendarController ctrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12))),
          child: Obx(() {
            final month = ctrl.focusedMonth.value;
            final firstDay = DateTime(month.year, month.month, 1);
            final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
            final startWeekday = firstDay.weekday % 7; 
            final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

            return Column(
              children: [
                
                Row(children: days.map((d) => Expanded(
                  child: Center(child: Text(d, style: GoogleFonts.outfit(
                    fontSize: 11, color: Colors.white38, fontWeight: FontWeight.w600))))).toList()),
                const SizedBox(height: 8),
                
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, childAspectRatio: 1),
                  itemCount: startWeekday + daysInMonth,
                  itemBuilder: (_, i) {
                    if (i < startWeekday) return const SizedBox.shrink();
                    final day = DateTime(month.year, month.month, i - startWeekday + 1);
                    final isToday = _isToday(day);
                    final isSelected = ctrl.selectedDay.value != null &&
                        _isSameDay(day, ctrl.selectedDay.value!);
                    final hasEvent = ctrl.hasEvents(day);
                    return GestureDetector(
                      onTap: () => ctrl.selectDay(day),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          gradient: isSelected
                            ? const LinearGradient(colors: [_kBlue, _kCyan])
                            : isToday
                            ? LinearGradient(colors: [_kPurple.withOpacity(0.4), _kPurple.withOpacity(0.2)])
                            : null,
                          color: isSelected || isToday ? null : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isToday && !isSelected
                            ? Border.all(color: _kPurple, width: 1.5)
                            : null,
                          boxShadow: isSelected
                            ? [BoxShadow(color: _kCyan.withOpacity(0.3), blurRadius: 8)]
                            : [],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text('${day.day}',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                                color: isSelected ? Colors.white :
                                  isToday ? _kPurple : Colors.white60)),
                            if (hasEvent && !isSelected)
                              Positioned(bottom: 3,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: ctrl.eventsFor(day).take(3).map((j) =>
                                    Container(
                                      width: 4, height: 4, margin: const EdgeInsets.symmetric(horizontal: 1),
                                      decoration: BoxDecoration(
                                        color: _priorityColor(j.priority),
                                        shape: BoxShape.circle))).toList())),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDayAgenda(CalendarController ctrl) {
    return Obx(() {
      final day = ctrl.selectedDay.value;
      final jobs = ctrl.selectedDayJobs;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day == null ? 'No day selected'
              : _isToday(day) ? 'Today\'s Jobs'
              : DateFormat('EEEE, MMMM d').format(day),
            style: GoogleFonts.outfit(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 4),
          Text('${jobs.length} job${jobs.length != 1 ? 's' : ''} scheduled',
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white38)),
          const SizedBox(height: 12),
          if (jobs.isEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.08))),
                  child: Center(child: Column(children: [
                    Icon(Icons.event_available_rounded, color: Colors.white24, size: 36),
                    const SizedBox(height: 8),
                    Text('No jobs scheduled', style: GoogleFonts.outfit(
                      color: Colors.white38, fontSize: 14)),
                  ])),
                ),
              ),
            )
          else
            ...jobs.map((j) => _AgendaCard(job: j)),
        ],
      );
    });
  }

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Color _priorityColor(String p) {
    switch (p) {
      case 'emergency': return _kRed;
      case 'high':      return const Color(0xFFF97316);
      case 'medium':    return _kAmber;
      default:          return _kGreen;
    }
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({required this.job});
  final ServiceRequestModel job;

  @override
  Widget build(BuildContext context) {
    final pc = _priorityColor(job.priority);
    final sc = _statusColor(job.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.04)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.5)),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: pc,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(job.customerName, style: GoogleFonts.outfit(
                                  fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                                const SizedBox(height: 3),
                                Text(job.serviceType, style: GoogleFonts.outfit(
                                  fontSize: 13, color: Colors.white54)),
                                const SizedBox(height: 3),
                                Text(job.customerAddress, maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.white38)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (job.scheduledDate != null)
                                Text(DateFormat('h:mm a').format(job.scheduledDate!),
                                  style: GoogleFonts.outfit(fontSize: 13, color: _kCyan, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: sc.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: sc.withOpacity(0.4))),
                                child: Text(_statusLabel(job.status),
                                  style: GoogleFonts.outfit(fontSize: 10, color: sc, fontWeight: FontWeight.w700)),
                              ),
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
    );
  }

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
      case 'high':      return const Color(0xFFF97316);
      case 'medium':    return _kAmber;
      default:          return _kGreen;
    }
  }
}

