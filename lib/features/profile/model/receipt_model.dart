class ProductItem {
  final String name;
  final double price;
  final int quantity;

  ProductItem({required this.name, required this.price, required this.quantity});

  
  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      name: json['name'] ?? 'Unknown Product',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }
}

class ReceiptModel {
  final String id;
  final String paymentId;
  final double totalAmount;
  final DateTime paidAt;
  final List<ProductItem> products;
  final String? qrCode; 

  ReceiptModel({
    required this.id,
    required this.paymentId,
    required this.totalAmount,
    required this.paidAt,
    required this.products,
    this.qrCode, 
  });

  
  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    String parsedPaymentId = '';
    if (json['paymentId'] != null && json['paymentId'] is Map) {
      parsedPaymentId = json['paymentId']['_id'] ?? '';
    }

    return ReceiptModel(
      id: json['_id'] ?? '',
      paymentId: parsedPaymentId,
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      paidAt: DateTime.parse(json['paidAt'] ?? DateTime.now().toIso8601String()),
      products: (json['products'] as List? ?? [])
          .map((item) => ProductItem.fromJson(item))
          .toList(),
      qrCode: json['qrCode'],
    );
  }
}