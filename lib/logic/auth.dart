import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coderebased/logic/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
    }
    notifyListeners();
  }

  static const String _usersCollection = 'Users';
  static const String _emailDomain = '@utb.edu.bh';
  static const String _emailPrefix = 'BH';
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  User? _user;
  UserModel? _userProfile;
  String? _error;
  AuthStatus _status = AuthStatus.initial;

  AuthProvider({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _init();
  }

  User? get user => _user;
  UserModel? get userProfile => _userProfile;
  String? get error => _error;
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  void _init() {
    _auth.authStateChanges().listen(_handleAuthStateChange);
  }

  Future<void> _handleAuthStateChange(User? user) async {
    if (user == null) {
      _user = null;
      _userProfile = null;
      _status = AuthStatus.unauthenticated;
    } else {
      _user = user;
      final userData = await _firestore.collection('Users').doc(user.uid).get();
      _userProfile = userData.exists ? UserModel.fromDocument(userData) : null;
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      // Add timeout handling
      Future.delayed(const Duration(seconds: 30), () {
        if (_status == AuthStatus.loading) {
          _status = AuthStatus.error;
          _error = 'Request timed out. Please try again.';
          notifyListeners();
        }
      });
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _error = _getReadableErrorMessage(e.code);
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  bool _isValidStudentId(String studentId) {
    return RegExp(r'^\d{8}$').hasMatch(studentId);
  }

  Future<void> signUpWithEmailAndPassword(
      String studentId, String password) async {
    try {
      if (!_isValidStudentId(studentId)) {
        throw FirebaseAuthException(
          code: 'invalid-student-id',
          message: 'Please enter a valid 8-digit student ID',
        );
      }
      _status = AuthStatus.loading;
      notifyListeners();

      final email = '$_emailPrefix$studentId$_emailDomain';

      final userProfile = UserModel(
        id: studentId,
        email: email,
        studentId: studentId,
      );

      await _firestore
          .collection(_usersCollection)
          .doc(studentId)
          .set(userProfile.toMap());
    } on FirebaseAuthException catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  String _getReadableErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      default:
        return 'An error occurred. Please try again';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }
}
