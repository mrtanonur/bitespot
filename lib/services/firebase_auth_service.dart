import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> authCheck() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        return true;
      }
      return false;
    }
    return false;
  }

  //sign up
  Future<Either<String, UserCredential>> signUp(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return Right(userCredential);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  // Send email verification link
  Future<Either<String, void>> sendEmailVerificationLink() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return const Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  //sign in with email and password
  Future<Either<String, User>> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return Right(userCredential.user!);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  //google sign in
  Future<Either<String, void>> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount? googleUser = await googleSignIn
          .attemptLightweightAuthentication();

      googleUser ?? await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

      final userCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(userCredential);

      return const Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  // apple sign in
  Future<Either<String, User?>> appleSignIn() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        oAuthCredential,
      );
      return Right(userCredential.user);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  // Send password reset email
  Future<Either<String, void>> sendPasswordResetLink(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  //log out
  Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }
}
