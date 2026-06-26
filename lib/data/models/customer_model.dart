import 'dart:convert';

class CustomerModel {
  final String customerId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<String> serviceHistory; 

  const CustomerModel({
    required this.customerId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.latitude,
    this.longitude,
    this.serviceHistory = const [],
  });

  
  CustomerModel copyWith({
    String? customerId,
    String? name,
    String? email,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    List<String>? serviceHistory,
  }) {
    return CustomerModel(
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      serviceHistory: serviceHistory ?? this.serviceHistory,
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'customer_id': customerId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'service_history': jsonEncode(serviceHistory), 
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    List<String> _parseHistory(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) return raw.map((e) => e.toString()).toList();
      if (raw is String && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List) return decoded.map((e) => e.toString()).toList();
      }
      return [];
    }

    return CustomerModel(
      customerId: map['customer_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      serviceHistory: _parseHistory(map['service_history']),
    );
  }

  
  Map<String, dynamic> toSupabaseMap() {
    return {
      'customer_id': customerId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'service_history': serviceHistory, 
    };
  }

  String toJson() => jsonEncode(toSupabaseMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory CustomerModel.fromSupabase(Map<String, dynamic> map) =>
      CustomerModel.fromMap(map);

  
  bool get hasLocation => latitude != null && longitude != null;
  int get totalJobs => serviceHistory.length;

  @override
  String toString() =>
      'CustomerModel(customerId: $customerId, name: $name, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerModel && other.customerId == customerId;
  }

  @override
  int get hashCode => customerId.hashCode;
}
