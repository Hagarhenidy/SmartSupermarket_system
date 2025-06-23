import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controller/auth_controller.dart';
import '../model/receipt_model.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  final AuthController _authController = Get.find<AuthController>();

  var isLoading = false.obs;
  var receipts = <ReceiptModel>[].obs;

  

  @override
  void onInit() {
    super.onInit();
    fetchReceipts();
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      isLoading.value = true;
      final token = await _authController.getToken();
      if (token == null) throw Exception("Not Authenticated");

      await _profileService.updateUserProfile(
          token: token, name: name, email: email, phone: phone);

      await _authController.updateLocalUser(name: name, email: email, phone: phone);

      Get.back();
      Get.snackbar("Success", "Profile updated successfully!", backgroundColor: const Color(0xFF5E8941), colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReceipts({int retries = 2}) async {
    try {
      if (retries == 2) isLoading.value = true;

      final token = await _authController.getToken();
      if (token == null) throw Exception("Not Authenticated");

      final Map<String, dynamic> response = await _profileService.getAllReceipts(token: token);

      if (response['data'] != null) {
        final List<dynamic> receiptsData = response['data'];
        receipts.value = receiptsData.map((data) => ReceiptModel.fromJson(data)).toList();
      } else {
        receipts.value = [];
      }

      isLoading.value = false;
    } catch (e) {
      if (retries > 0) {
        await Future.delayed(const Duration(seconds: 1));
        await fetchReceipts(retries: retries - 1);
      } else {
        print("Failed to fetch receipts after multiple attempts: $e");
        Get.snackbar("Error", "Could not load receipts.");
        isLoading.value = false;
      }
    }
  }
}