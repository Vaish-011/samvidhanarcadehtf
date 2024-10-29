import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Log in using Google account with existence check
  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        log("Google Sign-In aborted");
        return null; // User aborted the sign-in
      }

      final userEmail = googleUser.email;
      // Check if the email exists in Firebase
      final existingUser = await _auth.fetchSignInMethodsForEmail(userEmail);

      if (existingUser.isEmpty) {
        // If user does not exist, create a new user
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        final authResult = await _auth.signInWithCredential(credential);
        log("User created successfully: ${authResult.user?.email}");
        return authResult.user;
      } else {
        // Continue with Google sign-in process if the user exists
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        final authResult = await _auth.signInWithCredential(credential);
        return authResult.user;
      }
    } catch (e) {
      log("Google Sign-In Error: $e");
      return null; // Return null if user not found or another error occurs
    }
  }

  // Send email verification link
  Future<void> sendEmailVerificationLink() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        log("Verification email sent to ${user.email}");
      }
    } catch (e) {
      log("Failed to send verification email: ${e.toString()}");
    }
  }

  // Send password reset link
  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log("Password reset link sent to $email");
    } catch (e) {
      log("Failed to send password reset email: ${e.toString()}");
    }
  }
}
