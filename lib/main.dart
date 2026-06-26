import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/mock_data.dart';
import 'data/datasources/local/sqlite_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://luarnplpasntykekvket.supabase.co',
    anonKey: 'sb_publishable_ju76d6cOQoNcXKI6kujW1w_HOxUB5Ay',
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0E27),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await SQLiteHelper.instance.database;
  final count = await SQLiteHelper.instance.rowCount('service_requests');
  if (count == 0) {
    final mockSource = MockDataSource();
    await mockSource.seedDatabase(SQLiteHelper.instance);
  }

  runApp(const ServiceSyncApp());
}

class ServiceSyncApp extends StatelessWidget {
  const ServiceSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ServiceSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialBinding: AppBindings(),
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: (context, child) {
        return DefaultTextStyle(
          style: GoogleFonts.outfit(color: Colors.white),
          child: child!,
        );
      },
    );
  }
}
