

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_sync/data/models/service_request_model.dart';
import 'package:service_sync/presentation/widgets/glass_widgets.dart';
import 'package:service_sync/presentation/widgets/priority_badge.dart';


const _kCyan = Color(0xFF00D4FF);
const _kBlue = Color(0xFF0066FF);




class JobCard extends StatefulWidget {
  const JobCard({
    super.key,
    required this.serviceRequest,
    required this.onTap,
    this.onAccept,
    this.onReject,
  });

  final ServiceRequestModel serviceRequest;
  final VoidCallback onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> with SingleTickerProviderStateMixin {
  late AnimationController _emergencyController;
  late Animation<double> _emergencyPulse;

  bool get _isEmergency =>
      widget.serviceRequest.priority.toLowerCase() == 'emergency';
  bool get _isPending =>
      widget.serviceRequest.status.toLowerCase() == 'pending';

  @override
  void initState() {
    super.initState();
    _emergencyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _emergencyPulse = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
          parent: _emergencyController, curve: Curves.easeInOut),
    );

    if (_isEmergency) {
      _emergencyController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _emergencyController.dispose();
    super.dispose();
  }

  Color _priorityAccentColor() {
    switch (widget.serviceRequest.priority.toLowerCase()) {
      case 'emergency':
        return const Color(0xFFFF1744);
      case 'high':
        return const Color(0xFFFF6D00);
      case 'medium':
        return const Color(0xFFFFAB00);
      case 'low':
      default:
        return const Color(0xFF00C853);
    }
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.serviceRequest;
    final accent = _priorityAccentColor();

    Widget card = GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _emergencyPulse,
        builder: (context, child) {
          return GlassCard(
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.symmetric(vertical: 6),
            borderRadius: 18,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.10),
                Colors.white.withOpacity(0.05),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _isEmergency
                      ? accent.withOpacity(_emergencyPulse.value)
                      : Colors.white.withOpacity(0.12),
                  width: _isEmergency ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),

                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Row(
                              children: [
                                Text(
                                  '#${req.requestId.length > 8 ? req.requestId.substring(0, 8).toUpperCase() : req.requestId.toUpperCase()}',
                                  style: GoogleFonts.outfit(
                                    color: _kCyan,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const Spacer(),
                                PriorityBadge(priority: req.priority),
                                const SizedBox(width: 6),
                                StatusBadge(status: req.status),
                              ],
                            ),

                            const SizedBox(height: 8),

                            
                            Text(
                              req.customerName,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 4),

                            
                            Text(
                              req.serviceType,
                              style: GoogleFonts.outfit(
                                color: Colors.white60,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 10),

                            
                            Row(
                              children: [
                                _IconLabel(
                                  icon: Icons.calendar_today_rounded,
                                  label: req.serviceDate.length > 10
                                      ? req.serviceDate.substring(0, 10)
                                      : req.serviceDate,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _IconLabel(
                                    icon: Icons.location_on_rounded,
                                    label: req.address,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white.withOpacity(0.4),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    
    if (_isPending &&
        (widget.onAccept != null || widget.onReject != null)) {
      card = Dismissible(
        key: ValueKey(req.requestId),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            widget.onAccept?.call();
          } else {
            widget.onReject?.call();
          }
          return false; 
        },
        background: _swipeBackground(
          color: const Color(0xFF00C853),
          icon: Icons.check_rounded,
          label: 'Accept',
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: _swipeBackground(
          color: const Color(0xFFFF1744),
          icon: Icons.close_rounded,
          label: 'Reject',
          alignment: Alignment.centerRight,
        ),
        child: card,
      );
    }

    return card;
  }

  Widget _swipeBackground({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.outfit(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ] else ...[
            Text(label,
                style: GoogleFonts.outfit(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            const SizedBox(width: 6),
            Icon(icon, color: color, size: 22),
          ],
        ],
      ),
    );
  }
}




class _IconLabel extends StatelessWidget {
  const _IconLabel({
    required this.icon,
    required this.label,
    this.maxLines,
  });

  final IconData icon;
  final String label;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _kCyan.withOpacity(0.7), size: 12),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
            maxLines: maxLines,
            overflow:
                maxLines != null ? TextOverflow.ellipsis : null,
          ),
        ),
      ],
    );
  }
}
