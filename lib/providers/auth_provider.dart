import 'package:bitespot/models/user_model.dart';
import 'package:bitespot/services/firebase_auth_service.dart';
import 'package:bitespot/services/firebase_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  initial,
  verificationProcess,
  unverifiedEmail,
  accountCreated,
  loggedIn,
  logout,
  resetPassword,
  failure,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  AuthStatus status = AuthStatus.initial;
  UserModel? userData;
  String? error;

  Future<bool> authCheck() async {
    final response = await _authService.authCheck();
    return response;
  }

  // sign up and send verification email
  Future signUp(String email, String password) async {
    final response = await _authService.signUp(email, password);
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (UserCredential userCredential) async {
        final User firebaseUser = userCredential.user!;
        final UserModel userModel = UserModel(
          id: firebaseUser.uid,
          fullName: firebaseUser.displayName,
          email: firebaseUser.email!,
          signInMethod: userCredential.credential?.signInMethod,
        );
        userData = userModel;
        status = AuthStatus.verificationProcess;
      },
    );
    notifyListeners();
  }

  // send verification email link if it hasnt been send to user
  Future sendEmailVerificationLink() async {
    final response = await _authService.sendEmailVerificationLink();
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (_) {
        status = AuthStatus.verificationProcess;
      },
    );
    notifyListeners();
  }

  // store data to firebase database
  Future storeUserData() async {
    final response = await _firestoreService.storeUserData(userData!);
    response.fold((String errorMessage) {
      error = errorMessage;
      status = AuthStatus.failure;
      notifyListeners();
    }, (_) {});
  }

  Future getUserData() async {
    final response = await _firestoreService.getUserData();
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
        notifyListeners();
      },
      (UserModel userModel) {
        userData = userModel;
      },
    );
  }

  // sign in
  Future signIn(String email, String password) async {
    final response = await _authService.signIn(email, password);
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (User? user) {
        if (user != null) {
          if (user.emailVerified) {
            // userData = user;
            status = AuthStatus.loggedIn;
          } else {
            status = AuthStatus.unverifiedEmail;
          }
        } else {
          status = AuthStatus.failure;
        }
      },
    );
    notifyListeners();
  }

  // google sign in
  Future googleSignIn() async {
    final response = await _authService.googleSignIn();
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (_) {
        status = AuthStatus.loggedIn;
      },
    );
  }

  // apple sign in
  Future appleSignIn() async {
    final response = await _authService.appleSignIn();
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (User? user) {
        status = AuthStatus.loggedIn;
      },
    );
    notifyListeners();
  }

  // send password reset mail
  Future sendPasswordResetLink(String email) async {
    final response = await _authService.sendPasswordResetLink(email);
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (_) {
        status = AuthStatus.resetPassword;
      },
    );
    notifyListeners();
  }

  // sing out
  Future signOut() async {
    final response = await _authService.signOut();
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (_) {
        status = AuthStatus.logout;
      },
    );
    notifyListeners();
  }
}
