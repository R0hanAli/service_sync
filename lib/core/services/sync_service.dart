import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasources/local/sqlite_helper.dart';



class SyncService extends GetxService {
  
  final RxBool isSyncing = false.obs;
  final RxBool isOnline = true.obs;
  final RxInt pendingCount = 0.obs;

  
  final SQLiteHelper _db = SQLiteHelper.instance;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _periodicSyncTimer;

  static const Duration _syncInterval = Duration(seconds: 30);

  
  @override
  Future<void> onInit() async {
    super.onInit();
    await startMonitoring();
  }

  @override
  void onClose() {
    _connectivitySub?.cancel();
    _periodicSyncTimer?.cancel();
    super.onClose();
  }

  
  Future<void> startMonitoring() async {
    
    final results = await Connectivity().checkConnectivity();
    _handleConnectivityChange(results);

    
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen(_handleConnectivityChange);

    
    _periodicSyncTimer = Timer.periodic(_syncInterval, (_) async {
      if (isOnline.value && !isSyncing.value) {
        await sync();
      }
    });

    
    await _refreshPendingCount();
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (r) => r != ConnectivityResult.none,
    );

    final wasOffline = !isOnline.value;
    isOnline.value = hasConnection;

    if (hasConnection && wasOffline) {
      
      sync();
    }
  }

  
  Future<void> sync() async {
    if (isSyncing.value || !isOnline.value) return;

    isSyncing.value = true;

    try {
      final items = await _db.getPendingSyncItems();
      if (items.isEmpty) {
        isSyncing.value = false;
        return;
      }

      int successCount = 0;

      for (final item in items) {
        try {
          final operation = item['operation'] as String? ?? '';
          final tableName = item['tableName'] as String? ?? '';
          final payloadStr = item['payload'] as String? ?? '{}';
          final payload = jsonDecode(payloadStr) as Map<String, dynamic>;
          final queueId = item['id'] as int;

          
          await _performRemoteOperation(
            operation: operation,
            tableName: tableName,
            payload: payload,
          );

          
          await _db.deleteSyncQueueItem(queueId);
          successCount++;
        } catch (e) {
          
          debugPrint('[SyncService] Failed to sync item: $e');
        }
      }

      await _refreshPendingCount();

      if (successCount > 0) {
        _showSyncSuccess(successCount);
      }
    } catch (e) {
      debugPrint('[SyncService] sync error: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  
  Future<void> _performRemoteOperation({
    required String operation,
    required String tableName,
    required Map<String, dynamic> payload,
  }) async {
    
    await Future.delayed(const Duration(milliseconds: 150));

    
    
    
    
    
    
    
    
    
    
    
    

    debugPrint('[SyncService] Mock $operation on $tableName — payload keys: ${payload.keys.join(', ')}');
  }

  
  
  Future<void> addToQueue(
    String operation,
    String tableName,
    Map<String, dynamic> payload,
  ) async {
    await _db.addToSyncQueue({
      'operation': operation.toUpperCase(),
      'tableName': tableName,
      'payload': jsonEncode(payload),
    });
    await _refreshPendingCount();

    
    if (isOnline.value && !isSyncing.value) {
      unawaited(sync());
    }
  }

  
  Future<void> _refreshPendingCount() async {
    final items = await _db.getPendingSyncItems();
    pendingCount.value = items.length;
  }

  void _showSyncSuccess(int count) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        '✅ Sync Complete',
        '$count ${count == 1 ? 'record' : 'records'} synced to cloud',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF2ED573).withValues(alpha: 0.92),
        colorText: Colors.white,
        borderRadius: 16,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.cloud_done_rounded, color: Colors.white),
        isDismissible: true,
      );
    }
  }

  
  String get statusText {
    if (!isOnline.value) return 'Offline';
    if (isSyncing.value) return 'Syncing…';
    if (pendingCount.value > 0) return '${pendingCount.value} pending';
    return 'Synced';
  }

  Color get statusColor {
    if (!isOnline.value) return const Color(0xFFFF4757);
    if (isSyncing.value) return const Color(0xFFFFA502);
    if (pendingCount.value > 0) return const Color(0xFFFFA502);
    return const Color(0xFF2ED573);
  }
}
