
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/report_controller.dart';
import '../../../data/models/service_report_model.dart';

const _kDark   = Color(0xFF0A0E27);
const _kSurface = Color(0xFF1A1F4E);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kGreen  = Color(0xFF10B981);
const _kAmber  = Color(0xFFF59E0B);

class ReportHistoryScreen extends StatelessWidget {
  const ReportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ReportController>();
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                sliver: Obx(() {
                  if (ctrl.isLoading.value) {
                    return const SliverToBoxAdapter(
                      child: SizedBox(height: 200,
                        child: Center(child: CircularProgressIndicator(color: _kCyan))));
                  }
                  if (ctrl.reports.isEmpty) {
                    return SliverToBoxAdapter(child: _buildEmpty());
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _ReportCard(report: ctrl.reports[i], ctrl: ctrl),
                      childCount: ctrl.reports.length,
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/service-report'),
        backgroundColor: _kBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('New Report', style: GoogleFonts.outfit(
          color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Report History', style: GoogleFonts.outfit(
                        fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('All submitted service reports',
                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54)),
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
      children: [
        const SizedBox(height: 80),
        Icon(Icons.description_outlined, size: 64, color: Colors.white24),
        const SizedBox(height: 16),
        Text('No reports yet', style: GoogleFonts.outfit(
          color: Colors.white38, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text('Complete a job to generate your first report',
          style: GoogleFonts.outfit(color: Colors.white24, fontSize: 13)),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report, required this.ctrl});
  final ServiceReportModel report;
  final ReportController ctrl;

  @override
  Widget build(BuildContext context) {
    final isDraft = report.isDraft;
    final color = isDraft ? _kAmber : _kGreen;
    return GestureDetector(
      onTap: () => _showReportDetail(context),
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
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5)),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: color,
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
                                Expanded(child: Text(report.id,
                                  style: GoogleFonts.outfit(fontSize: 12, color: _kCyan,
                                    fontWeight: FontWeight.w600, letterSpacing: 0.5))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: color.withOpacity(0.4))),
                                  child: Text(isDraft ? 'Draft' : 'Submitted',
                                    style: GoogleFonts.outfit(fontSize: 10, color: color, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Job: ${report.serviceRequestId}',
                              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                            const SizedBox(height: 4),
                            Text('By: ${report.technicianName}',
                              style: GoogleFonts.outfit(fontSize: 13, color: Colors.white54)),
                            const SizedBox(height: 4),
                            Text(report.findings, maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(fontSize: 13, color: Colors.white38, height: 1.4)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, color: Colors.white30, size: 14),
                                const SizedBox(width: 4),
                                Text(DateFormat('MMM d, yyyy h:mm a').format(report.createdAt),
                                  style: GoogleFonts.outfit(fontSize: 11, color: Colors.white30)),
                                const Spacer(),
                                if (!isDraft)
                                  GestureDetector(
                                    onTap: () => ctrl.exportPDF(report),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [_kBlue, _kCyan]),
                                        borderRadius: BorderRadius.circular(10)),
                                      child: Row(children: [
                                        const Icon(Icons.picture_as_pdf_outlined, color: Colors.white, size: 14),
                                        const SizedBox(width: 4),
                                        Text('PDF', style: GoogleFonts.outfit(
                                          fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                                      ]),
                                    ),
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
      ),
    );
  }

  void _showReportDetail(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F4E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.id, style: GoogleFonts.outfit(
                      fontSize: 16, color: _kCyan, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Job: ${report.serviceRequestId}', style: GoogleFonts.outfit(
                      fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    _detailSection('Findings', report.findings),
                    if (report.actionsPerformed.isNotEmpty)
                      _detailSection('Actions Performed', report.actionsPerformed),
                    if (report.partsUsed.isNotEmpty)
                      _detailSection('Parts Used', report.partsUsed.join(', ')),
                    if (report.additionalNotes.isNotEmpty)
                      _detailSection('Notes', report.additionalNotes),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () { Get.back(); ctrl.exportPDF(report); },
                      child: Container(
                        height: 48, width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [_kBlue, _kCyan]),
                          borderRadius: BorderRadius.circular(14)),
                        child: Center(child: Text('Export PDF', style: GoogleFonts.outfit(
                          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _detailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(
            fontSize: 12, color: _kCyan, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(content, style: GoogleFonts.outfit(
            fontSize: 14, color: Colors.white70, height: 1.6)),
        ],
      ),
    );
  }
}

