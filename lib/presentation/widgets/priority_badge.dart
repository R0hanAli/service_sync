

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PriorityBadge extends StatefulWidget {
  const PriorityBadge({super.key, required this.priority});

  final String priority;

  @override
  State<PriorityBadge> createState() => _PriorityBadgeState();
}

class _PriorityBadgeState extends State<PriorityBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  bool get _isEmergency => widget.priority.toLowerCase() == 'emergency';

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _shimmerAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    if (_isEmergency) {
      _shimmerController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _configFor(widget.priority);

    if (_isEmergency) {
      return AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _shimmerAnimation.value,
            child: child,
          );
        },
        child: _BadgePill(config: config),
      );
    }

    return _BadgePill(config: config);
  }

  static _PriorityConfig _configFor(String priority) {
    switch (priority.toLowerCase()) {
      case 'emergency':
        return _PriorityConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF1744), Color(0xFFD50000)],
          ),
          icon: Icons.emergency_rounded,
          label: 'EMERGENCY',
          textColor: Colors.white,
          shadowColor: const Color(0xFFFF1744),
        );
      case 'high':
        return _PriorityConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6D00), Color(0xFFFF8F00)],
          ),
          icon: Icons.warning_rounded,
          label: 'HIGH',
          textColor: Colors.white,
          shadowColor: const Color(0xFFFF6D00),
        );
      case 'medium':
        return _PriorityConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFAB00), Color(0xFFFFD600)],
          ),
          icon: Icons.info_rounded,
          label: 'MEDIUM',
          textColor: Colors.white,
          shadowColor: const Color(0xFFFFAB00),
        );
      case 'low':
      default:
        return _PriorityConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
          ),
          icon: Icons.check_circle_rounded,
          label: 'LOW',
          textColor: Colors.white,
          shadowColor: const Color(0xFF00C853),
        );
    }
  }
}




class _BadgePill extends StatelessWidget {
  const _BadgePill({required this.config});

  final _PriorityConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: config.gradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: config.shadowColor.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.textColor, size: 12),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: GoogleFonts.outfit(
              color: config.textColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}




class _PriorityConfig {
  const _PriorityConfig({
    required this.gradient,
    required this.icon,
    required this.label,
    required this.textColor,
    required this.shadowColor,
  });

  final Gradient gradient;
  final IconData icon;
  final String label;
  final Color textColor;
  final Color shadowColor;
}
