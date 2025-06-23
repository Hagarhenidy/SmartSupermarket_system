class ProductSize {
  final String size;
  final double price;
  final int stock;

  ProductSize({
    required this.size,
    required this.price,
    required this.stock,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      size: json['size'],
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final int stock;
  final String qrCode;
  final List<ProductSize> sizes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.stock,
    required this.qrCode,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      stock: json['stock'] ?? 0,
      qrCode: json['qrCode']?['data'] ?? json['qrCode'] ?? '',
      sizes: (json['sizes'] as List<dynamic>? ?? [])
          .map((e) => ProductSize.fromJson(e))
          .toList(),
    );
  }
}