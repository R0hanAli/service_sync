import 'dart:convert';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; 
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> payload;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.payload = const {},
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'readStatus': isRead ? 1 : 0,
      'timestamp': createdAt.toIso8601String(),
      'relatedId': jsonEncode(payload),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    bool read = false;
    if (map['readStatus'] != null) {
      read = map['readStatus'] == 1 || map['readStatus'] == true;
    } else if (map['read_status'] != null) {
      read = map['read_status'] == 1 || map['read_status'] == true;
    }

    DateTime created = DateTime.now();
    if (map['timestamp'] != null) {
      created = DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now();
    }

    Map<String, dynamic> pay = {};
    if (map['relatedId'] != null && map['relatedId'].toString().isNotEmpty) {
      try {
        final decoded = jsonDecode(map['relatedId'].toString());
        if (decoded is Map<String, dynamic>) {
          pay = decoded;
        }
      } catch (_) {
        pay = {'relatedId': map['relatedId']};
      }
    } else if (map['related_id'] != null && map['related_id'].toString().isNotEmpty) {
      try {
        final decoded = jsonDecode(map['related_id'].toString());
        if (decoded is Map<String, dynamic>) {
          pay = decoded;
        }
      } catch (_) {
        pay = {'relatedId': map['related_id']};
      }
    }

    return NotificationModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      type: map['type'] as String? ?? 'statusUpdate',
      isRead: read,
      createdAt: created,
      payload: pay,
    );
  }

  Map<String, dynamic> toSupabaseMap() => toMap();

  String toJson() => jsonEncode(toSupabaseMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory NotificationModel.fromSupabase(Map<String, dynamic> map) =>
      NotificationModel.fromMap(map);
}
