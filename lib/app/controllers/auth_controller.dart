import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../data/services/storage_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storageService = Get.find<StorageService>();

  final _isLoading = false.obs;
  final _user = Rxn<User>();

  bool get isLoading => _isLoading.value;
  User? get user => _user.value;
  bool get isLoggedIn => _user.value != null;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  Future<void> register(String email, String password, String name) async {
    try {
      _isLoading.value = true;
      
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await credential.user?.updateDisplayName(name);
      
      // Navigate to HOME page after successful registration
      Get.offAllNamed(AppRoutes.HOME);
      Get.snackbar(
        'Success',
        'Account created successfully! Welcome to Newsly!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        _getErrorMessage(e.code),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading.value = true;
      
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Navigate to HOME page after successful login
      Get.offAllNamed(AppRoutes.HOME);
      Get.snackbar(
        'Success',
        'Welcome back to Newsly!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        _getErrorMessage(e.code),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading.value = true;
      
      await _auth.sendPasswordResetEmail(email: email);
      
      Get.back();
      Get.snackbar(
        'Success',
        'Password reset email sent!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        _getErrorMessage(e.code),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _storageService.clearUserData();
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
