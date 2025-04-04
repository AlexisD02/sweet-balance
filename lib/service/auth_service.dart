import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Handles user login via email and password when the user tries to login using
  // his email and password creds
  Future<(User?, String?)> handleEmailLogin({
    required String email,
    required String password,
  }) async {
    try {
      final userSignInCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      log("Email login successful", name: "AuthService");

      return (userSignInCredential.user, null);
    } on FirebaseAuthException catch (e) {
      // In case of the firebase issues caused return error message as snackbar message
      log("FirebaseAuthException during email login", error: e, name: "AuthService");
      return (null, AuthException.messageForCode(e.code));
    } on Exception catch (e) {
      // In case of error to login in return message for error info as snackbar message
      log("Unexpected exception during email login", error: e, name: "AuthService");
      return (null, 'An unexpected error occurred during login.');
    }
  }

  /// Handles Google Sign-In using Firebase and GoogleSignIn plugin
  /// If user cancels, returns null with error message
  Future<(User?, String?)> handleGoogleLogin() async {
    try {
      final GoogleSignInAccount? userAccount = await _googleSignIn.signIn();

      // Check if the user exits the google sign-in flow
      if (userAccount == null) {
        log("Google sign-in cancelled by user", name: "AuthService");
        return (null, 'Google sign-in was cancelled.');
      }

      final googleAuth = await userAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      log("Google sign-in successful", name: "AuthService");

      return (userCredential.user, null);
    } on FirebaseAuthException catch (e) {
      // In case of the firebase issues return error message as snackbar message
      log("FirebaseAuthException during Google sign-in", error: e, name: "AuthService");
      return (null, AuthException.messageForCode(e.code));
    } on Exception catch (e) {
      // In case of error return google message for error info as snackbar message
      log("Google sign-in failed unexpectedly", error: e, name: "AuthService");
      return (null, 'Google sign-in failed. Please try again later.');
    }
  }

  // Throw custom exception on failure
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Convert Firebase errors to custom AuthException
      log("Email sign-in failed", error: e, name: "AuthService");
      throw AuthException(errorAuthCode: e.code);
    } catch (e) {
      log("Unknown error during email sign-in", error: e, name: "AuthService");
      throw AuthException(errorAuthCode: 'unknown');
    }
  }

  // Google sign-in method
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      log("Google sign-in error", error: e, name: "AuthService");
      throw AuthException(errorAuthCode: 'google-failed');
    }
  }

  // Signs out user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      log("User signed out", name: "AuthService");
    } catch (e) {
      log("Error during sign-out", error: e, name: "AuthService");
    }
  }

  // Returns the current logged-in user
  User? getCurrentUser() => _firebaseAuth.currentUser;
}

class AuthException implements Exception {
  final String errorAuthCode;

  AuthException({required this.errorAuthCode});

  // Map error codes to user-friendly messages
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
    case 'email-already-in-use':
      return 'This email is already registered.';
    case 'operation-not-allowed':
      return 'This sign-in method is not allowed.';
    case 'google-failed':
      return 'Google sign-in failed.';
    default:
      return 'Login failed. Please try again.';
    }
  }

  // Get the error message for exception instance
  String get message => messageForCode(errorAuthCode);

  @override
  String toString() => message;
}