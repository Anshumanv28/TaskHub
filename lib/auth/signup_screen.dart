import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_checkbox.dart';
import '../app/theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms & Conditions')),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    // Check if the error message indicates email confirmation is needed (success case)
    final errorMessage = authService.error ?? '';
    final isEmailConfirmationNeeded = errorMessage.toLowerCase().contains(
      'check your email to confirm',
    );

    if (success) {
      // User was automatically signed in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (isEmailConfirmationNeeded) {
      // Account created but email confirmation needed
      // Show yellow confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppTheme.buttonBgColor, // Yellow
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );

      // Redirect to login page with auto-filled credentials
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(
            initialEmail: _emailController.text.trim(),
            initialPassword: _passwordController.text,
          ),
        ),
      );
    } else {
      // Actual error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage.isNotEmpty ? errorMessage : 'Sign up failed',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _handleGoogleSignUp() async {
    // Check if terms are accepted
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Conditions to continue'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
            content: Text('Failed to sign up with Google: ${e.toString()}'),
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
                // Create your account text - left aligned, large white text
                Text(
                      'Create your account',
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
                // Full Name label
                Text(
                  'Full Name',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textDarkColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                // Full Name field
                TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: AppTheme.textWhiteColor),
                      decoration: InputDecoration(
                        hintText: 'Anshuman Mishra',
                        hintStyle: const TextStyle(
                          color: AppTheme.textDarkColor,
                        ),
                        filled: true,
                        fillColor: AppTheme.inputFieldBgColor,
                        prefixIcon: const Icon(
                          Icons.person_outline,
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
                      validator: (value) =>
                          Validators.required(value, fieldName: 'Full Name'),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                const SizedBox(height: 24),
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
                        fillColor: AppTheme.inputFieldBgColor,
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
                    .fadeIn(delay: 700.ms, duration: 400.ms)
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
                        fillColor: AppTheme.inputFieldBgColor,
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
                    .fadeIn(delay: 800.ms, duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                const SizedBox(height: 16),
                // Terms and Conditions checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: CustomCheckbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.textWhiteColor),
                          children: [
                            const TextSpan(
                              text: 'I have read & agreed to DayTask ',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppTheme.buttonBgColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // TODO: Navigate to Privacy Policy
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Privacy Policy coming soon',
                                      ),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: ', '),
                            TextSpan(
                              text: 'Terms & Condition',
                              style: TextStyle(
                                color: AppTheme.buttonBgColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // TODO: Navigate to Terms & Conditions
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Terms & Conditions coming soon',
                                      ),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
                const SizedBox(height: 32),
                // Sign Up button
                Consumer<AuthService>(
                  builder: (context, authService, _) {
                    return CustomButton(
                          text: 'Sign Up',
                          isLoading: authService.isLoading,
                          onPressed: _handleSignUp,
                        )
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 400.ms)
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
                // Google sign up button
                SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _termsAccepted ? _handleGoogleSignUp : null,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppTheme.pageBgColor,
                          side: BorderSide(
                            color: _termsAccepted
                                ? AppTheme.textWhiteColor
                                : AppTheme.textDarkColor.withOpacity(0.3),
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
                            Opacity(
                              opacity: _termsAccepted ? 1.0 : 0.5,
                              child: Image.asset(
                                'assets/images/google.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Google',
                              style: TextStyle(
                                color: _termsAccepted
                                    ? AppTheme.textWhiteColor
                                    : AppTheme.textDarkColor.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1100.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 40),
                // Log In link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textDarkColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Log In',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.buttonBgColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for animated checkmark
