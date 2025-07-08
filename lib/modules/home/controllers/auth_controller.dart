import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:state_management_practice/core/services/auth_service.dart';
import 'package:state_management_practice/modules/home/views/forgot_password_view.dart';
import 'package:state_management_practice/modules/home/views/home_view.dart';
import 'package:state_management_practice/modules/home/views/login_view.dart';
import 'package:state_management_practice/modules/home/views/signup_view.dart';

class AuthController extends ChangeNotifier {
  AuthController._();
  static final AuthController instance = AuthController._();

  bool userIsLoggedIn() {
    return AuthService.instance.currentUser != null;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    resetPasswordController.clear();
  }

  String signUpErrorMessage = "";
  String loginErrorMessage = "";
  String resetPasswordErrorMessage = "";
  String deleteAccountErrorMessage = "";

  void clearErrorMessages() {
    signUpErrorMessage = "";
    loginErrorMessage = "";
    resetPasswordErrorMessage = "";
    deleteAccountErrorMessage = "";
  }

  Future<void> signUpUser(String email, String password) async {
    try {
      await AuthService.instance.signUp(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      signUpErrorMessage = e.message ?? "An error occurred during sign up.";
      notifyListeners();
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await AuthService.instance.login(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      loginErrorMessage = e.message ?? "An error occurred during login.";
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await AuthService.instance.resetPassword(email);
    } on FirebaseAuthException catch (e) {
      loginErrorMessage =
          e.message ?? "An error occurred during password reset.";
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await AuthService.instance.signOut();
    popLoginView(context);
  }

  Future<void> resetPasswordFromCurrentPassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await AuthService.instance.resetPasswordFromCurrentPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      resetPasswordErrorMessage =
          e.message ?? "An error occurred during password reset.";
      notifyListeners();
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      await AuthService.instance.deleteAccount(
        email: AuthService.instance.currentUser?.email ?? "",
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      deleteAccountErrorMessage =
          e.message ?? "An error occurred during account deletion.";
      notifyListeners();
    }
  }

  void popSignUpView(BuildContext context) {
    clearControllers();
    clearErrorMessages();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const SignUpView()),
    );
  }

  void popLoginView(BuildContext context) {
    clearControllers();
    clearErrorMessages();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginView()),
    );
  }

  void popHomeView(BuildContext context) {
    clearControllers();
    clearErrorMessages();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const HomeView()),
    );
  }

  void popForgotPasswordView(BuildContext context) {
    clearControllers();
    clearErrorMessages();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ForgotPasswordView(),
      ),
    );
  }
}
