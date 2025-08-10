import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/app/routes/app_routes.dart';
import 'package:state_management_practice/domain/entities/user_entity.dart';
import 'package:state_management_practice/domain/usecases/auth_usecases.dart';

class AuthController extends GetxController {
  AuthController(this.authUseCases);
  final AuthUseCases authUseCases;

  bool userIsLoggedIn() {
    return _currentUser.value != null;
  }

  final Rx<UserEntity?> _currentUser = Rx<UserEntity?>(null);
  UserEntity? get currentUser => _currentUser.value;

  @override
  void onInit() {
    super.onInit();
    _currentUser.value = authUseCases.getCurrentUser();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    resetPasswordController.clear();
  }

  RxString signUpErrorMessage = "".obs;
  RxString loginErrorMessage = "".obs;
  RxString resetPasswordErrorMessage = "".obs;
  RxString deleteAccountErrorMessage = "".obs;

  String get signUpError => signUpErrorMessage.value;
  String get loginError => loginErrorMessage.value;
  String get resetPasswordError => resetPasswordErrorMessage.value;
  String get deleteAccountError => deleteAccountErrorMessage.value;

  void clearErrorMessages() {
    signUpErrorMessage.value = "";
    loginErrorMessage.value = "";
    resetPasswordErrorMessage.value = "";
    deleteAccountErrorMessage.value = "";
  }

  Future<void> signUpUser(String email, String password) async {
    try {
      clearErrorMessages();
      final UserEntity user = await authUseCases.signUp(email, password);
      _currentUser.value = user; // Update current user
      popHomeView();
    } catch (e) {
      // Catch generic Exception instead of FirebaseAuthException
      signUpErrorMessage.value = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      clearErrorMessages();
      final UserEntity user = await authUseCases.login(email, password);
      _currentUser.value = user; // Update current user
    } catch (e) {
      // Catch generic Exception instead of FirebaseAuthException
      loginErrorMessage.value = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await authUseCases.resetPassword(email);
      Get.snackbar(
        'Success',
        'Password reset email sent to $email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      resetPasswordErrorMessage.value = e.toString().replaceAll(
        'Exception: ',
        '',
      );
    }
  }

  Future<void> logout() async {
    await authUseCases.logout();
    _currentUser.value = null; // Clear current user
    clearControllers();
    clearErrorMessages();

    // Use GetX navigation instead of Navigator
    popLoginView();
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    clearErrorMessages();
    try {
      await authUseCases.changePassword(
        currentPassword,
        newPassword,
      ); //TODO: Fix the issue
    } catch (e) {
      resetPasswordErrorMessage.value = e.toString().replaceAll(
        'Exception: ',
        '',
      );
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      await authUseCases.deleteAccount(password);
    } catch (e) {
      deleteAccountErrorMessage.value = e.toString().replaceAll(
        'Exception: ',
        '',
      );
    }
  }

  // Convert your navigation methods to GetX (remove BuildContext)
  void popSignUpView() {
    clearControllers();
    clearErrorMessages();
    Get.offNamed(AppRoutes.signup);
  }

  void popLoginView() {
    clearControllers();
    clearErrorMessages();
    Get.offNamed(AppRoutes.login);
  }

  void popHomeView() {
    clearControllers();
    clearErrorMessages();
    Get.offNamed(AppRoutes.home);
  }

  void popForgotPasswordView() {
    clearControllers();
    clearErrorMessages();
    Get.offNamed(AppRoutes.forgotPassword);
  }
}
