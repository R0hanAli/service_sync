import 'dart:convert';

class ServiceReportModel {
  final String reportId;
  final String serviceRequestReference;
  final String findings;
  final String actionsTaken;
  final String completionNotes;
  final List<String> images; 
  final String? signature; 
  final String? voiceNote; 
  final String timestamp;
  final String technicianId;
  final String customerName;
  final List<String> partsUsed;

  
  final String? technicianNameOverride;
  final bool isDraftValue;

  
  String get id => reportId;
  String get serviceRequestId => serviceRequestReference;
  String get technicianName => technicianNameOverride ?? 'Alex Rodriguez';
  String get actionsPerformed => actionsTaken;
  String get additionalNotes => completionNotes;
  bool get isDraft => isDraftValue;
  DateTime get createdAt => DateTime.tryParse(timestamp) ?? DateTime.now();
  DateTime get updatedAt => createdAt;

  ServiceReportModel({
    String? id,
    String? reportId,
    String? serviceRequestId,
    String? serviceRequestReference,
    this.findings = '',
    String? actionsPerformed,
    String? actionsTaken,
    String? additionalNotes,
    String? completionNotes,
    this.images = const [],
    this.signature,
    this.voiceNote,
    dynamic timestamp, 
    DateTime? createdAt,
    this.technicianId = '',
    String? customerName,
    dynamic partsUsed, 
    String? technicianName,
    bool? isDraft,
    DateTime? updatedAt,
  })  : reportId = reportId ?? id ?? '',
        serviceRequestReference = serviceRequestReference ?? serviceRequestId ?? '',
        actionsTaken = actionsTaken ?? actionsPerformed ?? '',
        completionNotes = completionNotes ?? additionalNotes ?? '',
        timestamp = timestamp is DateTime
            ? timestamp.toIso8601String()
            : (timestamp?.toString() ?? createdAt?.toIso8601String() ?? ''),
        customerName = customerName ?? 'John Smith',
        partsUsed = partsUsed is List<String>
            ? partsUsed
            : (partsUsed is List
                ? partsUsed.map((e) => e.toString()).toList()
                : (partsUsed is String
                    ? (partsUsed.trim().isEmpty ? <String>[] : <String>[partsUsed.trim()])
                    : const <String>[])),
        technicianNameOverride = technicianName,
        isDraftValue = isDraft ?? false;

  
  ServiceReportModel copyWith({
    String? id,
    String? reportId,
    String? serviceRequestId,
    String? serviceRequestReference,
    String? findings,
    String? actionsPerformed,
    String? actionsTaken,
    String? additionalNotes,
    String? completionNotes,
    List<String>? images,
    String? signature,
    String? voiceNote,
    dynamic timestamp,
    DateTime? createdAt,
    String? technicianId,
    String? customerName,
    dynamic partsUsed,
    String? technicianName,
    bool? isDraft,
  }) {
    return ServiceReportModel(
      reportId: reportId ?? id ?? this.reportId,
      serviceRequestReference: serviceRequestReference ?? serviceRequestId ?? this.serviceRequestReference,
      findings: findings ?? this.findings,
      actionsTaken: actionsTaken ?? actionsPerformed ?? this.actionsTaken,
      completionNotes: completionNotes ?? additionalNotes ?? this.completionNotes,
      images: images ?? this.images,
      signature: signature ?? this.signature,
      voiceNote: voiceNote ?? this.voiceNote,
      timestamp: timestamp ?? createdAt ?? this.timestamp,
      technicianId: technicianId ?? this.technicianId,
      customerName: customerName ?? this.customerName,
      partsUsed: partsUsed ?? this.partsUsed,
      technicianName: technicianName ?? this.technicianName,
      isDraft: isDraft ?? this.isDraft,
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'serviceRequestReference': serviceRequestReference,
      'findings': findings,
      'actionsTaken': actionsTaken,
      'completionNotes': completionNotes,
      'images': jsonEncode(images),
      'signature': signature,
      'voiceNote': voiceNote,
      'timestamp': timestamp,
      'technicianId': technicianId,
      'customerName': customerName,
      'partsUsed': jsonEncode(partsUsed),
    };
  }

  factory ServiceReportModel.fromMap(Map<String, dynamic> map) {
    List<String> _parseList(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) return raw.map((e) => e.toString()).toList();
      if (raw is String && raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) return decoded.map((e) => e.toString()).toList();
        } catch (_) {}
      }
      return [];
    }

    return ServiceReportModel(
      reportId: map['reportId'] as String? ?? map['report_id'] as String? ?? '',
      serviceRequestReference:
          map['serviceRequestReference'] as String? ?? map['service_request_reference'] as String? ?? '',
      findings: map['findings'] as String? ?? '',
      actionsTaken: map['actionsTaken'] as String? ?? map['actions_performed'] as String? ?? map['actions_taken'] as String? ?? '',
      completionNotes: map['completionNotes'] as String? ?? map['completion_notes'] as String? ?? map['additional_notes'] as String? ?? '',
      images: _parseList(map['images']),
      signature: map['signature'] as String?,
      voiceNote: map['voiceNote'] as String? ?? map['voice_note'] as String?,
      timestamp: map['timestamp'] as String? ?? '',
      technicianId: map['technicianId'] as String? ?? map['technician_id'] as String? ?? '',
      customerName: map['customerName'] as String? ?? map['customer_name'] as String? ?? '',
      partsUsed: _parseList(map['partsUsed'] ?? map['parts_used']),
    );
  }

  
  Map<String, dynamic> toSupabaseMap() => toMap();

  String toJson() => jsonEncode(toSupabaseMap());

  factory ServiceReportModel.fromJson(String source) =>
      ServiceReportModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory ServiceReportModel.fromSupabase(Map<String, dynamic> map) =>
      ServiceReportModel.fromMap(map);

  
  bool get hasImages => images.isNotEmpty;
  bool get hasSignature => signature != null && signature!.isNotEmpty;
  bool get hasVoiceNote => voiceNote != null && voiceNote!.isNotEmpty;
  bool get hasParts => partsUsed.isNotEmpty;

  @override
  String toString() =>
      'ServiceReportModel(reportId: $reportId, ref: $serviceRequestReference)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceReportModel && other.reportId == reportId;
  }

  @override
  int get hashCode => reportId.hashCode;
}
