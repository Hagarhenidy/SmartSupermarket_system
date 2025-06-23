import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:smart_supermarket/features/cart/controller/cart_controller.dart';
import 'package:smart_supermarket/features/splash/splash_screen.dart';

import 'features/auth/controller/auth_controller.dart'; 

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<CartController>(() => CartController());
  }
}

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = 'pk_test_51RFaN1LlZSSmQrVZep90Q658dOxs2golcjL6KEKFrsnclCzeWqs4mPb44NiDdcJZCcsdJ8GfzFhxA4PfJGdaAqtq00T317FVZp';

  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quick Pick',
      home: const SplashScreen(),
      initialBinding: AppBindings(), 
      debugShowCheckedModeBanner: false,
    );
  }
}