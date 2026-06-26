

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_sync/presentation/widgets/glass_widgets.dart';


const _kCyan = Color(0xFF00D4FF);
const _kBlue = Color(0xFF0066FF);




class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    this.trend,
    this.trendLabel,
    this.fullWidth = false,
    this.valuePrefix = '',
    this.valueSuffix = '',
  });

  final String title;
  final dynamic value; 
  final IconData icon;
  final List<Color> gradient;
  final double? trend;
  final String? trendLabel;
  final bool fullWidth;
  final String valuePrefix;
  final String valueSuffix;

  @override
  Widget build(BuildContext context) {
    final isPositive = (trend ?? 0) >= 0;
    final trendColor =
        isPositive ? const Color(0xFF00C853) : Colors.redAccent;
    final trendIcon = isPositive
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;

    return GlassCard(
      width: fullWidth ? double.infinity : 160,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 4),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),

          const SizedBox(height: 14),

          
          if (value is int)
            AnimatedCounter(
              value: value as int,
              prefix: valuePrefix,
              suffix: valueSuffix,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            )
          else
            Text(
              '$valuePrefix$value$valueSuffix',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),

          const SizedBox(height: 6),

          
          Text(
            title,
            style: GoogleFonts.outfit(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          
          if (trend != null) ...[
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: trendColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: trendColor.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(trendIcon, color: trendColor, size: 12),
                  const SizedBox(width: 3),
                  Text(
                    '${trend!.abs().toStringAsFixed(1)}%${trendLabel != null ? ' $trendLabel' : ''}',
                    style: GoogleFonts.outfit(
                      color: trendColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}




class StatCardRow extends StatelessWidget {
  const StatCardRow({super.key, required this.cards});

  final List<StatCard> cards;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: cards
            .map(
              (card) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: card,
              ),
            )
            .toList(),
      ),
    );
  }
}
