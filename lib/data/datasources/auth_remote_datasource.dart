import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> saveUser(UserModel user);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<void> deleteAccount(String password);
  Future<void> deleteUser(String userId);
  Future<void> changePassword(String currentPassword, String newPassword);
  UserModel? getCurrentUser();
}

class AuthFirebaseDataSource implements AuthRemoteDataSource {
  AuthFirebaseDataSource(this._auth, this._firestore);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw Exception('No user logged in');
    }

    try {
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(user.toJson());
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    final User? user = _auth.currentUser;
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
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final User? user = _auth.currentUser;
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
    final User? user = _auth.currentUser;
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
