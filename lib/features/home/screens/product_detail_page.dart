import 'package:flutter/material.dart';
import '../model/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: const Color(0xFF5E8941),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              if (product.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    product.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: Icon(Icons.error, color: Colors.red[300], size: 50),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Product Name
              Text(
                product.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Product Price
              Text(
                product.sizes.isNotEmpty
                    ? '\$${product.sizes[0].price.toStringAsFixed(2)}'
                    : '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5E8941)),
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                "Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),

              // Stock and Category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Category: ${product.category}', style: const TextStyle(fontSize: 16)),
                  Text('Stock: ${product.stock}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),

              // Sizes
              if (product.sizes.isNotEmpty) ...[
                const Text(
                  "Available Sizes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: product.sizes.map((size) {
                    return Chip(
                      label: Text('${size.size} - \$${size.price.toStringAsFixed(2)}'),
                      backgroundColor: Colors.grey[200],
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}