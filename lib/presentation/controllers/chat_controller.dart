import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasources/local/sqlite_helper.dart';
import '../../data/models/chat_message_model.dart';

class ChatController extends GetxController {
  
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final TextEditingController textController = TextEditingController();

  
  static const String _technicianId = 'tech-001';
  static const String _technicianName = 'Alex Rodriguez';
  static const String _adminId = 'admin-001';
  static const String _adminName = 'Marcus Johnson';

  final SQLiteHelper _db = SQLiteHelper.instance;
  final Random _rng = Random();
  Timer? _replyTimer;

  
  static const _adminReplies = [
    'Got it, thanks for the update!',
    'Copy that. Keep up the great work!',
    'Understood. Let me know if you need anything else.',
    'Perfect — customer should be satisfied with that.',
    'Great job out there. Move to the next job when ready.',
    'I see you\'re making good progress. Stay safe!',
    'Acknowledged. I\'ve updated the dispatch board.',
    'Thanks for the heads up. I\'ll notify the customer.',
  ];

  
  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  @override
  void onClose() {
    textController.dispose();
    _replyTimer?.cancel();
    super.onClose();
  }

  
  Future<void> loadMessages() async {
    isLoading.value = true;
    try {
      final maps = await _db.getChatMessages(_technicianId, _adminId);
      if (maps.isEmpty) {
        messages.assignAll(_mockMessages());
      } else {
        messages.assignAll(maps.map((m) => ChatMessageModel.fromMap(m)));
      }
    } catch (e) {
      debugPrint('[ChatController] loadMessages error: $e');
      messages.assignAll(_mockMessages());
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    isSending.value = true;
    textController.clear();

    try {
      final msg = ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _technicianId,
        senderName: _technicianName,
        receiverId: _adminId,
        message: text.trim(),
        timestamp: DateTime.now(),
        isRead: true,
        attachmentUrl: '',
      );

      messages.add(msg);
      await _db.insertChatMessage(msg.toMap());

      
      _scheduleAdminReply();
    } catch (e) {
      debugPrint('[ChatController] sendMessage error: $e');
    } finally {
      isSending.value = false;
    }
  }

  
  void _scheduleAdminReply() {
    _replyTimer?.cancel();
    final delay = Duration(seconds: 2 + _rng.nextInt(3));
    _replyTimer = Timer(delay, () async {
      final reply = ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _adminId,
        senderName: _adminName,
        receiverId: _technicianId,
        message: _adminReplies[_rng.nextInt(_adminReplies.length)],
        timestamp: DateTime.now(),
        isRead: false,
        attachmentUrl: '',
      );
      messages.add(reply);
      try {
        await _db.insertChatMessage(reply.toMap());
      } catch (_) {}
    });
  }

  
  List<ChatMessageModel> _mockMessages() {
    final now = DateTime.now();
    return [
      ChatMessageModel(
        id: 'msg-001',
        senderId: _adminId,
        senderName: _adminName,
        receiverId: _technicianId,
        message: 'Good morning Alex! Big day ahead. Start with req-003, it\'s marked emergency.',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
        attachmentUrl: '',
      ),
      ChatMessageModel(
        id: 'msg-002',
        senderId: _technicianId,
        senderName: _technicianName,
        receiverId: _adminId,
        message: 'Morning Marcus! Got it, heading to Pine Road first. ETA around 8:30 AM.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 55)),
        isRead: true,
        attachmentUrl: '',
      ),
      ChatMessageModel(
        id: 'msg-003',
        senderId: _adminId,
        senderName: _adminName,
        receiverId: _technicianId,
        message: 'Customer David Kim will meet you at the front door. Shutoff valve already closed.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 50)),
        isRead: true,
        attachmentUrl: '',
      ),
      ChatMessageModel(
        id: 'msg-004',
        senderId: _technicianId,
        senderName: _technicianName,
        receiverId: _adminId,
        message: 'Repair complete. Customer signed off. Heading to next job at Elm Court.',
        timestamp: now.subtract(const Duration(minutes: 45)),
        isRead: true,
        attachmentUrl: '',
      ),
      ChatMessageModel(
        id: 'msg-005',
        senderId: _adminId,
        senderName: _adminName,
        receiverId: _technicianId,
        message: 'Photo-document the panel before starting work on REQ-010.',
        timestamp: now.subtract(const Duration(minutes: 10)),
        isRead: false,
        attachmentUrl: '',
      ),
    ];
  }
}
