import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_supermarket/features/profile/model/receipt_model.dart';
import 'package:smart_supermarket/features/profile/screens/receipt_details_screen.dart';
import '../controller/profile_controller.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Receipts"),
        backgroundColor: const Color(0xFF5E8941),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.receipts.isEmpty) {
          return const Center(child: Text("You have no receipts yet."));
        }
        return ListView.builder(
          itemCount: controller.receipts.length,
          itemBuilder: (context, index) {
            final receipt = controller.receipts[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  "Order on ${DateFormat.yMMMd().format(receipt.paidAt)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "Total: \$${receipt.totalAmount.toStringAsFixed(2)}"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(() => ReceiptDetailsScreen(receipt: receipt));
                },
              ),
            );
          },
        );
      }),
    );
  }
}