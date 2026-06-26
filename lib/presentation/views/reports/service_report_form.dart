import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class ServiceReportFormController extends GetxController {
  final currentStep = 0.obs;
  final isSubmitting = false.obs;
  final isSubmitted = false.obs;

  
  final findingsCtrl = TextEditingController();
  final actionsCtrl = TextEditingController();
  final partInputCtrl = TextEditingController();
  final completionCtrl = TextEditingController();
  final parts = <String>[].obs;

  
  final beforeImages = <String>[].obs;
  final duringImages = <String>[].obs;
  final afterImages = <String>[].obs;
  bool hasSignature = false;

  
  final termsAccepted = false.obs;

  void addPart() {
    final p = partInputCtrl.text.trim();
    if (p.isNotEmpty && !parts.contains(p)) {
      parts.add(p);
      partInputCtrl.clear();
    }
  }

  void removePart(String p) => parts.remove(p);

  void nextStep() {
    if (currentStep.value < 2) currentStep.value++;
  }

  void prevStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  void addMockImage(RxList<String> list) {
    list.add('image_${list.length + 1}.jpg');
  }

  void removeImage(RxList<String> list, int idx) => list.removeAt(idx);

  Future<void> submitReport() async {
    isSubmitting.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isSubmitting.value = false;
    isSubmitted.value = true;
  }

  @override
  void onClose() {
    findingsCtrl.dispose();
    actionsCtrl.dispose();
    partInputCtrl.dispose();
    completionCtrl.dispose();
    super.onClose();
  }
}


class ServiceReportFormScreen extends StatelessWidget {
  const ServiceReportFormScreen({super.key});

  static const _bg = Color(0xFF0A0E27);
  static const _cyan = Color(0xFF00D4FF);
  static const _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ServiceReportFormController());
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final serviceRequestId = args['serviceRequestId'] as String? ?? 'REQ-0042';
    final customerName = args['customerName'] as String? ?? 'John Smith';

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          _Background(),
          SafeArea(
            child: Obx(() {
              if (ctrl.isSubmitted.value) return _SuccessView();
              return Column(
                children: [
                  _AppBarWidget(
                      serviceRequestId: serviceRequestId,
                      customerName: customerName),
                  _StepProgress(step: ctrl.currentStep.value),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                                  begin: const Offset(0.08, 0),
                                  end: Offset.zero)
                              .animate(anim),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(ctrl.currentStep.value),
                        child: ctrl.currentStep.value == 0
                            ? _Step1(ctrl: ctrl)
                            : ctrl.currentStep.value == 1
                                ? _Step2(ctrl: ctrl)
                                : _Step3(
                                    ctrl: ctrl,
                                    serviceRequestId: serviceRequestId,
                                    customerName: customerName),
                      ),
                    ),
                  ),
                  _NavBar(ctrl: ctrl),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}


class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E27), Color(0xFF0D1333), Color(0xFF0A0E27)],
          ),
        ),
      ),
      Positioned(
          top: -80,
          left: -60,
          child: _Orb(color: const Color(0xFF7C3AED), size: 260)),
      Positioned(
          bottom: 80,
          right: -60,
          child: _Orb(color: const Color(0xFF00D4FF), size: 200)),
    ]);
  }
}

class _Orb extends StatelessWidget {
  final Color color;
  final double size;
  const _Orb({required this.color, required this.size});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
              colors: [color.withOpacity(0.22), Colors.transparent]),
        ),
      );
}


class _AppBarWidget extends StatelessWidget {
  final String serviceRequestId;
  final String customerName;
  const _AppBarWidget(
      {required this.serviceRequestId, required this.customerName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(children: [
        _glassBtn(Icons.arrow_back_ios_rounded, () => Get.back()),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Service Report',
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text('$serviceRequestId • $customerName',
                style:
                    GoogleFonts.outfit(color: Colors.white54, fontSize: 13)),
          ]),
        ),
        _glassBtn(Icons.save_outlined, () {}),
      ]),
    );
  }

  Widget _glassBtn(IconData icon, VoidCallback onTap) => GestureDetector(
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
                border:
                    Border.all(color: Colors.white.withOpacity(0.18)),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
          ),
        ),
      );
}


class _StepProgress extends StatelessWidget {
  final int step;
  const _StepProgress({required this.step});
  static const _labels = ['Findings', 'Evidence', 'Review'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: List.generate(3, (i) {
          final active = i == step;
          final done = i < step;
          return Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(right: i < 2 ? 6 : 0),
              child: Column(children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: done || active
                        ? const LinearGradient(colors: [
                            Color(0xFF7C3AED),
                            Color(0xFF00D4FF)
                          ])
                        : null,
                    color: done || active
                        ? null
                        : Colors.white.withOpacity(0.14),
                  ),
                ),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: done || active
                          ? const LinearGradient(colors: [
                              Color(0xFF7C3AED),
                              Color(0xFF00D4FF)
                            ])
                          : null,
                      color: done || active
                          ? null
                          : Colors.white.withOpacity(0.1),
                      border:
                          Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Center(
                      child: done
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 11)
                          : Text('${i + 1}',
                              style: GoogleFonts.outfit(
                                  color: active
                                      ? Colors.white
                                      : Colors.white38,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(_labels[i],
                      style: GoogleFonts.outfit(
                          color:
                              active ? Colors.white : Colors.white38,
                          fontSize: 11,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.normal)),
                ]),
              ]),
            ),
          );
        }),
      ),
    );
  }
}


class _Step1 extends StatelessWidget {
  final ServiceReportFormController ctrl;
  const _Step1({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label('Findings'),
        _GlassTextArea(
            controller: ctrl.findingsCtrl,
            hint: 'Describe what you found on-site...',
            minLines: 4),
        const SizedBox(height: 16),
        _label('Actions Taken'),
        _GlassTextArea(
            controller: ctrl.actionsCtrl,
            hint: 'Describe the actions performed...',
            minLines: 4),
        const SizedBox(height: 16),
        _label('Parts Used'),
        _PartsSection(ctrl: ctrl),
        const SizedBox(height: 16),
        _label('Completion Notes'),
        _GlassTextArea(
            controller: ctrl.completionCtrl,
            hint: 'Additional notes...',
            minLines: 3),
      ]),
    );
  }

  Widget _label(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(t,
          style: GoogleFonts.outfit(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600)));
}

class _GlassTextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int minLines;
  const _GlassTextArea(
      {required this.controller, required this.hint, this.minLines = 3});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: TextField(
            controller: controller,
            minLines: minLines,
            maxLines: null,
            style:
                GoogleFonts.outfit(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.outfit(
                  color: Colors.white30, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ),
    );
  }
}

class _PartsSection extends StatelessWidget {
  final ServiceReportFormController ctrl;
  const _PartsSection({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: ctrl.partInputCtrl,
                  style:
                      GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Enter part name...',
                    hintStyle: GoogleFonts.outfit(
                        color: Colors.white30, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => ctrl.addPart(),
                ),
              ),
              GestureDetector(
                onTap: ctrl.addPart,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color(0xFF7C3AED),
                      Color(0xFF00D4FF)
                    ]),
                  ),
                  child:
                      const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ]),
            Obx(() {
              if (ctrl.parts.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ctrl.parts
                      .map((p) => _PartChip(
                          label: p,
                          onRemove: () => ctrl.removePart(p)))
                      .toList(),
                ),
              );
            }),
          ]),
        ),
      ),
    );
  }
}

class _PartChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _PartChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF00D4FF).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.4)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label,
            style: GoogleFonts.outfit(
                color: const Color(0xFF00D4FF),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onRemove,
          child: const Icon(Icons.close,
              color: Color(0xFF00D4FF), size: 14),
        ),
      ]),
    );
  }
}


class _Step2 extends StatelessWidget {
  final ServiceReportFormController ctrl;
  const _Step2({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('Service Images',
              style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() => _ImageColumn(
                    label: 'Before',
                    color: const Color(0xFF3B82F6),
                    images: ctrl.beforeImages,
                    onAdd: () => ctrl.addMockImage(ctrl.beforeImages),
                    onRemove: (i) =>
                        ctrl.removeImage(ctrl.beforeImages, i),
                  )),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() => _ImageColumn(
                    label: 'During',
                    color: const Color(0xFF7C3AED),
                    images: ctrl.duringImages,
                    onAdd: () => ctrl.addMockImage(ctrl.duringImages),
                    onRemove: (i) =>
                        ctrl.removeImage(ctrl.duringImages, i),
                  )),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() => _ImageColumn(
                    label: 'After',
                    color: const Color(0xFF00D4FF),
                    images: ctrl.afterImages,
                    onAdd: () => ctrl.addMockImage(ctrl.afterImages),
                    onRemove: (i) =>
                        ctrl.removeImage(ctrl.afterImages, i),
                  )),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text('Customer Signature',
              style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),
        _SignaturePad(ctrl: ctrl),
      ]),
    );
  }
}

class _ImageColumn extends StatelessWidget {
  final String label;
  final Color color;
  final List<String> images;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  const _ImageColumn(
      {required this.label,
      required this.color,
      required this.images,
      required this.onAdd,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label,
          style: GoogleFonts.outfit(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      ...images.asMap().entries.map((e) => _ImageThumb(
            color: color,
            onRemove: () => onRemove(e.key),
            onTap: () => _showFull(context),
          )),
      GestureDetector(
        onTap: onAdd,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.35)),
              ),
              child: Center(
                  child: Icon(Icons.add_photo_alternate_outlined,
                      color: color, size: 28)),
            ),
          ),
        ),
      ),
    ]);
  }

  void _showFull(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(20),
        height: 300,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1A1F4E), Color(0xFF0A0E27)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Icon(Icons.image, color: color.withOpacity(0.7), size: 80),
              const SizedBox(height: 12),
              Text('$label Image',
                  style:
                      GoogleFonts.outfit(color: Colors.white54, fontSize: 14)),
            ])),
      ),
    );
  }
}

class _ImageThumb extends StatelessWidget {
  final Color color;
  final VoidCallback onRemove;
  final VoidCallback onTap;
  const _ImageThumb(
      {required this.color, required this.onRemove, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              colors: [color.withOpacity(0.3), color.withOpacity(0.1)]),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Stack(children: [
          Center(
              child: Icon(Icons.photo,
                  color: color.withOpacity(0.8), size: 32)),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red),
                child:
                    const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _SignaturePad extends StatefulWidget {
  final ServiceReportFormController ctrl;
  const _SignaturePad({required this.ctrl});
  @override
  State<_SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<_SignaturePad> {
  bool _signed = false;
  final List<Offset?> _points = [];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(children: [
                GestureDetector(
                  onPanUpdate: (d) {
                    setState(() {
                      _points.add(d.localPosition);
                      _signed = true;
                      widget.ctrl.hasSignature = true;
                    });
                  },
                  onPanEnd: (_) =>
                      setState(() => _points.add(null)),
                  child: CustomPaint(
                    painter: _SignaturePainter(_points),
                    size: const Size(double.infinity, 160),
                  ),
                ),
                if (!_signed)
                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.draw,
                              color: Colors.white24, size: 32),
                          const SizedBox(height: 8),
                          Text('Customer signature required',
                              style: GoogleFonts.outfit(
                                  color: Colors.white30, fontSize: 13)),
                        ]),
                  ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _points.clear();
                      _signed = false;
                      widget.ctrl.hasSignature = false;
                    }),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: Colors.white30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text('Clear',
                        style: GoogleFonts.outfit(
                            color: Colors.white60)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color(0xFF7C3AED),
                        Color(0xFF00D4FF)
                      ]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: _signed
                          ? () => Get.snackbar(
                                'Saved',
                                'Signature saved successfully',
                                backgroundColor:
                                    Colors.green.withOpacity(0.3),
                                colorText: Colors.white,
                              )
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('Save Signature',
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  _SignaturePainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D4FF)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => true;
}


class _Step3 extends StatelessWidget {
  final ServiceReportFormController ctrl;
  final String serviceRequestId;
  final String customerName;
  const _Step3(
      {required this.ctrl,
      required this.serviceRequestId,
      required this.customerName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(18),
                border:
                    Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Column(children: [
                _row(Icons.receipt_long, 'Report ID', serviceRequestId),
                _div(),
                _row(Icons.person, 'Customer', customerName),
                _div(),
                _row(Icons.description, 'Findings',
                    ctrl.findingsCtrl.text.isEmpty
                        ? 'Not entered'
                        : ctrl.findingsCtrl.text.substring(
                                0,
                                min(50,
                                    ctrl.findingsCtrl.text.length)) +
                            (ctrl.findingsCtrl.text.length > 50
                                ? '...'
                                : '')),
                _div(),
                Obx(() => _row(Icons.build, 'Parts Used',
                    ctrl.parts.isEmpty
                        ? 'None'
                        : ctrl.parts.join(', '))),
                _div(),
                Obx(() => _row(
                    Icons.photo_library,
                    'Images',
                    '${ctrl.beforeImages.length + ctrl.duringImages.length + ctrl.afterImages.length} attached')),
                _div(),
                _row(Icons.draw, 'Signature',
                    ctrl.hasSignature ? '✓ Captured' : 'Not captured'),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => GestureDetector(
              onTap: () => ctrl.termsAccepted.toggle(),
              child: Row(children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: ctrl.termsAccepted.value
                        ? const LinearGradient(colors: [
                            Color(0xFF7C3AED),
                            Color(0xFF00D4FF)
                          ])
                        : null,
                    color: ctrl.termsAccepted.value
                        ? null
                        : Colors.white.withOpacity(0.1),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: ctrl.termsAccepted.value
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 14)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                      'I confirm all information is accurate and the service has been completed',
                      style: GoogleFonts.outfit(
                          color: Colors.white70, fontSize: 12)),
                ),
              ]),
            )),
        const SizedBox(height: 20),
        Obx(() => _GradientButton(
              label: ctrl.isSubmitting.value
                  ? 'Submitting...'
                  : 'Submit Report',
              icon: ctrl.isSubmitting.value
                  ? null
                  : Icons.send_rounded,
              loading: ctrl.isSubmitting.value,
              enabled: ctrl.termsAccepted.value,
              onTap: ctrl.termsAccepted.value
                  ? ctrl.submitReport
                  : null,
            )),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => Get.back(),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white30),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text('Save Draft',
              style: GoogleFonts.outfit(
                  color: Colors.white60,
                  fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Icon(icon, color: const Color(0xFF00D4FF), size: 18),
          const SizedBox(width: 10),
          Text('$label: ',
              style: GoogleFonts.outfit(
                  color: Colors.white54, fontSize: 13)),
          Expanded(
            child: Text(value,
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
          ),
        ]),
      );

  Widget _div() =>
      Divider(color: Colors.white.withOpacity(0.08), height: 1);
}


class _NavBar extends StatelessWidget {
  final ServiceReportFormController ctrl;
  const _NavBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isSubmitted.value) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(children: [
          if (ctrl.currentStep.value > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: ctrl.prevStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Back',
                    style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
          ],
          if (ctrl.currentStep.value < 2)
            Expanded(
              flex: 2,
              child: _GradientButton(
                label: 'Next',
                icon: Icons.arrow_forward_rounded,
                onTap: ctrl.nextStep,
              ),
            ),
        ]),
      );
    });
  }
}


class _SuccessView extends StatefulWidget {
  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _scale = CurvedAnimation(parent: _ac, curve: Curves.elasticOut);
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scale,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color(0xFF7C3AED),
                      Color(0xFF00D4FF)
                    ]),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 56),
                ),
                const SizedBox(height: 24),
                Text('Report Submitted!',
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                    'Your service report has been saved successfully',
                    style: GoogleFonts.outfit(
                        color: Colors.white54, fontSize: 14),
                    textAlign: TextAlign.center),
                const SizedBox(height: 32),
                _GradientButton(
                  label: 'Back to Jobs',
                  icon: Icons.home_rounded,
                  onTap: () => Get.back(),
                ),
              ]),
        ),
      ),
    );
  }
}


class _GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool loading;
  final bool enabled;
  const _GradientButton(
      {required this.label,
      this.icon,
      this.onTap,
      this.loading = false,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color(0xFF7C3AED),
              Color(0xFF3B82F6),
              Color(0xFF00D4FF)
            ]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF7C3AED).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : Row(mainAxisSize: MainAxisSize.min, children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(label,
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ]),
          ),
        ),
      ),
    );
  }
}
