import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/datasources/local/sqlite_helper.dart';
import '../../data/models/service_report_model.dart';

class ReportController extends GetxController {
  
  final RxList<ServiceReportModel> reports = <ServiceReportModel>[].obs;
  final Rx<ServiceReportModel?> currentReport = Rx<ServiceReportModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxList<String> images = <String>[].obs;
  final Rx<String?> signature = Rx<String?>(null);
  final RxBool isDraft = false.obs;

  
  final TextEditingController findingsController = TextEditingController();
  final TextEditingController actionsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController partsController = TextEditingController();

  
  final SQLiteHelper _db = SQLiteHelper.instance;
  Timer? _autoSaveTimer;

  
  @override
  void onInit() {
    super.onInit();
    loadReports();
    _startAutoSave();
  }

  @override
  void onClose() {
    findingsController.dispose();
    actionsController.dispose();
    notesController.dispose();
    partsController.dispose();
    _autoSaveTimer?.cancel();
    super.onClose();
  }

  
  Future<void> loadReports() async {
    isLoading.value = true;
    try {
      final maps = await _db.getAllReports();
      if (maps.isEmpty) {
        reports.assignAll(_mockReports());
      } else {
        reports.assignAll(maps.map((m) => ServiceReportModel.fromMap(m)));
      }
    } catch (e) {
      debugPrint('[ReportController] loadReports error: \$e');
      reports.assignAll(_mockReports());
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> saveReport(String serviceRequestId) async {
    if (findingsController.text.trim().isEmpty) {
      _showError('Please enter your findings before saving.');
      return;
    }

    isSaving.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final report = ServiceReportModel(
        id: 'RPT_\${DateTime.now().millisecondsSinceEpoch}',
        serviceRequestId: serviceRequestId,
        technicianId: 'usr_001',
        technicianName: 'Alex Rodriguez',
        findings: findingsController.text.trim(),
        actionsPerformed: actionsController.text.trim(),
        partsUsed: partsController.text.trim(),
        additionalNotes: notesController.text.trim(),
        images: images.toList(),
        signature: signature.value,
        isDraft: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _db.insertReport(report.toMap());
      reports.insert(0, report);
      currentReport.value = report;
      isDraft.value = false;

      _showSuccess('Report saved successfully ✅');
      clearForm();
    } catch (e) {
      debugPrint('[ReportController] saveReport error: \$e');
      _showError('Failed to save report. Please try again.');
    } finally {
      isSaving.value = false;
    }
  }

  
  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      autoSaveDraft();
    });
  }

  Future<void> autoSaveDraft() async {
    if (findingsController.text.trim().isEmpty) return;

    try {
      final draft = ServiceReportModel(
        id: 'DRAFT_\${DateTime.now().millisecondsSinceEpoch}',
        serviceRequestId: 'draft',
        technicianId: 'usr_001',
        technicianName: 'Alex Rodriguez',
        findings: findingsController.text.trim(),
        actionsPerformed: actionsController.text.trim(),
        partsUsed: partsController.text.trim(),
        additionalNotes: notesController.text.trim(),
        images: images.toList(),
        signature: signature.value,
        isDraft: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _db.insertReport(draft.toMap());
      isDraft.value = true;
      debugPrint('[ReportController] Draft auto-saved');
    } catch (e) {
      debugPrint('[ReportController] autoSaveDraft error: $e');
    }
  }

  
  void addImage(String base64Image) {
    if (images.length >= 5) {
      _showError('Maximum 5 images allowed per report.');
      return;
    }
    images.add(base64Image);
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
    }
  }

  
  void setSignature(String base64Sig) {
    signature.value = base64Sig;
  }

  void clearSignature() {
    signature.value = null;
  }

  
  Future<void> exportPDF(ServiceReportModel report) async {
    isLoading.value = true;
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(36),
          header: (context) => _pdfHeader(report),
          footer: (context) => _pdfFooter(context),
          build: (context) => [
            _pdfSection('Service Details', [
              _pdfRow('Report ID', report.id),
              _pdfRow('Request ID', report.serviceRequestId),
              _pdfRow('Technician', report.technicianName),
              _pdfRow(
                  'Date',
                  '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}'),
            ]),
            pw.SizedBox(height: 16),
            _pdfSection('Findings', [
              pw.Text(report.findings, style: const pw.TextStyle(fontSize: 11)),
            ]),
            if (report.actionsPerformed.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _pdfSection('Actions Performed', [
                pw.Text(report.actionsPerformed,
                    style: const pw.TextStyle(fontSize: 11)),
              ]),
            ],
            if (report.partsUsed.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _pdfSection('Parts Used', [
                pw.Text(report.partsUsed.join(', '),
                    style: const pw.TextStyle(fontSize: 11)),
              ]),
            ],
            if (report.additionalNotes.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _pdfSection('Additional Notes', [
                pw.Text(report.additionalNotes,
                    style: const pw.TextStyle(fontSize: 11)),
              ]),
            ],
            pw.SizedBox(height: 24),
            _pdfSignatureSection(report),
          ],
        ),
      );

      
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/ServiceSync_Report_${report.id.replaceAll(':', '_')}.pdf');
      await file.writeAsBytes(await pdf.save());

      
      await OpenFilex.open(file.path);
      _showSuccess('PDF exported successfully 📄');
    } catch (e) {
      debugPrint('[ReportController] exportPDF error: $e');
      _showError('Failed to generate PDF. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  
  pw.Widget _pdfHeader(ServiceReportModel report) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue900)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('ServiceSync',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                      color: PdfColors.blue900)),
              pw.Text('Field Service Report',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
            ],
          ),
          pw.Text(report.id,
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 11, color: PdfColors.blue700)),
        ],
      ),
    );
  }

  pw.Widget _pdfFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 8),
      child: pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount} — Generated by ServiceSync',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey500)),
    );
  }

  pw.Widget _pdfSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          child: pw.Text(title,
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.blue900)),
        ),
        pw.SizedBox(height: 8),
        ...children,
      ],
    );
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 110,
            child: pw.Text('$label:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfSignatureSection(ServiceReportModel report) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(children: [
          pw.Container(width: 180, height: 1, color: PdfColors.black),
          pw.SizedBox(height: 4),
          pw.Text('Technician Signature',
              style: const pw.TextStyle(fontSize: 10)),
        ]),
        pw.Column(children: [
          pw.Container(width: 180, height: 1, color: PdfColors.black),
          pw.SizedBox(height: 4),
          pw.Text('Customer Signature',
              style: const pw.TextStyle(fontSize: 10)),
        ]),
      ],
    );
  }

  
  void clearForm() {
    findingsController.clear();
    actionsController.clear();
    notesController.clear();
    partsController.clear();
    images.clear();
    signature.value = null;
    isDraft.value = false;
  }

  
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFFF4757).withValues(alpha: 0.92),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2ED573).withValues(alpha: 0.92),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      icon:
          const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
    );
  }

  
  List<ServiceReportModel> _mockReports() {
    final now = DateTime.now();
    return [
      ServiceReportModel(
        id: 'RPT_20240115_001',
        serviceRequestId: 'SR-001230',
        technicianId: 'usr_001',
        technicianName: 'Alex Rodriguez',
        findings:
            'Found a cracked P-trap under kitchen sink causing the leak. Water damage visible on cabinet floor.',
        actionsPerformed:
            'Replaced P-trap assembly and supply line. Applied sealant. Tested for leaks under pressure.',
        partsUsed: 'P-trap 1.5" (x1), Supply line 3/8" x 20" (x1), Teflon tape (x1)',
        additionalNotes:
            'Customer advised to monitor for 48 hours. Cabinet floor may need drying treatment.',
        images: [],
        signature: null,
        isDraft: false,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ServiceReportModel(
        id: 'RPT_20240114_001',
        serviceRequestId: 'SR-001228',
        technicianId: 'usr_001',
        technicianName: 'Alex Rodriguez',
        findings:
            'Drain pump filter clogged with debris causing error E4. Drain hose kinked at back of unit.',
        actionsPerformed:
            'Cleaned drain pump filter. Straightened and repositioned drain hose. Ran diagnostic cycle.',
        partsUsed: 'Filter cleaning kit (x1)',
        additionalNotes: 'Recommended monthly filter cleaning to prevent recurrence.',
        images: [],
        signature: null,
        isDraft: false,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
