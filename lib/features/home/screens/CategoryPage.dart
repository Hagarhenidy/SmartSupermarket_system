// import 'package:flutter/material.dart';
// import 'package:smart_supermarket/features/home/screens/product_detail_page.dart';
// import '../controller/home_controller.dart';
// import '../model/product_model.dart';
//
// class CategoryPage extends StatelessWidget {
//   final String categoryName;
//   final HomeController _controller = HomeController();
//
//   CategoryPage({super.key, required this.categoryName});
//
//   // Fallback sample products for testing
//   List<Map<String, dynamic>> getSampleProducts(String category) {
//     return [
//       {"name": "$category Product 1", "price": 12.99, "image": ""},
//       {"name": "$category Product 2", "price": 8.50, "image": ""},
//       {"name": "$category Product 3", "price": 15.00, "image": ""},
//       {"name": "$category Product 4", "price": 22.75, "image": ""},
//       {"name": "$category Product 5", "price": 9.99, "image": ""},
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(categoryName),
//         backgroundColor: const Color(0xFF5E8941),
//         foregroundColor: Colors.white,
//       ),
//       body: FutureBuilder<List<Product>>(
//         future: _controller.getProducts(categoryName),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           // If there's an error or no data, show sample products
//           List<dynamic> productsToShow;
//           bool isFromApi = false;
//
//           if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
//             print('Using sample data for $categoryName. Error: ${snapshot.error}');
//             productsToShow = getSampleProducts(categoryName);
//             isFromApi = false;
//           } else {
//             productsToShow = snapshot.data!;
//             isFromApi = true;
//           }
//
//           return Column(
//             children: [
//               // Show a banner if using sample data
//               if (!isFromApi)
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(8.0),
//                   color: Colors.orange[100],
//                   child: Text(
//                     '📝 Showing sample data (API not connected)',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.orange[800]),
//                   ),
//                 ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: GridView.builder(
//                     itemCount: productsToShow.length,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10.0,
//                       mainAxisSpacing: 10.0,
//                       childAspectRatio: 0.75,
//                     ),
//                     itemBuilder: (context, index) {
//                       final item = productsToShow[index];
//
//                       // Handle both Product objects and sample data maps
//                       String productName;
//                       String productPrice;
//                       String productImage;
//
//                       if (isFromApi && item is Product) {
//                         productName = item.name;
//                         productPrice = item.sizes.isNotEmpty
//                             ? '\$${item.sizes[0].price.toStringAsFixed(2)}'
//                             : '\$${item.price.toStringAsFixed(2)}';
//                         productImage = item.imageUrl;
//                       } else {
//                         productName = item['name'] ?? 'Unknown Product';
//                         productPrice = '\$${(item['price'] ?? 0).toStringAsFixed(2)}';
//                         productImage = item['image'] ?? '';
//                       }
//
//                       return GestureDetector(
//                         onTap: () {
//                           if (isFromApi && item is Product) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ProductDetailPage(product: item),
//                               ),
//                             );
//                           } else {
//                             // Optionally, show a message for sample data
//                             print("Cannot view details for sample data.");
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text("Details are not available for sample products.")),
//                             );
//                           }
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.5),
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   flex: 3,
//                                   child: productImage.isNotEmpty
//                                       ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Image.network(
//                                       productImage,
//                                       fit: BoxFit.cover,
//                                       width: double.infinity,
//                                       loadingBuilder: (context, child, loadingProgress) {
//                                         if (loadingProgress == null) return child;
//                                         return const Center(
//                                           child: CircularProgressIndicator(),
//                                         );
//                                       },
//                                       errorBuilder: (_, __, ___) => Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[200],
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                         child: Icon(
//                                           Icons.shopping_bag,
//                                           size: 50,
//                                           color: const Color(0xFF5E8941),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                       : Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[100],
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Icon(
//                                       Icons.shopping_bag,
//                                       size: 50,
//                                       color: const Color(0xFF5E8941),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         productName,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         productPrice,
//                                         style: const TextStyle(
//                                           color: Color(0xFF5E8941),
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 12,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:smart_supermarket/features/home/screens/product_detail_page.dart';
import '../controller/home_controller.dart';
import '../model/product_model.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  final HomeController _controller = HomeController();

  CategoryPage({super.key, required this.categoryName, });

  List<Product> getSampleProducts(String category) {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: const Color(0xFF5E8941),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Product>>(

        future: _controller.getProducts(categoryName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error fetching products: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found in this category."));
          }

        
          final productsToShow = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              itemCount: productsToShow.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = productsToShow[index];
                final productName = product.name;
                final productPrice = product.price.toStringAsFixed(2);
                final productImage = product.imageUrl;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: productImage.isNotEmpty
                              ? Image.network(
                            productImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => const Icon(Icons.error),
                          )
                              : Container(color: Colors.grey[200]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            productName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(bottom: 8.0),
                          child: Text(
                            '\$$productPrice',
                            style: const TextStyle(color: Color(0xFF5E8941), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}