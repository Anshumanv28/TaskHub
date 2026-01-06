import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../auth/auth_service.dart';
import '../auth/signup_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../app/theme.dart';

class LoginScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;

  const LoginScreen({super.key, this.initialEmail, this.initialPassword});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _passwordController = TextEditingController(
      text: widget.initialPassword ?? '',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      final errorMessage = authService.error ?? 'Login failed';
      // Check if the error is about email not being confirmed
      final isEmailNotConfirmed =
          errorMessage.toLowerCase().contains('email not confirmed') ||
          errorMessage.toLowerCase().contains('email_not_confirmed');

      // Check if the error is about invalid credentials
      final isInvalidCredentials =
          errorMessage.toLowerCase().contains('invalid email or password') ||
          (errorMessage.toLowerCase().contains('invalid') &&
              (errorMessage.toLowerCase().contains('password') ||
                  errorMessage.toLowerCase().contains('credentials')));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEmailNotConfirmed
                ? 'Please check your email to confirm your account before signing in.'
                : isInvalidCredentials
                ? 'User not registered. Sign up first.'
                : errorMessage,
          ),
          backgroundColor: isEmailNotConfirmed
              ? AppTheme
                    .buttonBgColor // Yellow
              : Theme.of(context).colorScheme.error, // Red for other errors
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: isEmailNotConfirmed ? 4 : 3),
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final success = await authService.signInWithGoogle();

      if (!mounted) return;

      // If OAuth started successfully, navigation will be handled by the global auth listener
      // Only show error if there was an actual error (not user cancellation or success)
      if (!success && authService.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authService.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      // If success or user cancelled, no need to show anything - navigation handled elsewhere
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in with Google: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo centered at top
                Center(
                  child:
                      Image.asset(
                            'assets/images/icon_with_text.png',
                            height: 80,
                            fit: BoxFit.contain,
                          )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(delay: 200.ms, duration: 600.ms),
                ),
                const SizedBox(height: 32),
                // Welcome Back! text - left aligned, large white text
                Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: AppTheme.textWhiteColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.left,
                    )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
                // Email Address label
                Text(
                  'Email Address',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textDarkColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                // Email field
                TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppTheme.textWhiteColor),
                      decoration: InputDecoration(
                        hintText: 'anshumanmishra.v.2.8@gmail.com',
                        hintStyle: const TextStyle(
                          color: AppTheme.textDarkColor,
                        ),
                        filled: true,
                        fillColor: AppTheme
                            .inputFieldBgColor, // 455A64 - dark blue-gray
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppTheme.textWhiteColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero, // Square corners
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: AppTheme.buttonBgColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: Validators.email,
                    )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                const SizedBox(height: 24),
                // Password label
                Text(
                  'Password',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textDarkColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                // Password field
                TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: AppTheme.textWhiteColor),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(
                          color: AppTheme.textDarkColor,
                        ),
                        filled: true,
                        fillColor: AppTheme
                            .inputFieldBgColor, // 455A64 - dark blue-gray
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppTheme.textWhiteColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppTheme.textWhiteColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero, // Square corners
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: AppTheme.buttonBgColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: Validators.password,
                    )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                // const SizedBox(height: 2),
                // Forgot Password? - right aligned
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Forgot password coming soon'),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textDarkColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Log In button
                Consumer<AuthService>(
                  builder: (context, authService, _) {
                    return CustomButton(
                          text: 'Log In',
                          isLoading: authService.isLoading,
                          onPressed: _handleLogin,
                        )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 400.ms)
                        .slideY(begin: 0.2, end: 0);
                  },
                ),
                const SizedBox(height: 32),
                // Or continue with separator
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppTheme.textDarkColor.withOpacity(0.3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textDarkColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppTheme.textDarkColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Google login button
                SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _handleGoogleLogin,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppTheme.pageBgColor,
                          side: const BorderSide(
                            color: AppTheme.textWhiteColor,
                            width: 1,
                          ),
                          shape:
                              const RoundedRectangleBorder(), // Square corners
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google logo
                            Image.asset(
                              'assets/images/google.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Google',
                              style: TextStyle(
                                color: AppTheme.textWhiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 900.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 40),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textDarkColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.buttonBgColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
