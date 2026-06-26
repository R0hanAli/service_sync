
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../controllers/job_controller.dart';

const _kDark   = Color(0xFF0A0E27);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kGreen  = Color(0xFF10B981);
const _kRed    = Color(0xFFEF4444);

class QrVerificationScreen extends StatefulWidget {
  const QrVerificationScreen({super.key});
  @override
  State<QrVerificationScreen> createState() => _QrVerificationScreenState();
}

class _QrVerificationScreenState extends State<QrVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  bool _isVerified = false;
  bool _isScanning = true;
  String? _scannedCode;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this,
      duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobCtrl = Get.find<JobController>();
    final job = jobCtrl.selectedJob.value;

    return Scaffold(
      backgroundColor: _kDark,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0A0E27), Color(0xFF0D1333)]))),
          SafeArea(
            child: Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                      Text('QR Verification', style: GoogleFonts.outfit(
                        fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.12))),
                        child: Row(children: [
                          Expanded(child: GestureDetector(
                            onTap: () => setState(() => _isScanning = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                gradient: !_isScanning ? const LinearGradient(colors: [_kBlue, _kCyan]) : null,
                                borderRadius: BorderRadius.circular(11)),
                              child: Center(child: Text('Show QR',
                                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: !_isScanning ? Colors.white : Colors.white54))),
                            ),
                          )),
                          Expanded(child: GestureDetector(
                            onTap: () => setState(() => _isScanning = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                gradient: _isScanning ? const LinearGradient(colors: [_kPurple, _kCyan]) : null,
                                borderRadius: BorderRadius.circular(11)),
                              child: Center(child: Text('Scan QR',
                                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: _isScanning ? Colors.white : Colors.white54))),
                            ),
                          )),
                        ]),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: _isScanning
                    ? _buildScannerView(jobCtrl)
                    : _buildQRDisplay(job?.id ?? 'DEMO-JOB-001'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRDisplay(String jobId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text('Job QR Code', style: GoogleFonts.outfit(
            fontSize: 16, color: Colors.white60, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Show to customer to verify arrival',
            style: GoogleFonts.outfit(fontSize: 13, color: Colors.white38)),
          const SizedBox(height: 32),

          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, child) => Transform.scale(
              scale: 1.0 + _pulseAnim.value * 0.02,
              child: child,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(
                      color: _kCyan.withOpacity(0.3),
                      blurRadius: 30, spreadRadius: 5)]),
                  child: QrImageView(
                    data: 'SERVICESYNC:$jobId:${DateTime.now().millisecondsSinceEpoch}',
                    size: 220,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square, color: Color(0xFF0A0E27)),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.circle, color: Color(0xFF0A0E27)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(jobId, style: GoogleFonts.outfit(
            fontSize: 20, fontWeight: FontWeight.w700, color: _kCyan, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text('Expires in 5 minutes', style: GoogleFonts.outfit(
            fontSize: 12, color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildScannerView(JobController jobCtrl) {
    if (_isVerified) {
      return _buildVerifiedState(jobCtrl);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Scan Customer QR Code', style: GoogleFonts.outfit(
          fontSize: 16, color: Colors.white60)),
        const SizedBox(height: 24),

        
        Container(
          width: 260, height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kCyan, width: 2),
            boxShadow: [BoxShadow(color: _kCyan.withOpacity(0.2), blurRadius: 20)]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Container(color: Colors.black54),
                
                ..._buildCornerBrackets(),
                
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => Positioned(
                    top: 20 + 200 * _pulseAnim.value,
                    left: 20, right: 20,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.transparent, _kCyan, Colors.transparent]),
                        boxShadow: [BoxShadow(color: _kCyan.withOpacity(0.6), blurRadius: 8)]),
                    ),
                  ),
                ),
                Center(child: Icon(Icons.qr_code_scanner_rounded,
                  color: Colors.white.withOpacity(0.1), size: 80)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),
        
        GestureDetector(
          onTap: () => _simulateScan(jobCtrl),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_kPurple, _kCyan]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: _kCyan.withOpacity(0.3), blurRadius: 16)]),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text('Simulate Scan', style: GoogleFonts.outfit(
                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('(Tap to simulate QR scan for demo)', style: GoogleFonts.outfit(
          fontSize: 12, color: Colors.white24)),
      ],
    );
  }

  Widget _buildVerifiedState(JobController jobCtrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [_kGreen, Color(0xFF059669)]),
            boxShadow: [BoxShadow(color: _kGreen.withOpacity(0.5), blurRadius: 30, spreadRadius: 5)]),
          child: const Icon(Icons.verified_rounded, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 24),
        Text('QR Verified!', style: GoogleFonts.outfit(
          fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 8),
        Text('Customer location confirmed. Job unlocked.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(fontSize: 14, color: Colors.white60)),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () {
            final job = jobCtrl.selectedJob.value;
            if (job != null) jobCtrl.startJob(job.id);
            Get.back();
          },
          child: Container(
            width: 240, height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_kBlue, _kCyan]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: _kCyan.withOpacity(0.3), blurRadius: 16)]),
            child: Center(child: Text('Start Job Now', style: GoogleFonts.outfit(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
          ),
        ),
      ],
    );
  }

  void _simulateScan(JobController jobCtrl) async {
    setState(() => _scannedCode = 'SERVICESYNC:DEMO-VERIFIED');
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isVerified = true);
  }

  List<Widget> _buildCornerBrackets() {
    const color = _kCyan;
    const size = 24.0;
    const width = 3.0;
    return [
      
      Positioned(top: 12, left: 12,
        child: Container(width: size, height: size, decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: color, width: width),
                        left: BorderSide(color: color, width: width))))),
      
      Positioned(top: 12, right: 12,
        child: Container(width: size, height: size, decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: color, width: width),
                        right: BorderSide(color: color, width: width))))),
      
      Positioned(bottom: 12, left: 12,
        child: Container(width: size, height: size, decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: color, width: width),
                        left: BorderSide(color: color, width: width))))),
      
      Positioned(bottom: 12, right: 12,
        child: Container(width: size, height: size, decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: color, width: width),
                        right: BorderSide(color: color, width: width))))),
    ];
  }
}

