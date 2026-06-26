import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class SQLiteHelper {
  
  SQLiteHelper._internal();
  static final SQLiteHelper instance = SQLiteHelper._internal();
  factory SQLiteHelper() => instance;

  static Database? _database;

  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'service_sync.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (final table in [
          'users',
          'service_requests',
          'service_reports',
          'customers',
          'notifications',
          'chat_messages',
          'sync_queue',
        ]) {
          await db.execute('DROP TABLE IF EXISTS $table');
        }
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id                TEXT PRIMARY KEY,
        full_name         TEXT,
        email             TEXT,
        phone             TEXT,
        role              TEXT,
        profile_image     TEXT,
        created_at        TEXT,
        assigned_jobs     INTEGER DEFAULT 0,
        completed_jobs    INTEGER DEFAULT 0,
        completion_rate   REAL    DEFAULT 0.0
      )
    ''');

    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS service_requests (
        requestId            TEXT PRIMARY KEY,
        customerName         TEXT,
        customerId           TEXT,
        serviceType          TEXT,
        issueDescription     TEXT,
        status               TEXT,
        assignedTechnician   TEXT,
        serviceDate          TEXT,
        priority             TEXT,
        address              TEXT,
        latitude             REAL,
        longitude            REAL,
        createdAt            TEXT,
        qrCode               TEXT
      )
    ''');

    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS service_reports (
        reportId                 TEXT PRIMARY KEY,
        serviceRequestReference  TEXT,
        findings                 TEXT,
        actionsTaken             TEXT,
        completionNotes          TEXT,
        images                   TEXT,
        signature                TEXT,
        voiceNote                TEXT,
        timestamp                TEXT,
        technicianId             TEXT,
        customerName             TEXT,
        partsUsed                TEXT
      )
    ''');

    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS customers (
        customer_id     TEXT PRIMARY KEY,
        name            TEXT,
        email           TEXT,
        phone           TEXT,
        address         TEXT,
        latitude        REAL,
        longitude       REAL,
        service_history TEXT
      )
    ''');

    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications (
        id         TEXT PRIMARY KEY,
        title      TEXT,
        body       TEXT,
        type       TEXT,
        readStatus INTEGER DEFAULT 0,
        timestamp  TEXT,
        relatedId  TEXT
      )
    ''');

    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS chat_messages (
        id             TEXT PRIMARY KEY,
        sender_id      TEXT,
        sender_name    TEXT,
        receiver_id    TEXT,
        message        TEXT,
        timestamp      TEXT,
        is_read        INTEGER DEFAULT 0,
        attachment_url TEXT
      )
    ''');

    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_queue (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        operation TEXT,
        tableName TEXT,
        payload   TEXT,
        createdAt TEXT
      )
    ''');
  }

  
  
  

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(String id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'users',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users', orderBy: 'full_name ASC');
  }

  
  
  

  Future<int> insertServiceRequest(Map<String, dynamic> request) async {
    final db = await database;
    return await db.insert(
      'service_requests',
      request,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getServiceRequest(String requestId) async {
    final db = await database;
    final result = await db.query(
      'service_requests',
      where: 'requestId = ?',
      whereArgs: [requestId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateServiceRequest(
      String requestId, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'service_requests',
      data,
      where: 'requestId = ?',
      whereArgs: [requestId],
    );
  }

  
  Future<int> updateServiceRequestStatus(
      String requestId, String status) async {
    return updateServiceRequest(requestId, {'status': status});
  }

  Future<List<Map<String, dynamic>>> getAllServiceRequests() async {
    final db = await database;
    return await db.query(
      'service_requests',
      orderBy: 'createdAt DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getServiceRequestsByStatus(
      String status) async {
    final db = await database;
    return await db.query(
      'service_requests',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'createdAt DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getServiceRequestsByTechnician(
      String technicianId) async {
    final db = await database;
    return await db.query(
      'service_requests',
      where: 'assignedTechnician = ?',
      whereArgs: [technicianId],
      orderBy: 'createdAt DESC',
    );
  }

  
  
  

  Future<int> insertServiceReport(Map<String, dynamic> report) async {
    final db = await database;
    return await db.insert(
      'service_reports',
      report,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getServiceReport(String reportId) async {
    final db = await database;
    final result = await db.query(
      'service_reports',
      where: 'reportId = ?',
      whereArgs: [reportId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllServiceReports() async {
    final db = await database;
    return await db.query(
      'service_reports',
      orderBy: 'timestamp DESC',
    );
  }

  
  Future<List<Map<String, dynamic>>> getAllReports() => getAllServiceReports();

  
  Future<int> insertReport(Map<String, dynamic> report) =>
      insertServiceReport(report);

  Future<List<Map<String, dynamic>>> getReportsByTechnician(
      String technicianId) async {
    final db = await database;
    return await db.query(
      'service_reports',
      where: 'technicianId = ?',
      whereArgs: [technicianId],
      orderBy: 'timestamp DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getReportsByRequest(
      String serviceRequestReference) async {
    final db = await database;
    return await db.query(
      'service_reports',
      where: 'serviceRequestReference = ?',
      whereArgs: [serviceRequestReference],
      orderBy: 'timestamp DESC',
    );
  }

  
  
  

  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    final db = await database;
    return await db.insert(
      'customers',
      customer,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getCustomer(String customerId) async {
    final db = await database;
    final result = await db.query(
      'customers',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await database;
    return await db.query('customers', orderBy: 'name ASC');
  }

  
  
  

  Future<int> insertNotification(Map<String, dynamic> notification) async {
    final db = await database;
    return await db.insert(
      'notifications',
      notification,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    final db = await database;
    return await db.query(
      'notifications',
      orderBy: 'timestamp DESC',
    );
  }

  Future<int> markNotificationRead(String id) async {
    final db = await database;
    return await db.update(
      'notifications',
      {'readStatus': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> markAllNotificationsRead() async {
    final db = await database;
    return await db.update('notifications', {'readStatus': 1});
  }

  Future<int> getUnreadCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notifications WHERE readStatus = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  
  
  

  Future<int> insertChatMessage(Map<String, dynamic> message) async {
    final db = await database;
    return await db.insert(
      'chat_messages',
      message,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getChatMessages(
      String userId, String partnerId) async {
    final db = await database;
    return await db.query(
      'chat_messages',
      where:
          '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      whereArgs: [userId, partnerId, partnerId, userId],
      orderBy: 'timestamp ASC',
    );
  }

  Future<int> markMessageRead(String id) async {
    final db = await database;
    return await db.update(
      'chat_messages',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  
  
  

  Future<int> addToSyncQueue(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert(
      'sync_queue',
      {
        ...item,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  
  Future<int> enqueueSyncItem({
    required String operation,
    required String tableName,
    required String payload,
  }) =>
      addToSyncQueue({
        'operation': operation,
        'tableName': tableName,
        'payload': payload,
      });

  Future<int> getSyncQueueCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as c FROM sync_queue');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    final db = await database;
    return await db.query(
      'sync_queue',
      orderBy: 'createdAt ASC',
    );
  }

  Future<int> deleteSyncQueueItem(int id) async {
    final db = await database;
    return await db.delete(
      'sync_queue',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearSyncQueue() async {
    final db = await database;
    return await db.delete('sync_queue');
  }

  
  
  

  
  Future<void> resetDatabase() async {
    final db = await database;
    await db.transaction((txn) async {
      for (final table in [
        'users',
        'service_requests',
        'service_reports',
        'customers',
        'notifications',
        'chat_messages',
        'sync_queue',
      ]) {
        await txn.execute('DROP TABLE IF EXISTS $table');
      }
      await _createTables(db);
    });
  }

  
  Future<int> rowCount(String tableName) async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as c FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
