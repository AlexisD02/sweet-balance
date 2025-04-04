import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<(User?, String?)> handleEmailLogin({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("Email login successful");

      return (credential.user, null);
    } on FirebaseAuthException catch (e) {
      return (null, AuthException.messageForCode(e.code));
    } catch (_) {
      return (null, 'An unexpected error occurred.');
    }
  }

  Future<(User?, String?)> handleGoogleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return (null, 'Google sign-in was cancelled.');

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      log("Google sign in successful");

      return (userCredential.user, null);
    } catch (_) {
      return (null, 'Google sign-in failed.');
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code);
    } catch (_) {
      throw AuthException(code: 'unknown');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (_) {
      throw AuthException(code: 'google-failed');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  User? getCurrentUser() => _auth.currentUser;
}

class AuthException implements Exception {
  final String code;

  AuthException({required this.code});

  static String messageForCode(String code) {
    switch (code) {
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'google-failed':
        return 'Google sign-in failed.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  String get message => messageForCode(code);

  @override
  String toString() => message;
}
