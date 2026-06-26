
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/chat_controller.dart';
import '../../../data/models/chat_message_model.dart';

const _kDark   = Color(0xFF0A0E27);
const _kSurface = Color(0xFF1A1F4E);
const _kCyan   = Color(0xFF00D4FF);
const _kBlue   = Color(0xFF3B82F6);
const _kPurple = Color(0xFF7C3AED);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatController _ctrl;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<ChatController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    ever(_ctrl.messages, (_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDark,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0A0E27), Color(0xFF0D1333)]))),
          Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildMessageList()),
              _buildInputBar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [_kSurface.withOpacity(0.85), _kDark.withOpacity(0.7)]),
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08)))),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.15))),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [_kPurple, _kBlue])),
                  child: Center(child: Text('MJ', style: GoogleFonts.outfit(
                    fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Marcus Johnson', style: GoogleFonts.outfit(
                      fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    Row(children: [
                      Container(width: 8, height: 8,
                        decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('Dispatch Admin · Online', style: GoogleFonts.outfit(
                        fontSize: 11, color: const Color(0xFF10B981))),
                    ]),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.12))),
                    child: const Icon(Icons.call_outlined, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return Obx(() {
      if (_ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: _kCyan));
      }
      return ListView.builder(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        itemCount: _ctrl.messages.length,
        itemBuilder: (_, i) {
          final msg = _ctrl.messages[i];
          final isMe = msg.senderId == 'tech-001';
          final showDate = i == 0 ||
            !_isSameDay(_ctrl.messages[i - 1].timestamp, msg.timestamp);
          return Column(
            children: [
              if (showDate) _dateDivider(msg.timestamp),
              _MessageBubble(message: msg, isMe: isMe),
            ],
          );
        },
      );
    });
  }

  Widget _dateDivider(DateTime dt) {
    final label = _isSameDay(dt, DateTime.now())
        ? 'Today'
        : DateFormat('MMMM d').format(dt);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: GoogleFonts.outfit(fontSize: 11, color: Colors.white30))),
        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
      ]),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [_kSurface.withOpacity(0.85), _kDark.withOpacity(0.7)]),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08)))),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.12))),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            controller: _ctrl.textController,
                            style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12)),
                            onSubmitted: (t) => _ctrl.sendMessage(t),
                          ),
                        ),
                        
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.attach_file_rounded,
                              color: Colors.white38, size: 20)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                
                Obx(() => GestureDetector(
                  onTap: () => _ctrl.sendMessage(_ctrl.textController.text),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [_kBlue, _kCyan]),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: _kCyan.withOpacity(0.4), blurRadius: 12)]),
                    child: _ctrl.isSending.value
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}


class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});
  final ChatMessageModel message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
          left: isMe ? 60 : 0,
          right: isMe ? 0 : 60),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft:     const Radius.circular(18),
                topRight:    const Radius.circular(18),
                bottomLeft:  Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isMe
                      ? const LinearGradient(
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)])
                      : LinearGradient(
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                          colors: [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.06)]),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18), topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18)),
                    border: isMe ? null : Border.all(color: Colors.white.withOpacity(0.12))),
                  child: Text(message.message,
                    style: GoogleFonts.outfit(
                      fontSize: 14, color: Colors.white, height: 1.4)),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DateFormat('h:mm a').format(message.timestamp),
                  style: GoogleFonts.outfit(fontSize: 10, color: Colors.white30)),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                    size: 14, color: message.isRead ? _kCyan : Colors.white30),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

