import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<void> deleteAccount(String password);
  Future<void> changePassword(String currentPassword, String newPassword);
  UserModel? getCurrentUser();
}

class AuthFirebaseDataSource implements AuthRemoteDataSource {
  AuthFirebaseDataSource(this.firebaseAuth);
  final FirebaseAuth firebaseAuth;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final UserCredential credential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      final UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    final User? user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final User? user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  @override
  UserModel? getCurrentUser() {
    final User? user = firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return e.message ?? 'An error occurred.';
    }
  }
}
