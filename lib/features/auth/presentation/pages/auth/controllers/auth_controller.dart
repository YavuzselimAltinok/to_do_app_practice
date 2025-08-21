import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/app/routes/app_routes.dart';
import 'package:state_management_practice/features/auth/domain/entities/user_entity.dart';
import 'package:state_management_practice/features/auth/domain/usecases/auth_usecases.dart';

class AuthController extends GetxController {
  // TODO: Use private variables when necessary
  AuthController(this.authUseCases);
  final AuthUseCases authUseCases;

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  @override
  void onInit() {
    super.onInit();
    _currentUser = authUseCases.getCurrentUser();
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

  Future<void> signUpUser() async {
    try {
      clearErrorMessages();
      final UserEntity user = await authUseCases.signUp(
        emailController.text,
        passwordController.text,
      );
      _currentUser = user; // Update current user
      popHomeView();
    } catch (e) {
      signUpErrorMessage.value = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> loginUser() async {
    try {
      clearErrorMessages();
      final UserEntity user = await authUseCases.login(
        emailController.text,
        passwordController.text,
      );
      _currentUser = user; // Update current user
      popHomeView(); // Navigate to home after successful login
    } catch (e) {
      loginErrorMessage.value = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> resetPassword() async {
    //TODO: Change methods' names according to their functionality in UI
    try {
      await authUseCases.resetPassword(emailController.text);
      popLoginView();
      Get.snackbar(
        'Success',
        'Password reset email sent to ${emailController.text}',
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
    _currentUser = null; // Clear current user
    clearControllers();
    clearErrorMessages();
    popLoginView();
  }

  Future<void> changePassword() async {
    clearErrorMessages();
    try {
      await authUseCases.changePassword(
        passwordController.text,
        resetPasswordController.text,
      );
      if (resetPasswordErrorMessage.isEmpty) {
        Get.back();
        Get.snackbar(
          'Success',
          'Password changed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      resetPasswordErrorMessage.value = e.toString().replaceAll(
        'Exception: ',
        '',
      );
    }
  }

  Future<void> deleteAccount() async {
    clearErrorMessages();
    try {
      await authUseCases.deleteAccount(passwordController.text);
      if (deleteAccountErrorMessage.isEmpty) {
        Get.back();
        await logout();
        Get.snackbar(
          'Success',
          'Account deleted successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      deleteAccountErrorMessage.value = e.toString().replaceAll(
        'Exception: ',
        '',
      );
    }
  }

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
