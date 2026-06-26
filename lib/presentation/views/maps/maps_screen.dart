
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/map_controller.dart';
import '../../controllers/job_controller.dart';

const _kDark   = Color(0xFF0A0E27);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);
const _kGreen  = Color(0xFF10B981);
const _kRed    = Color(0xFFEF4444);

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});
  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen>
    with SingleTickerProviderStateMixin {
  late MapController _mapCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _mapCtrl = Get.find<MapController>();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);

    
    final job = Get.find<JobController>().selectedJob.value;
    if (job != null) {
      Future.microtask(() => _mapCtrl.navigateTo(
        lat: 30.2672, lng: -97.7431,
        address: job.customerAddress,
      ));
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDark,
      body: Stack(
        children: [
          
          Positioned.fill(child: _buildMockMap()),

          
          Positioned(top: 0, left: 0, right: 0,
            child: _buildTopPanel()),

          
          Positioned(bottom: 0, left: 0, right: 0,
            child: _buildBottomPanel()),
        ],
      ),
    );
  }

  Widget _buildMockMap() {
    return CustomPaint(
      painter: _MockMapPainter(),
      child: Obx(() {
        final tech = _mapCtrl.technicianPosition.value;
        final dest = _mapCtrl.destinationPosition.value;
        final route = _mapCtrl.routePoints;
        return LayoutBuilder(builder: (_, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          
          Offset normalize(LatLng ll) {
            const baseLeft = 30.2600; const baseRight = 30.2800;
            const baseBottom = -97.7600; const baseTop = -97.7300;
            final x = (ll.lng - baseBottom) / (baseTop - baseBottom) * w;
            final y = h - (ll.lat - baseLeft) / (baseRight - baseLeft) * h;
            return Offset(x.clamp(40, w - 40), y.clamp(40, h - 40));
          }

          return Stack(children: [
            
            if (route.isNotEmpty && dest != null)
              CustomPaint(
                painter: _RoutePainter(route.map(normalize).toList()),
                size: Size(w, h),
              ),

            
            if (dest != null) ...[
              Positioned.fill(child: Builder(builder: (_) {
                final pos = normalize(dest);
                return Stack(children: [
                  Positioned(left: pos.dx - 18, top: pos.dy - 44,
                    child: Column(children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: _kRed, shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: _kRed.withOpacity(0.5), blurRadius: 12)]),
                        child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 20)),
                      Container(width: 2, height: 8, color: _kRed),
                    ])),
                ]);
              })),
            ],

            
            if (tech != null) ...[
              Positioned.fill(child: Builder(builder: (_) {
                final pos = normalize(tech);
                return Stack(children: [
                  
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Positioned(
                      left: pos.dx - 24 - 12 * _pulseAnim.value,
                      top: pos.dy - 24 - 12 * _pulseAnim.value,
                      child: Container(
                        width: 48 + 24 * _pulseAnim.value,
                        height: 48 + 24 * _pulseAnim.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _kCyan.withOpacity(0.5 - 0.4 * _pulseAnim.value),
                            width: 2)),
                      ),
                    ),
                  ),
                  
                  Positioned(left: pos.dx - 18, top: pos.dy - 18,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [_kBlue, _kCyan]),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: _kCyan.withOpacity(0.5), blurRadius: 16)],
                        border: Border.all(color: Colors.white, width: 2.5)),
                      child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 18))),
                ]);
              })),
            ],
          ]);
        });
      }),
    );
  }

  Widget _buildTopPanel() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.15))),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.12))),
                    child: Obx(() => Text(
                      _mapCtrl.destinationAddress.value.isNotEmpty
                          ? _mapCtrl.destinationAddress.value
                          : 'No destination set',
                      style: GoogleFonts.outfit(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0E27).withOpacity(0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Obx(() {
                final isNav = _mapCtrl.isNavigating.value;
                final eta   = _mapCtrl.estimatedTime.value;
                final dist  = _mapCtrl.distanceKm.value;
                return Row(
                  children: [
                    _infoChip(Icons.timer_outlined, eta.isEmpty ? '—' : eta, _kCyan),
                    const SizedBox(width: 12),
                    _infoChip(Icons.straighten_rounded,
                      dist > 0 ? '${dist.toStringAsFixed(1)} km' : '—', _kBlue),
                    const SizedBox(width: 12),
                    _infoChip(Icons.speed_rounded, '40 km/h', _kPurple),
                  ],
                );
              }),
              const SizedBox(height: 16),
              Obx(() {
                final isNav = _mapCtrl.isNavigating.value;
                return Row(children: [
                  if (!isNav) ...[
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _mapCtrl.navigateTo(
                          lat: 30.2672, lng: -97.7431,
                          address: Get.find<JobController>().selectedJob.value?.customerAddress
                            ?? '742 Evergreen Terrace, Springfield'),
                        child: _navButton('Start Navigation', Icons.navigation_rounded,
                          const LinearGradient(colors: [_kBlue, _kCyan])),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: GestureDetector(
                        onTap: _mapCtrl.stopNavigation,
                        child: _navButton('Stop Navigation', Icons.stop_rounded,
                          const LinearGradient(colors: [_kRed, Color(0xFFDC2626)])),
                      ),
                    ),
                  ],
                ]);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.outfit(
          fontSize: 13, color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _navButton(String label, IconData icon, LinearGradient gradient) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
          color: gradient.colors.first.withOpacity(0.4), blurRadius: 16)]),
      child: Center(child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(label, style: GoogleFonts.outfit(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
        ],
      )),
    );
  }
}


class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0E1228);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    
    final streetPaint = Paint()
      ..color = const Color(0xFF1A2040)
      ..strokeWidth = 2;

    final mainStreetPaint = Paint()
      ..color = const Color(0xFF222B50)
      ..strokeWidth = 4;

    for (int i = 1; i < 8; i++) {
      final y = size.height * i / 8;
      canvas.drawLine(Offset(0, y), Offset(size.width, y),
        i % 2 == 0 ? mainStreetPaint : streetPaint);
    }
    for (int i = 1; i < 6; i++) {
      final x = size.width * i / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height),
        i % 2 == 0 ? mainStreetPaint : streetPaint);
    }

    
    final blockPaint = Paint()..color = const Color(0xFF131830);
    final rng = math.Random(42);
    for (int row = 0; row < 7; row++) {
      for (int col = 0; col < 5; col++) {
        if (rng.nextBool()) {
          final left  = size.width * col / 6 + 4;
          final top   = size.height * row / 8 + 4;
          final w     = size.width / 6 - 8;
          final h     = size.height / 8 - 8;
          canvas.drawRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(left, top, w, h), const Radius.circular(4)),
            blockPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}


class _RoutePainter extends CustomPainter {
  final List<Offset> points;
  const _RoutePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = const Color(0xFF00D4FF).withOpacity(0.7)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);

    
    final glow = Paint()
      ..color = const Color(0xFF00D4FF).withOpacity(0.25)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, glow);
  }

  @override
  bool shouldRepaint(_RoutePainter old) => old.points != points;
}

