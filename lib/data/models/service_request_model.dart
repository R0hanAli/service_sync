import 'dart:convert';

class ServiceRequestModel {
  final String requestId;
  final String customerName;
  final String customerId;
  final String serviceType;
  final String issueDescription;
  final String status; 
  final String assignedTechnician;
  final String serviceDate;
  final String priority; 
  final String address;
  final double? latitude;
  final double? longitude;
  final String createdAt;
  final String? qrCode; 

  
  String get id => requestId;
  String get customerAddress => address;
  String get description => issueDescription;
  DateTime? get scheduledDate {
    if (serviceDate.isEmpty) return null;
    return DateTime.tryParse(serviceDate);
  }
  bool get isEmergency => priority.toLowerCase() == 'emergency';
  String get customerPhone => '';
  String get estimatedDuration => '1h';

  ServiceRequestModel({
    String? id,
    String? requestId,
    this.customerName = '',
    this.customerId = '',
    this.serviceType = '',
    String? description,
    String? issueDescription,
    this.status = 'pending',
    this.assignedTechnician = '',
    DateTime? scheduledDate,
    String? serviceDate,
    this.priority = 'medium',
    String? customerAddress,
    String? address,
    this.latitude,
    this.longitude,
    dynamic createdAt,
    this.qrCode,
    
    dynamic customerPhone,
    dynamic assignedTechnicianId,
    dynamic estimatedDuration,
  })  : requestId = requestId ?? id ?? '',
        issueDescription = issueDescription ?? description ?? '',
        serviceDate = serviceDate ?? (scheduledDate != null ? scheduledDate.toIso8601String() : ''),
        address = address ?? customerAddress ?? '',
        createdAt = createdAt is DateTime
            ? createdAt.toIso8601String()
            : (createdAt?.toString() ?? '');

  
  ServiceRequestModel copyWith({
    String? id,
    String? requestId,
    String? customerName,
    String? customerId,
    String? serviceType,
    String? description,
    String? issueDescription,
    String? status,
    String? assignedTechnician,
    DateTime? scheduledDate,
    String? serviceDate,
    String? priority,
    String? customerAddress,
    String? address,
    double? latitude,
    double? longitude,
    String? createdAt,
    String? qrCode,
  }) {
    return ServiceRequestModel(
      requestId: requestId ?? id ?? this.requestId,
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      serviceType: serviceType ?? this.serviceType,
      issueDescription: issueDescription ?? description ?? this.issueDescription,
      status: status ?? this.status,
      assignedTechnician: assignedTechnician ?? this.assignedTechnician,
      serviceDate: serviceDate ?? (scheduledDate != null ? scheduledDate.toIso8601String() : this.serviceDate),
      priority: priority ?? this.priority,
      address: address ?? customerAddress ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'customerName': customerName,
      'customerId': customerId,
      'serviceType': serviceType,
      'issueDescription': issueDescription,
      'status': status,
      'assignedTechnician': assignedTechnician,
      'serviceDate': serviceDate,
      'priority': priority,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
      'qrCode': qrCode,
    };
  }

  factory ServiceRequestModel.fromMap(Map<String, dynamic> map) {
    return ServiceRequestModel(
      requestId: map['requestId'] as String? ?? map['request_id'] as String? ?? '',
      customerName: map['customerName'] as String? ?? map['customer_name'] as String? ?? '',
      customerId: map['customerId'] as String? ?? map['customer_id'] as String? ?? '',
      serviceType: map['serviceType'] as String? ?? map['service_type'] as String? ?? '',
      issueDescription: map['issueDescription'] as String? ?? map['issue_description'] as String? ?? map['description'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      assignedTechnician: map['assignedTechnician'] as String? ?? map['assigned_technician'] as String? ?? '',
      serviceDate: map['serviceDate'] as String? ?? map['service_date'] as String? ?? '',
      priority: map['priority'] as String? ?? 'medium',
      address: map['address'] as String? ?? map['customerAddress'] as String? ?? map['customer_address'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      createdAt: map['createdAt'] as String? ?? map['created_at'] as String? ?? '',
      qrCode: map['qrCode'] as String? ?? map['qr_code'] as String?,
    );
  }

  
  String toJson() => jsonEncode(toMap());

  factory ServiceRequestModel.fromJson(String source) =>
      ServiceRequestModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory ServiceRequestModel.fromSupabase(Map<String, dynamic> map) =>
      ServiceRequestModel.fromMap(map);

  
  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isInProgress => status == 'inProgress';
  bool get isCompleted => status == 'completed';
  bool get isRejected => status == 'rejected';

  bool get isHighPriority => priority == 'high';

  bool get hasLocation => latitude != null && longitude != null;

  @override
  String toString() =>
      'ServiceRequestModel(requestId: $requestId, status: $status, priority: $priority)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceRequestModel && other.requestId == requestId;
  }

  @override
  int get hashCode => requestId.hashCode;
}
