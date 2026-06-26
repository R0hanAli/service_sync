import 'dart:convert';

class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? attachmentUrl;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.message,
    required dynamic timestamp,
    this.isRead = false,
    this.attachmentUrl,
  }) : timestamp = timestamp is DateTime
            ? timestamp
            : (DateTime.tryParse(timestamp?.toString() ?? '') ?? DateTime.now());

  
  ChatMessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? attachmentUrl,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead ? 1 : 0, 
      'attachment_url': attachmentUrl,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] as String? ?? '',
      senderId: map['sender_id'] as String? ?? '',
      senderName: map['sender_name'] as String? ?? '',
      receiverId: map['receiver_id'] as String? ?? '',
      message: map['message'] as String? ?? '',
      timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? DateTime.now(),
      isRead:
          map['is_read'] == 1 || map['is_read'] == true, 
      attachmentUrl: map['attachment_url'] as String?,
    );
  }

  
  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
      'attachment_url': attachmentUrl,
    };
  }

  String toJson() => jsonEncode(toSupabaseMap());

  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory ChatMessageModel.fromSupabase(Map<String, dynamic> map) =>
      ChatMessageModel.fromMap(map);

  
  bool get isUnread => !isRead;
  bool get hasAttachment =>
      attachmentUrl != null && attachmentUrl!.isNotEmpty;

  
  bool isSentBy(String userId) => senderId == userId;

  
  ChatMessageModel markAsRead() => copyWith(isRead: true);

  
  String conversationKey(String currentUserId) {
    final ids = [currentUserId, receiverId == currentUserId ? senderId : receiverId]
      ..sort();
    return ids.join('_');
  }

  @override
  String toString() =>
      'ChatMessageModel(id: $id, from: $senderId, to: $receiverId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessageModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
