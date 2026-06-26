
class AppConstants {
  AppConstants._();

  
  static const String appName        = 'ServiceSync';
  static const String appVersion     = '1.0.0';
  static const String appBuildNumber = '100';
  static const String appTagline     = 'Field Service Management';

  
  
  static const bool useMockBackend = true;

  
  static const String supabaseUrl     = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';

  
  static const String dbName    = 'service_sync.db';
  static const int    dbVersion = 1;

  
  static const String keyThemeMode    = 'theme_mode';
  static const String keyAuthToken    = 'auth_token';
  static const String keyUserId       = 'user_id';
  static const String keyUserRole     = 'user_role';
  static const String keyOnboarded    = 'onboarded';

  
  
  
  static const String splashRoute           = '/';
  static const String loginRoute            = '/login';
  static const String registerRoute         = '/register';
  static const String forgotPasswordRoute   = '/forgot-password';
  static const String dashboardRoute        = '/dashboard';
  static const String jobListRoute          = '/jobs';
  static const String jobDetailRoute        = '/jobs/detail';
  static const String customerDetailRoute   = '/customers/detail';
  static const String reportFormRoute       = '/reports/form';
  static const String reportHistoryRoute    = '/reports/history';
  static const String notificationsRoute    = '/notifications';
  static const String profileRoute          = '/profile';
  static const String settingsRoute         = '/settings';
  static const String analyticsRoute        = '/analytics';
  static const String qrVerificationRoute   = '/qr-verification';
  static const String mapsRoute             = '/maps';
  static const String galleryRoute          = '/gallery';
  static const String chatRoute             = '/chat';
  static const String calendarRoute         = '/calendar';

  
  
  
  static const String statusPending    = 'pending';
  static const String statusAccepted   = 'accepted';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted  = 'completed';
  static const String statusRejected   = 'rejected';
  static const String statusCancelled  = 'cancelled';
  static const String statusOnHold     = 'on_hold';

  
  static const List<String> allStatuses = [
    statusPending,
    statusAccepted,
    statusInProgress,
    statusCompleted,
    statusRejected,
    statusCancelled,
    statusOnHold,
  ];

  
  
  
  static const String priorityLow       = 'low';
  static const String priorityMedium    = 'medium';
  static const String priorityHigh      = 'high';
  static const String priorityEmergency = 'emergency';

  static const List<String> allPriorities = [
    priorityLow,
    priorityMedium,
    priorityHigh,
    priorityEmergency,
  ];

  
  
  
  static const String roleAdmin      = 'admin';
  static const String roleTechnician = 'technician';
  static const String roleCustomer   = 'customer';
  static const String roleManager    = 'manager';

  
  
  
  static const String notifJobAssigned   = 'job_assigned';
  static const String notifJobUpdated    = 'job_updated';
  static const String notifJobCompleted  = 'job_completed';
  static const String notifJobRejected   = 'job_rejected';
  static const String notifNewMessage    = 'new_message';
  static const String notifNewReport    = 'new_report';
  static const String notifReminder      = 'reminder';
  static const String notifEmergency     = 'emergency';
  static const String notifSystem        = 'system';
  static const String notifPromotion     = 'promotion';

  
  
  
  static const String reportTypeService     = 'service';
  static const String reportTypeMaintenance = 'maintenance';
  static const String reportTypeInspection  = 'inspection';
  static const String reportTypeIncident    = 'incident';

  
  
  
  static const int pageSize         = 20;
  static const int maxUploadImages  = 10;
  static const int maxFileSizeMb    = 10;

  
  
  
  static const String dateFormat     = 'MMM dd, yyyy';
  static const String timeFormat     = 'hh:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy • hh:mm a';
  static const String apiDateFormat  = 'yyyy-MM-dd';

  
  
  
  static const int minPasswordLength = 8;
  static const int maxNameLength     = 100;
  static const int maxNoteLength     = 1000;
  static const int maxDescLength     = 2000;

  
  
  
  static const Duration animFast    = Duration(milliseconds: 200);
  static const Duration animNormal  = Duration(milliseconds: 350);
  static const Duration animSlow    = Duration(milliseconds: 600);
  static const Duration animSplash  = Duration(seconds: 2);

  
  
  
  static const String mockTechnicianId = 'tech_demo_001';
  static const String mockCustomerId   = 'cust_demo_001';
  static const String mockAdminId      = 'admin_demo_001';
}
