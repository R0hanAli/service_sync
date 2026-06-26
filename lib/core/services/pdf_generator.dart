import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/service_report_model.dart';
import '../../data/models/service_request_model.dart';


class PdfGeneratorService extends GetxService {
  
  static const _primaryBlue = PdfColor.fromInt(0xFF1565C0);
  static const _accentCyan = PdfColor.fromInt(0xFF00ACC1);
  static const _darkBg = PdfColor.fromInt(0xFF0D1B2A);
  static const _lightGrey = PdfColor.fromInt(0xFFF5F7FA);
  static const _medGrey = PdfColor.fromInt(0xFF90A4AE);
  static const _textDark = PdfColor.fromInt(0xFF1A237E);
  static const _textBody = PdfColor.fromInt(0xFF37474F);
  static const _white = PdfColors.white;
  static const _divider = PdfColor.fromInt(0xFFE0E0E0);

  
  
  
  Future<String> generateServiceReport(
    ServiceReportModel report,
    ServiceRequestModel? request,
  ) async {
    final doc = pw.Document(
      title: 'Service Report – ${report.reportId}',
      author: 'ServiceSync v1.0.0',
      creator: 'ServiceSync',
    );

    
    final ttfRegular =
        await PdfGoogleFonts.outfitRegular();
    final ttfBold = await PdfGoogleFonts.outfitBold();
    final ttfMedium = await PdfGoogleFonts.outfitMedium();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (_) => _buildHeader(ttfBold, ttfRegular, report),
        footer: (ctx) => _buildFooter(ctx, ttfRegular),
        build: (ctx) => [
          _dividerLine(),
          pw.SizedBox(height: 16),

          
          _sectionTitle('Customer Information', ttfBold),
          _infoRow('Customer Name', report.customerName, ttfMedium, ttfRegular),
          if (request != null) ...[
            _infoRow('Service Address', request.address, ttfMedium, ttfRegular),
            _infoRow('Customer ID', request.customerId, ttfMedium, ttfRegular),
          ],
          pw.SizedBox(height: 16),

          
          _sectionTitle('Service Details', ttfBold),
          _infoRow(
            'Service Type',
            request?.serviceType ?? 'General Service',
            ttfMedium,
            ttfRegular,
          ),
          _infoRow('Service Date', _formatDate(report.timestamp), ttfMedium, ttfRegular),
          _infoRow('Technician ID', report.technicianId, ttfMedium, ttfRegular),
          _infoRow('Report ID', report.reportId, ttfMedium, ttfRegular),
          if (request != null)
            _infoRow('Priority', request.priority.toUpperCase(), ttfMedium, ttfRegular),
          pw.SizedBox(height: 16),

          
          _sectionTitle('Findings', ttfBold),
          _styledTextBlock(report.findings, ttfRegular),
          pw.SizedBox(height: 16),

          
          _sectionTitle('Actions Taken', ttfBold),
          _styledTextBlock(report.actionsTaken, ttfRegular),
          pw.SizedBox(height: 16),

          
          if (report.partsUsed.isNotEmpty) ...[
            _sectionTitle('Parts Used', ttfBold),
            _bulletList(report.partsUsed, ttfRegular),
            pw.SizedBox(height: 16),
          ],

          
          _sectionTitle('Completion Notes', ttfBold),
          _styledTextBlock(
            report.completionNotes.isNotEmpty
                ? report.completionNotes
                : 'No additional notes.',
            ttfRegular,
          ),
          pw.SizedBox(height: 16),

          
          _sectionTitle('Customer Signature', ttfBold),
          _signatureSection(report, ttfRegular, ttfMedium),
          pw.SizedBox(height: 24),

          
          _statusBanner(request?.status ?? 'completed', ttfBold),
        ],
      ),
    );

    
    final dir = await getApplicationDocumentsDirectory();
    final safeId = report.reportId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final filePath = '${dir.path}/report_$safeId.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await doc.save());

    return filePath;
  }

  

  pw.Widget _buildHeader(
    pw.Font ttfBold,
    pw.Font ttfRegular,
    ServiceReportModel report,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ServiceSync',
                  style: pw.TextStyle(
                    font: ttfBold,
                    fontSize: 28,
                    color: _primaryBlue,
                    letterSpacing: 0.5,
                  ),
                ),
                pw.Text(
                  'Field Service Management',
                  style: pw.TextStyle(
                    font: ttfRegular,
                    fontSize: 10,
                    color: _medGrey,
                  ),
                ),
              ],
            ),
            
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: pw.BoxDecoration(
                color: _primaryBlue,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'SERVICE REPORT',
                    style: pw.TextStyle(
                      font: ttfBold,
                      fontSize: 12,
                      color: _white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  pw.Text(
                    report.reportId,
                    style: pw.TextStyle(
                      font: ttfRegular,
                      fontSize: 9,
                      color: PdfColors.blue100,
                    ),
                  ),
                  pw.Text(
                    _formatDate(report.timestamp),
                    style: pw.TextStyle(
                      font: ttfRegular,
                      fontSize: 9,
                      color: PdfColors.blue100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context ctx, pw.Font ttfRegular) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by ServiceSync v1.0.0',
            style: pw.TextStyle(
              font: ttfRegular,
              fontSize: 8,
              color: _medGrey,
            ),
          ),
          pw.Text(
            'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
            style: pw.TextStyle(
              font: ttfRegular,
              fontSize: 8,
              color: _medGrey,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _dividerLine() => pw.Container(
        height: 2,
        decoration: const pw.BoxDecoration(
          gradient: pw.LinearGradient(
            colors: [_primaryBlue, _accentCyan],
          ),
        ),
      );

  pw.Widget _sectionTitle(String title, pw.Font ttfBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            font: ttfBold,
            fontSize: 10,
            color: _primaryBlue,
            letterSpacing: 1.2,
          ),
        ),
        pw.Container(
          height: 1,
          margin: const pw.EdgeInsets.only(top: 4, bottom: 10),
          color: _divider,
        ),
      ],
    );
  }

  pw.Widget _infoRow(
    String label,
    String value,
    pw.Font ttfMedium,
    pw.Font ttfRegular,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 130,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                font: ttfMedium,
                fontSize: 10,
                color: _textBody,
              ),
            ),
          ),
          pw.Text(
            ':  ',
            style: pw.TextStyle(font: ttfRegular, fontSize: 10, color: _medGrey),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                font: ttfRegular,
                fontSize: 10,
                color: _textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _styledTextBlock(String text, pw.Font ttfRegular) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _lightGrey,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _divider),
      ),
      child: pw.Text(
        text.isEmpty ? 'Not specified.' : text,
        style: pw.TextStyle(font: ttfRegular, fontSize: 10, color: _textBody),
      ),
    );
  }

  pw.Widget _bulletList(List<String> items, pw.Font ttfRegular) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: items.map((item) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 6,
                height: 6,
                margin: const pw.EdgeInsets.only(top: 3, right: 8),
                decoration: const pw.BoxDecoration(
                  color: _accentCyan,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  item,
                  style: pw.TextStyle(
                    font: ttfRegular,
                    fontSize: 10,
                    color: _textBody,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _signatureSection(
    ServiceReportModel report,
    pw.Font ttfRegular,
    pw.Font ttfMedium,
  ) {
    if (report.hasSignature) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: _lightGrey,
          borderRadius: pw.BorderRadius.circular(6),
          border: pw.Border.all(color: _divider),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              '✓  Customer Signature Captured',
              style: pw.TextStyle(
                font: ttfMedium,
                fontSize: 10,
                color: const PdfColor.fromInt(0xFF2E7D32),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Signed on: ${_formatDate(report.timestamp)}',
              style: pw.TextStyle(
                font: ttfRegular,
                fontSize: 9,
                color: _medGrey,
              ),
            ),
          ],
        ),
      );
    } else {
      return pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: _lightGrey,
          borderRadius: pw.BorderRadius.circular(6),
          border: pw.Border.all(color: _divider),
        ),
        child: pw.Text(
          'No signature captured.',
          style: pw.TextStyle(
            font: ttfRegular,
            fontSize: 10,
            color: _medGrey,
          ),
        ),
      );
    }
  }

  pw.Widget _statusBanner(String status, pw.Font ttfBold) {
    final color = _statusColor(status);
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 10),
      decoration: pw.BoxDecoration(
        color: color.withAlpha(0.1),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: color, width: 1.5),
      ),
      child: pw.Center(
        child: pw.Text(
          'JOB STATUS: ${status.toUpperCase()}',
          style: pw.TextStyle(
            font: ttfBold,
            fontSize: 11,
            color: color,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  PdfColor _statusColor(String status) {
    switch (status) {
      case 'completed':
        return const PdfColor.fromInt(0xFF2E7D32);
      case 'inProgress':
        return const PdfColor.fromInt(0xFF1565C0);
      case 'pending':
        return const PdfColor.fromInt(0xFFF57F17);
      case 'emergency':
        return const PdfColor.fromInt(0xFFC62828);
      default:
        return _medGrey;
    }
  }

  String _formatDate(String isoTimestamp) {
    try {
      final dt = DateTime.parse(isoTimestamp).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return isoTimestamp;
    }
  }

  
  
  Future<void> openPDF(String path) async {
    final result = await OpenFilex.open(path);
    if (result.type != ResultType.done) {
      Get.snackbar(
        'Cannot Open PDF',
        result.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  
  
  Future<void> sharePDF(String path) async {
    try {
      await Share.shareXFiles(
        [XFile(path, mimeType: 'application/pdf')],
        text: 'ServiceSync — Service Report',
        subject: 'Service Report',
      );
    } catch (e) {
      Get.snackbar(
        'Share Failed',
        'Could not share the PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
