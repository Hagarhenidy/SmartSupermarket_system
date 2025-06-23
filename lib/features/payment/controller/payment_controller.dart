import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../auth/controller/auth_controller.dart';
import '../../profile/screens/receipts_screen.dart';
import '../services/payment_service.dart';

class PaymentController extends GetxController {
  final PaymentService _paymentService = PaymentService();
  final AuthController _authController = Get.find<AuthController>();

  Future<void> makePayment(BuildContext context) async {
    String? token;
    try {
      print("--- Starting Payment Process ---");
      token = await _authController.getToken();
      if (token == null) {
        throw Exception("Authentication token not found. Please log in again.");
      }
      print("Auth Token Found.");

      print("Calling backend to create Payment Intent...");
      final paymentIntentResult = await _paymentService.createPaymentIntent(authToken: token);

      print("✅ Backend Response Received: $paymentIntentResult");

    
      final clientSecret = paymentIntentResult['clientSecret'];
      final paymentId = paymentIntentResult['paymentId'];
      final requiresAction = paymentIntentResult['requiresAction'] ?? true; 
      final hasPaymentMethod = paymentIntentResult['hasPaymentMethod'] ?? false; 

      
      if (clientSecret == null || clientSecret.isEmpty) {
        throw Exception("Failed to get a valid payment secret from the server.");
      }
      if (paymentId == null || paymentId.isEmpty) {
        throw Exception("Failed to get a paymentId from the server.");
      }
      print("Client Secret and PaymentId received.");
      print("Requires Action: $requiresAction, Has Payment Method: $hasPaymentMethod");

      if (requiresAction || !hasPaymentMethod) {
        print("Payment requires user action or first-time user. Displaying payment sheet...");

        await _displayPaymentSheet(context, clientSecret);

        print("Payment sheet completed successfully. Confirming payment on backend with DB paymentId: $paymentId");
        await _paymentService.confirmPaymentOnBackend(
          authToken: token,
          paymentId: paymentId,
        );
        print("✅ Backend payment confirmed after payment sheet.");

      } else {
        print("One-click payment for returning user with saved payment method.");
        print("Confirming one-click payment on backend with DB paymentId: $paymentId");
        await _paymentService.confirmPaymentOnBackend(
          authToken: token,
          paymentId: paymentId,
        );
        print("✅ Backend payment confirmed for one-click.");
        _showSuccessDialog(context, "Payment Successful!");
      }

    } catch (e) {
      print("❌ Error in makePayment: $e");

      
      if (e is StripeException) {
        if (e.error.code != FailureCode.Canceled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Payment Failed: ${e.error.message ?? 'Please try again'}"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _displayPaymentSheet(BuildContext context, String clientSecret) async {
    try {
      print("Initializing payment sheet...");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Smart Supermarket',
          style: ThemeMode.light,
          allowsDelayedPaymentMethods: true,
        ),
      );

      print("Presenting payment sheet...");
      await Stripe.instance.presentPaymentSheet();

      print("✅ Payment sheet completed successfully!");
      _showSuccessDialog(context, "Payment Completed!");

    } on StripeException catch (e) {
      print("❌ StripeException in payment sheet: ${e.error.code} - ${e.error.message}");
      if (e.error.code != FailureCode.Canceled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Payment Failed: ${e.error.message ?? 'Please try again'}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        print("Payment was cancelled by user.");
      }

      // Re-throw to be handled by the calling method
      rethrow;
    } catch (e) {
      print("❌ Unexpected error in _displayPaymentSheet: $e");
      rethrow;
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('View My Receipts'),
            onPressed: () {
              Navigator.of(context).pop();
              Get.off(() => const ReceiptsScreen());
            },
          ),
        ],
      ),
    );
  }
}