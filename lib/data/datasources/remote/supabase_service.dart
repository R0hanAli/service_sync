import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';







class SupabaseService {
  
  SupabaseService._internal();
  static final SupabaseService instance = SupabaseService._internal();
  factory SupabaseService() => instance;

  final SupabaseClient _client = Supabase.instance.client;

  
  
  

  
  User? get currentUser => _client.auth.currentUser;

  
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  
  
  
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw SupabaseAuthException(
        'Sign-in failed: ${e.message}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw SupabaseAuthException('Unexpected sign-in error: $e');
    }
  }

  
  
  
  
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> userMetadata,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: userMetadata,
      );
      return response;
    } on AuthException catch (e) {
      throw SupabaseAuthException(
        'Sign-up failed: ${e.message}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw SupabaseAuthException('Unexpected sign-up error: $e');
    }
  }

  
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw SupabaseAuthException('Sign-out failed: ${e.message}');
    } catch (e) {
      throw SupabaseAuthException('Unexpected sign-out error: $e');
    }
  }

  
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw SupabaseAuthException(
        'Password reset failed: ${e.message}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw SupabaseAuthException('Unexpected reset-password error: $e');
    }
  }

  
  
  

  
  Future<List<Map<String, dynamic>>> fetchServiceRequests(
      String technicianId) async {
    try {
      final data = await _client
          .from('service_requests')
          .select()
          .eq('assignedTechnician', technicianId)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(data as List);
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to fetch service requests: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw SupabaseDatabaseException(
          'Unexpected error fetching service requests: $e');
    }
  }

  
  Future<void> updateServiceRequestStatus(
      String requestId, String status) async {
    try {
      await _client
          .from('service_requests')
          .update({'status': status})
          .eq('requestId', requestId);
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to update request status: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw SupabaseDatabaseException(
          'Unexpected error updating request status: $e');
    }
  }

  
  
  

  
  Future<void> insertServiceReport(Map<String, dynamic> report) async {
    try {
      await _client.from('service_reports').insert(report);
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to insert service report: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw SupabaseDatabaseException(
          'Unexpected error inserting service report: $e');
    }
  }

  
  
  

  
  Future<List<Map<String, dynamic>>> fetchNotifications(String userId) async {
    try {
      final data = await _client
          .from('notifications')
          .select()
          .or('relatedId.eq.$userId,relatedId.is.null')
          .order('timestamp', ascending: false);
      return List<Map<String, dynamic>>.from(data as List);
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to fetch notifications: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw SupabaseDatabaseException(
          'Unexpected error fetching notifications: $e');
    }
  }

  
  Future<void> markNotificationRead(String id) async {
    try {
      await _client
          .from('notifications')
          .update({'readStatus': 1})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to mark notification read: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw SupabaseDatabaseException(
          'Unexpected error marking notification read: $e');
    }
  }

  
  
  

  
  
  Future<List<Map<String, dynamic>>> fetchChatMessages(
      String userId, String partnerId) async {
    try {
      final data = await _client
          .from('chat_messages')
          .select()
          .or(
            'and(senderId.eq.$userId,receiverId.eq.$partnerId),'
            'and(senderId.eq.$partnerId,receiverId.eq.$userId)',
          )
          .order('timestamp', ascending: true);
      return List<Map<String, dynamic>>.from(data as List);
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to fetch chat messages: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw SupabaseDatabaseException(
          'Unexpected error fetching chat messages: $e');
    }
  }

  
  Future<void> sendChatMessage(Map<String, dynamic> message) async {
    try {
      await _client.from('chat_messages').insert(message);
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to send chat message: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw SupabaseDatabaseException(
          'Unexpected error sending chat message: $e');
    }
  }

  
  
  

  
  
  
  
  Future<String> uploadImage(String path, List<int> bytes) async {
    try {
      await _client.storage.from('service-images').uploadBinary(
            path,
            Uint8List.fromList(bytes),
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );
      return await getImageUrl(path);
    } on StorageException catch (e) {
      throw SupabaseStorageException(
        'Failed to upload image at "$path": ${e.message}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw SupabaseStorageException('Unexpected error uploading image: $e');
    }
  }

  
  Future<String> getImageUrl(String path) async {
    try {
      final url =
          _client.storage.from('service-images').getPublicUrl(path);
      return url;
    } on StorageException catch (e) {
      throw SupabaseStorageException(
        'Failed to get image URL for "$path": ${e.message}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw SupabaseStorageException(
          'Unexpected error getting image URL: $e');
    }
  }
}






class SupabaseAuthException implements Exception {
  final String message;
  final String? statusCode;

  const SupabaseAuthException(this.message, {this.statusCode});

  @override
  String toString() => 'SupabaseAuthException($statusCode): $message';
}


class SupabaseDatabaseException implements Exception {
  final String message;
  final String? code;

  const SupabaseDatabaseException(this.message, {this.code});

  @override
  String toString() => 'SupabaseDatabaseException($code): $message';
}


class SupabaseStorageException implements Exception {
  final String message;
  final String? statusCode;

  const SupabaseStorageException(this.message, {this.statusCode});

  @override
  String toString() => 'SupabaseStorageException($statusCode): $message';
}
