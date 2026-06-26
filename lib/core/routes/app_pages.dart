import 'package:get/get.dart';

import '../../presentation/controllers/analytics_controller.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/calendar_controller.dart';
import '../../presentation/controllers/chat_controller.dart';
import '../../presentation/controllers/dashboard_controller.dart';
import '../../presentation/controllers/job_controller.dart';
import '../../presentation/controllers/map_controller.dart';
import '../../presentation/controllers/notification_controller.dart';
import '../../presentation/controllers/profile_controller.dart';
import '../../presentation/controllers/report_controller.dart';
import '../../presentation/controllers/settings_controller.dart';
import '../../presentation/views/analytics/analytics_screen.dart';
import '../../presentation/views/auth/forgot_password_screen.dart';
import '../../presentation/views/auth/login_screen.dart';
import '../../presentation/views/auth/register_screen.dart';
import '../../presentation/views/calendar/calendar_screen.dart';
import '../../presentation/views/chat/chat_screen.dart';
import '../../presentation/views/dashboard/dashboard_screen.dart';
import '../../presentation/views/jobs/job_details_screen.dart';
import '../../presentation/views/jobs/job_list_screen.dart';
import '../../presentation/views/jobs/qr_verification_screen.dart';
import '../../presentation/views/maps/maps_screen.dart';
import '../../presentation/views/notifications/notifications_screen.dart';
import '../../presentation/views/profile/profile_screen.dart';
import '../../presentation/views/reports/report_history_screen.dart';
import '../../presentation/views/reports/service_report_form.dart';
import '../../presentation/views/settings/settings_screen.dart';
import '../../presentation/views/splash/splash_screen.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/splash';

  static final routes = [
    GetPage(name: '/splash', page: () => const SplashScreen()),
    GetPage(name: '/login', page: () => const LoginScreen()),
    GetPage(name: '/register', page: () => const RegisterScreen()),
    GetPage(name: '/forgot-password', page: () => const ForgotPasswordScreen()),
    GetPage(
      name: '/dashboard',
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: '/jobs',
      page: () => const JobListScreen(),
      binding: JobBinding(),
    ),
    GetPage(name: '/job-details', page: () => const JobDetailsScreen()),
    GetPage(name: '/qr-verify', page: () => const QrVerificationScreen()),
    GetPage(
      name: '/service-report',
      page: () => const ServiceReportFormScreen(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: '/report-history',
      page: () => const ReportHistoryScreen(),
      binding: ReportBinding(),
    ),
    GetPage(name: '/notifications', page: () => const NotificationsScreen()),
    GetPage(
      name: '/profile',
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/settings',
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: '/analytics',
      page: () => const AnalyticsScreen(),
      binding: AnalyticsBinding(),
    ),
    GetPage(
      name: '/maps',
      page: () => const MapsScreen(),
      binding: MapsBinding(),
    ),
    GetPage(
      name: '/chat',
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: '/calendar',
      page: () => const CalendarScreen(),
      binding: CalendarBinding(),
    ),
  ];
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<NotificationController>(NotificationController(), permanent: true);
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<JobController>(() => JobController());
  }
}

class JobBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobController>(() => JobController(), fenix: true);
  }
}

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(() => ReportController(), fenix: true);
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalyticsController>(() => AnalyticsController(), fenix: true);
  }
}

class MapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(() => MapController(), fenix: true);
    if (!Get.isRegistered<JobController>()) {
      Get.lazyPut<JobController>(() => JobController());
    }
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
  }
}

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(() => CalendarController(), fenix: true);
  }
}
