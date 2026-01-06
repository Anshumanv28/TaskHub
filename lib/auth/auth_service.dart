import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthService extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated {
    // Check both local state and Supabase session
    final supabaseUser = _supabaseService.currentUser;
    return _currentUser != null && supabaseUser != null;
  }

  AuthService() {
    _currentUser = _supabaseService.currentUser;
    _supabaseService.authStateChanges.listen((AuthState state) {
      _currentUser = state.session?.user;
      notifyListeners();
    });
  }

  Future<bool> signUp({required String email, required String password}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabaseService.signUp(
        email: email,
        password: password,
      );

      // Check if user was created
      if (response.user != null) {
        // If session exists, user is automatically logged in
        if (response.session != null) {
          _currentUser = response.user;
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          // No session means email confirmation might be required
          // Try to sign in automatically after signup
          try {
            final signInResponse = await _supabaseService.signIn(
              email: email,
              password: password,
            );

            if (signInResponse.session != null) {
              _currentUser = signInResponse.user;
              _isLoading = false;
              notifyListeners();
              return true;
            } else {
              _error =
                  'Account created. Please check your email to confirm your account.';
              _isLoading = false;
              notifyListeners();
              return false;
            }
          } catch (signInError) {
            // If auto sign-in fails, user might need to confirm email
            _error =
                'Account created. Please check your email to confirm your account.';
            _isLoading = false;
            notifyListeners();
            return false;
          }
        }
      } else {
        _error = 'Failed to create account';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      // Check if we have both user and session
      if (response.user != null && response.session != null) {
        _currentUser = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _supabaseService.signInWithGoogle();
      
      if (success) {
        // Wait a bit for the OAuth flow to complete
        // The auth state listener will update _currentUser
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to sign in with Google';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabaseService.signOut();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
