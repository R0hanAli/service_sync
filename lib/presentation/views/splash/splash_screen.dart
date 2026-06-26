import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../presentation/controllers/auth_controller.dart';
import '../../../core/utils/app_constants.dart';




class _Particle {
  double x, y, radius, speedX, speedY, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });
}




class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double tick;

  _ParticlePainter(this.particles, this.tick);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final x = (p.x + p.speedX * tick) % size.width;
      final y = (p.y + p.speedY * tick) % size.height;
      paint.color = const Color(0xFF00D4FF).withOpacity(p.opacity);
      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  
  late final AnimationController _orbController;
  late final AnimationController _particleController;
  late final AnimationController _staggerController;

  
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _barOpacity;
  late final Animation<double> _progressValue;

  
  late final List<_Particle> _particles;
  final _rng = Random(42);

  @override
  void initState() {
    super.initState();

    
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.35, 0.6, curve: Curves.easeIn),
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );
    _barOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.6, 0.8, curve: Curves.easeIn),
      ),
    );
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeInOut),
      ),
    );

    
    _particles = List.generate(22, (_) {
      return _Particle(
        x: _rng.nextDouble() * 400,
        y: _rng.nextDouble() * 800,
        radius: _rng.nextDouble() * 2.2 + 0.6,
        speedX: (_rng.nextDouble() - 0.5) * 0.3,
        speedY: (_rng.nextDouble() - 0.5) * 0.3,
        opacity: _rng.nextDouble() * 0.35 + 0.08,
      );
    });

    
    _staggerController.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;
    final auth = Get.find<AuthController>();
    if (auth.isLoggedIn.value) {
      Get.offAllNamed(AppConstants.dashboardRoute);
    } else {
      Get.offAllNamed(AppConstants.loginRoute);
    }
  }

  @override
  void dispose() {
    _orbController.dispose();
    _particleController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A0E27), Color(0xFF1A1F4E), Color(0xFF0A0E27)],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _ParticlePainter(
                _particles,
                _particleController.value * 3600,
              ),
            ),
          ),

          
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) {
              final scale = 0.85 + _orbController.value * 0.3;
              return Positioned(
                top: -100,
                left: -80,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF3B82F6).withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) {
              final scale = 1.0 - _orbController.value * 0.2;
              return Positioned(
                top: size.height * 0.3,
                right: -120,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 360,
                    height: 360,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF7C3AED).withOpacity(0.20),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) {
              final scale = 0.9 + _orbController.value * 0.25;
              return Positioned(
                bottom: -80,
                left: size.width * 0.2,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF00D4FF).withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                
                AnimatedBuilder(
                  animation: _staggerController,
                  builder: (_, __) => Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: _buildLogo(),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                
                AnimatedBuilder(
                  animation: _staggerController,
                  builder: (_, __) => Opacity(
                    opacity: _textOpacity.value,
                    child: SlideTransition(
                      position: _textSlide,
                      child: _buildBranding(),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                
                AnimatedBuilder(
                  animation: _staggerController,
                  builder: (_, __) => Opacity(
                    opacity: _barOpacity.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: _buildLoadingBar(_progressValue.value),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                
                AnimatedBuilder(
                  animation: _staggerController,
                  builder: (_, __) => Opacity(
                    opacity: _barOpacity.value,
                    child: Text(
                      'v${AppConstants.appVersion}',
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF00D4FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.45),
            blurRadius: 40,
            spreadRadius: 8,
          ),
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.30),
            blurRadius: 60,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.settings_suggest_rounded,
        color: Colors.white,
        size: 58,
      ),
    );
  }

  Widget _buildBranding() {
    return Column(
      children: [
        Text(
          'ServiceSync',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Field Service Management',
          style: GoogleFonts.outfit(
            color: const Color(0xFF00D4FF),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingBar(double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Initializing…',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF00D4FF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.10),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF00D4FF),
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
