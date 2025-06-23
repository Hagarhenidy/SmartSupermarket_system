import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter_new/qr_flutter.dart';
import 'package:smart_supermarket/features/profile/model/receipt_model.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  final ReceiptModel receipt;

  const ReceiptDetailsScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    
    final date = receipt.paidAt;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Details"),
        backgroundColor: const Color(0xFF5E8941),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (receipt.qrCode != null && receipt.qrCode!.isNotEmpty)
              Center(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: QrImageView(
                      data: receipt.qrCode!,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
              ),
           
            if (receipt.qrCode != null && receipt.qrCode!.isNotEmpty)
              const SizedBox(height: 24),
            Text(
              "Payment Summary",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDetailRow("Payment ID:", receipt.paymentId),
            _buildDetailRow("Date:", DateFormat.yMMMd().add_jm().format(date)),
            _buildDetailRow("Total Amount:", "\$${receipt.totalAmount.toStringAsFixed(2)}", isTotal: true),
            const Divider(height: 30),

          
            Text(
              "Products",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: receipt.products.length,
              itemBuilder: (context, index) {
                final product = receipt.products[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Quantity: ${product.quantity}"),
                    trailing: Text("\$${(product.price * product.quantity).toStringAsFixed(2)}"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }
}