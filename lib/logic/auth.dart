import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'etc/app_strings.dart';
import 'etc/logger.dart';
import 'usermodel.dart';
//import '../models/user.dart';
//import '../constants/app_strings.dart';
//import '../utils/logger.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

// Provider
final authProvider = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});

class AuthService extends ChangeNotifier {
  static const String _usersCollection = AppStrings.usersCollection;

  // Firebase instances
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // State variables
  User? _user;
  UserModel? _userProfile;
  String? _error;
  AuthStatus _status = AuthStatus.initial;
  Timer? _authTimeout;

  // Constructor
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _init();
  }

  // Getters
  User? get user => _user;
  UserModel? get userProfile => _userProfile;
  String? get error => _error;
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Initialize auth state listener
  void _init() {
    _auth.authStateChanges().listen(_handleAuthStateChange);
  }

  // Utility methods
  String _convertToEmail(String studentId) {
    if (!_isValidStudentId(studentId)) {
      throw const FormatException(AppStrings.invalidStudentIdMessage);
    }
    return '${AppStrings.emailPrefix}$studentId${AppStrings.emailDomain}';
  }

  bool _isValidStudentId(String studentId) {
    return RegExp(AppStrings.studentIdPattern).hasMatch(studentId);
  }

  void _startAuthTimeout() {
    _authTimeout?.cancel();
    _authTimeout = Timer(
      const Duration(seconds: AppStrings.authTimeoutSeconds),
      () {
        if (_status == AuthStatus.loading) {
          _status = AuthStatus.error;
          _error = AppStrings.authTimeoutMessage;
          notifyListeners();
        }
      },
    );
  }

  void _clearAuthTimeout() {
    _authTimeout?.cancel();
    _authTimeout = null;
  }

  // Profile management
  Future<UserModel?> _fetchUserProfile(String userId) async {
    try {
      final userData =
          await _firestore.collection(_usersCollection).doc(userId).get();

      if (!userData.exists) {
        Logger.warn('User profile not found for ID: $userId');
        return null;
      }

      _userProfile = UserModel.fromDocument(userData);
      return _userProfile;
    } catch (e) {
      _error = 'Failed to fetch user profile: $e';
      Logger.error(_error!);
      return null;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user is currently signed in.',
        );
      }

      final updateData = {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .update(updateData);

      // Update local user profile
      if (_userProfile != null) {
        _userProfile = _userProfile!.copyWith(
          profileImageUrl: data['profileImageUrl'] as String?,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _error = _getReadableErrorMessage(
          e is FirebaseAuthException ? e.code : 'unknown');
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  // Auth state management
  Future<void> _handleAuthStateChange(User? user) async {
    if (user == null) {
      _user = null;
      _userProfile = null;
      _status = AuthStatus.unauthenticated;
    } else {
      _user = user;
      _userProfile = await _fetchUserProfile(user.uid);
      _status =
          _userProfile != null ? AuthStatus.authenticated : AuthStatus.error;
    }
    notifyListeners();
  }

  // Authentication methods
  Future<void> signInWithStudentId(String studentId, String password) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      _startAuthTimeout();

      if (!_isValidStudentId(studentId)) {
        throw FirebaseAuthException(
          code: 'invalid-student-id',
          message: AppStrings.invalidStudentIdMessage,
        );
      }

      final email = _convertToEmail(studentId);

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _clearAuthTimeout();
    } on FirebaseAuthException catch (e) {
      _error = _getReadableErrorMessage(e.code);
      _status = AuthStatus.error;
      Logger.error('Auth Error: ${e.code} - $_error');
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = AppStrings.genericError;
      _status = AuthStatus.error;
      Logger.error('Unexpected auth error: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUpWithStudentId({
    required String studentId,
    required String password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    required Map<String, String?> userData,
  }) async {
    try {
      if (!_isValidStudentId(studentId)) {
        throw FirebaseAuthException(
          code: 'invalid-student-id',
          message: AppStrings.invalidStudentIdMessage,
        );
      }

      _status = AuthStatus.loading;
      notifyListeners();

      final email = _convertToEmail(studentId);

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userProfile = UserModel(
          id: userCredential.user!.uid,
          email: email,
          studentId: studentId,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Add additional data from userData map
        final Map<String, dynamic> profileData = {
          ...userProfile.toMap(),
          ...userData,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await _firestore
            .collection(_usersCollection)
            .doc(userCredential.user!.uid)
            .set(profileData);

        _userProfile = userProfile;
        _status = AuthStatus.authenticated;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      _error = _getReadableErrorMessage(e.code);
      _status = AuthStatus.error;
      Logger.error('Signup Error: ${e.code} - $_error');
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = AppStrings.genericError;
      _status = AuthStatus.error;
      Logger.error('Unexpected signup error: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resetPasswordWithStudentId(String studentId) async {
    try {
      if (!_isValidStudentId(studentId)) {
        throw FirebaseAuthException(
          code: 'invalid-student-id',
          message: AppStrings.invalidStudentIdMessage,
        );
      }

      final email = _convertToEmail(studentId);
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _error = _getReadableErrorMessage(e.code);
      _status = AuthStatus.error;
      Logger.error('Password reset error: ${e.code} - $_error');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _clearAuthTimeout();
    } catch (e) {
      _error = AppStrings.signOutError;
      _status = AuthStatus.error;
      Logger.error('Sign out error: $e');
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  String _getReadableErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return AppStrings.userNotFoundError;
      case 'wrong-password':
        return AppStrings.wrongPasswordError;
      case 'invalid-student-id':
        return AppStrings.invalidStudentIdError;
      case 'email-already-in-use':
        return AppStrings.emailInUseError;
      case 'weak-password':
        return AppStrings.weakPasswordError;
      case 'too-many-requests':
        return AppStrings.tooManyRequestsError;
      default:
        return AppStrings.genericError;
    }
  }

  // Status check
  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _fetchUserProfile(user.uid);
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      Logger.error('Auth status check error: $e');
    }
    notifyListeners();
  }
}
