import 'dart:convert';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role; 
  final String? profileImage;
  final String createdAt;
  final int assignedJobs;
  final int completedJobs;
  final double completionRate;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImage,
    required this.createdAt,
    this.assignedJobs = 0,
    this.completedJobs = 0,
    this.completionRate = 0.0,
  });

  
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? profileImage,
    String? createdAt,
    int? assignedJobs,
    int? completedJobs,
    double? completionRate,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      assignedJobs: assignedJobs ?? this.assignedJobs,
      completedJobs: completedJobs ?? this.completedJobs,
      completionRate: completionRate ?? this.completionRate,
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'profile_image': profileImage,
      'created_at': createdAt,
      'assigned_jobs': assignedJobs,
      'completed_jobs': completedJobs,
      'completion_rate': completionRate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: map['role'] as String? ?? 'technician',
      profileImage: map['profile_image'] as String?,
      createdAt: map['created_at'] as String? ?? '',
      assignedJobs: map['assigned_jobs'] as int? ?? 0,
      completedJobs: map['completed_jobs'] as int? ?? 0,
      completionRate: (map['completion_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  
  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  
  factory UserModel.fromSupabase(Map<String, dynamic> map) =>
      UserModel.fromMap(map);

  
  bool get isAdmin => role == 'admin';
  bool get isTechnician => role == 'technician';

  @override
  String toString() =>
      'UserModel(id: $id, fullName: $fullName, email: $email, role: $role)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
