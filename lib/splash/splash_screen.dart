import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/theme.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../widgets/custom_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _handleGetStarted() {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (authService.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.pageBgColor, // 212832 - page background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Logo with text (top left)
                Align(
                  alignment: Alignment.topLeft,
                  child:
                      Image.asset(
                            'assets/images/icon_with_text.png',
                            height: 60,
                            fit: BoxFit.contain,
                          )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(delay: 200.ms, duration: 600.ms),
                ),
                const SizedBox(height: 40),
                // Splash Illustration
                Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppTheme
                            .textWhiteColor, // White background for illustration
                        // No border radius - square corners
                      ),
                      child: Image.asset(
                        'assets/images/splash_image.png',
                        fit: BoxFit.contain,
                        height: screenHeight * 0.25,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 800.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 40),
                // Main Text - Multi-line as per Figma, left-aligned, stretched to right
                Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        textWidthBasis: TextWidthBasis.longestLine,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: AppTheme.textWhiteColor,
                                fontFamily: 'PilatExtended',
                                fontWeight: FontWeight.w600,
                                fontSize: 55,
                                letterSpacing:
                                    2.0, // Stretch text horizontally more
                                height:
                                    1.0, // Reduce vertical spacing between lines
                              ),
                          children: [
                            const TextSpan(text: 'Manage\n'),
                            const TextSpan(text: 'your\n'),
                            const TextSpan(text: 'Task with\n'),
                            TextSpan(
                              text: 'DayTask',
                              style: TextStyle(
                                color: AppTheme
                                    .buttonBgColor, // FED36A - button bg / app yellow
                                fontFamily: 'PilatExtended',
                                fontWeight: FontWeight.bold,
                                fontSize: 55,
                                letterSpacing: 2.0, // More spacing for DayTask
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 60),
                // Let's Start Button
                CustomButton(
                      text: "Let's Start",
                      backgroundColor: AppTheme
                          .buttonBgColor, // FED36A - button bg / app yellow
                      textColor: AppTheme.textBlackColor, // 000000 - black text
                      onPressed: _handleGetStarted,
                    )
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
