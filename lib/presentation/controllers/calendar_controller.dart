import 'package:get/get.dart';

import '../../data/datasources/local/sqlite_helper.dart';
import '../../data/models/service_request_model.dart';

class CalendarController extends GetxController {
  
  final RxBool isLoading = false.obs;
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  final RxMap<DateTime, List<ServiceRequestModel>> eventsByDate =
      <DateTime, List<ServiceRequestModel>>{}.obs;
  final RxList<ServiceRequestModel> selectedDayJobs = <ServiceRequestModel>[].obs;

  final SQLiteHelper _db = SQLiteHelper.instance;

  
  @override
  void onInit() {
    super.onInit();
    loadCalendarData();
  }

  
  Future<void> loadCalendarData() async {
    isLoading.value = true;
    try {
      final maps = await _db.getAllServiceRequests();
      final jobs = maps.isEmpty
          ? _mockJobs()
          : maps.map((m) => ServiceRequestModel.fromMap(m)).toList();

      final grouped = <DateTime, List<ServiceRequestModel>>{};
      for (final job in jobs) {
        if (job.scheduledDate != null) {
          final key = _dateOnly(job.scheduledDate!);
          grouped.putIfAbsent(key, () => []).add(job);
        }
      }
      eventsByDate.assignAll(grouped);

      
      final today = _dateOnly(DateTime.now());
      selectDay(today);
    } catch (e) {
      eventsByDate.clear();
    } finally {
      isLoading.value = false;
    }
  }

  
  void selectDay(DateTime day) {
    selectedDay.value = day;
    final key = _dateOnly(day);
    selectedDayJobs.assignAll(eventsByDate[key] ?? []);
  }

  
  void previousMonth() {
    final d = focusedMonth.value;
    focusedMonth.value = DateTime(d.year, d.month - 1);
  }

  void nextMonth() {
    final d = focusedMonth.value;
    focusedMonth.value = DateTime(d.year, d.month + 1);
  }

  bool hasEvents(DateTime day) =>
      eventsByDate.containsKey(_dateOnly(day)) &&
      eventsByDate[_dateOnly(day)]!.isNotEmpty;

  List<ServiceRequestModel> eventsFor(DateTime day) =>
      eventsByDate[_dateOnly(day)] ?? [];

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  
  List<ServiceRequestModel> _mockJobs() {
    final now = DateTime.now();
    return [
      ServiceRequestModel(
        id: 'SR-001234', customerId: 'c1', customerName: 'John Harrison',
        customerPhone: '+1-555-0198', customerAddress: '742 Evergreen Terrace',
        serviceType: 'HVAC Repair', description: 'AC not cooling.',
        priority: 'high', status: 'inProgress',
        scheduledDate: now, createdAt: now.subtract(const Duration(hours: 2)),
        assignedTechnicianId: 'usr_001', estimatedDuration: 120,
      ),
      ServiceRequestModel(
        id: 'SR-001235', customerId: 'c2', customerName: 'Maria Santos',
        customerPhone: '+1-555-0234', customerAddress: '123 Maple Ave',
        serviceType: 'Electrical', description: 'Tripped breaker.',
        priority: 'emergency', status: 'pending',
        scheduledDate: now, createdAt: now.subtract(const Duration(hours: 5)),
        assignedTechnicianId: 'usr_001', estimatedDuration: 90,
      ),
      ServiceRequestModel(
        id: 'SR-001236', customerId: 'c5', customerName: 'Robert Kim',
        customerPhone: '+1-555-0521', customerAddress: '321 Pine St',
        serviceType: 'HVAC Maintenance', description: 'Annual checkup.',
        priority: 'low', status: 'pending',
        scheduledDate: now.add(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(hours: 1)),
        assignedTechnicianId: 'usr_001', estimatedDuration: 75,
      ),
      ServiceRequestModel(
        id: 'SR-001237', customerId: 'c7', customerName: 'James Thompson',
        customerPhone: '+1-555-0788', customerAddress: '14 Cedar Court',
        serviceType: 'Electrical', description: 'Install 3 ceiling fans.',
        priority: 'medium', status: 'accepted',
        scheduledDate: now.add(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(hours: 3)),
        assignedTechnicianId: 'usr_001', estimatedDuration: 180,
      ),
      ServiceRequestModel(
        id: 'SR-001238', customerId: 'c8', customerName: 'Emily Clark',
        customerPhone: '+1-555-0891', customerAddress: '92 Willow Way',
        serviceType: 'Plumbing', description: 'Hot water heater flush.',
        priority: 'low', status: 'pending',
        scheduledDate: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(hours: 1)),
        assignedTechnicianId: 'usr_001', estimatedDuration: 60,
      ),
    ];
  }
}
