import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static const String _userStorageKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // ✅ Getters for HomeScreen
  String? get userName => _currentUser?.username;
  String? get userEmail => _currentUser?.email;
  String? get profilePicUrl => _currentUser?.profilePicUrl;

  // ✅ Placeholder for email verification (since we aren't using Firebase)
  bool get isEmailVerified => true; 

  // Placeholder for email verification (since we aren't using Firebase)
  Future<void> sendVerificationEmail() async {
    // Do nothing, just keep the method so login_signup_screen doesn't crash
  }

  // Initialize auth state
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (isLoggedIn) {
        final userJson = prefs.getString(_userStorageKey);
        if (userJson != null) {
          _currentUser = User.fromJson(jsonDecode(userJson));
          _isLoggedIn = true;
        }
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error initializing auth: ${e.toString()}';
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Sign up new user
  Future<bool> signUp({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required DateTime birthday,
    required String gender,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (email.isEmpty || username.isEmpty || password.isEmpty) throw 'All fields are required';
      if (!_isValidEmail(email)) throw 'Invalid email format';
      if (password.length < 6) throw 'Password must be at least 6 characters';
      if (password != confirmPassword) throw 'Passwords do not match';
      if (username.length < 3) throw 'Username must be at least 3 characters';

      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userStorageKey);
      if (userJson != null) {
        final existingUser = User.fromJson(jsonDecode(userJson));
        if (existingUser.email == email || existingUser.username == username) {
          throw 'Email or username already registered';
        }
      }

      _currentUser = User(
        email: email,
        username: username,
        password: password,
        birthday: birthday,
        gender: gender,
      );

      await prefs.setString(_userStorageKey, jsonEncode(_currentUser!.toJson()));
      await prefs.setBool(_isLoggedInKey, true);
      _isLoggedIn = true;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login({
    required String emailOrUsername,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (emailOrUsername.isEmpty || password.isEmpty) throw 'Email/Username and password are required';

      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userStorageKey);
      if (userJson == null) throw 'No account found. Please sign up first';

      final user = User.fromJson(jsonDecode(userJson));
      if ((user.email != emailOrUsername && user.username != emailOrUsername) || user.password != password) {
        throw 'Invalid email/username or password';
      }

      _currentUser = user;
      await prefs.setBool(_isLoggedInKey, true);
      _isLoggedIn = true;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      _currentUser = null;
      _isLoggedIn = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error signing out: ${e.toString()}';
      notifyListeners();
    }
  }

  // Delete account
  Future<bool> deleteAccount({required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (_currentUser == null) throw 'No user logged in';
      if (_currentUser!.password != password) throw 'Incorrect password';

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userStorageKey);
      await prefs.remove(_isLoggedInKey);
      _currentUser = null;
      _isLoggedIn = false;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? email,
    String? username,
    DateTime? birthday,
    String? gender,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (_currentUser == null) throw 'No user logged in';
      _currentUser = _currentUser!.copyWith(
        email: email,
        username: username,
        birthday: birthday,
        gender: gender,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userStorageKey, jsonEncode(_currentUser!.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}