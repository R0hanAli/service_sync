

import 'dart:ui';
import 'package:flutter/material.dart';



class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.isDark = true,
  });

  final Widget child;
  final bool isDark;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> with TickerProviderStateMixin {
  
  late AnimationController _gradientController;
  late Animation<Alignment> _topLeftAlignment;
  late Animation<Alignment> _bottomRightAlignment;

  
  late AnimationController _orb1Controller;
  late AnimationController _orb2Controller;
  late AnimationController _orb3Controller;

  late Animation<double> _orb1Scale;
  late Animation<double> _orb2Scale;
  late Animation<double> _orb3Scale;

  @override
  void initState() {
    super.initState();

    
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _topLeftAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topRight,
          end: Alignment.centerLeft,
        ),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _bottomRightAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
        ),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    
    _orb1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
    _orb1Scale = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _orb1Controller, curve: Curves.easeInOut),
    );

    
    _orb2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..repeat(reverse: true);
    _orb2Scale = Tween<double>(begin: 0.90, end: 1.10).animate(
      CurvedAnimation(parent: _orb2Controller, curve: Curves.easeInOut),
    );

    
    _orb3Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _orb3Scale = Tween<double>(begin: 0.80, end: 1.20).animate(
      CurvedAnimation(parent: _orb3Controller, curve: Curves.easeInOut),
    );

    
    Future.delayed(const Duration(milliseconds: 1200),
        () => _orb2Controller.forward());
    Future.delayed(const Duration(milliseconds: 2400),
        () => _orb3Controller.forward());
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _orb1Controller.dispose();
    _orb2Controller.dispose();
    _orb3Controller.dispose();
    super.dispose();
  }

  List<Color> get _darkGradientColors => const [
        Color(0xFF0A0E27),
        Color(0xFF1A1F4E),
        Color(0xFF0D1B3E),
      ];

  List<Color> get _lightGradientColors => const [
        Color(0xFFE8F0FE),
        Color(0xFFD0E8FF),
        Color(0xFFEEF2FF),
      ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors =
        widget.isDark ? _darkGradientColors : _lightGradientColors;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _gradientController,
        _orb1Controller,
        _orb2Controller,
        _orb3Controller,
      ]),
      builder: (context, _) {
        return Stack(
          children: [
            
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: _topLeftAlignment.value,
                  end: _bottomRightAlignment.value,
                  colors: colors,
                ),
              ),
            ),

            
            Positioned(
              top: -50,
              right: -50,
              child: Transform.scale(
                scale: _orb1Scale.value,
                child: _PulsingOrb(
                  size: 200,
                  color: const Color(0xFF00D4FF).withOpacity(
                    widget.isDark ? 0.15 : 0.12,
                  ),
                  blurSigma: 55,
                ),
              ),
            ),

            
            Positioned(
              bottom: -70,
              left: -70,
              child: Transform.scale(
                scale: _orb2Scale.value,
                child: _PulsingOrb(
                  size: 250,
                  color: const Color(0xFF7C3AED).withOpacity(
                    widget.isDark ? 0.12 : 0.08,
                  ),
                  blurSigma: 75,
                ),
              ),
            ),

            
            Positioned(
              top: size.height * 0.35,
              left: size.width * 0.25,
              child: Transform.scale(
                scale: _orb3Scale.value,
                child: _PulsingOrb(
                  size: 180,
                  color: const Color(0xFF0066FF).withOpacity(
                    widget.isDark ? 0.08 : 0.06,
                  ),
                  blurSigma: 65,
                ),
              ),
            ),

            
            if (widget.isDark)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.03,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/noise.png'),
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                ),
              ),

            
            widget.child,
          ],
        );
      },
    );
  }
}




class _PulsingOrb extends StatelessWidget {
  const _PulsingOrb({
    required this.size,
    required this.color,
    required this.blurSigma,
  });

  final double size;
  final Color color;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}
