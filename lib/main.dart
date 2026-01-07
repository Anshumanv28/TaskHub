import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme.dart';
import 'app/theme_provider.dart';
import 'auth/auth_service.dart';
import 'dashboard/task_provider.dart';
import 'services/supabase_service.dart';
import 'splash/splash_screen.dart';
import 'dashboard/dashboard_screen.dart';

// Global navigator key for navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseService.initialize(
    url: 'https://nqubzvzrsjkoleuxecnt.supabase.co',
    anonKey: 'sb_publishable_Khb-vfvYMwWjyKIkW3EzUg_tvgZv0Xz',
  );

  // Listen for OAuth callbacks and navigate when sign-in completes
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;
    final Session? session = data.session;

    if (event == AuthChangeEvent.signedIn && session != null) {
      // User successfully signed in via OAuth
      debugPrint('OAuth sign-in successful');

      // Navigate to dashboard immediately when OAuth completes
      // This prevents returning to login/signup screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final navigator = navigatorKey.currentState;
        if (navigator != null) {
          // Always replace the entire navigation stack with dashboard
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (route) => false,
          );
        }
      });
    }
  });

  runApp(const TaskHubApp());
}

class TaskHubApp extends StatelessWidget {
  const TaskHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'TaskHub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
