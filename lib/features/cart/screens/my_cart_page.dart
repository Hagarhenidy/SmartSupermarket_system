import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_supermarket/features/cart/controller/cart_controller.dart';
import 'package:smart_supermarket/features/cart/model/cart_model.dart';
import 'package:smart_supermarket/features/home/model/product_model.dart';
import 'package:smart_supermarket/features/payment/controller/payment_controller.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  final CartController cartController = Get.find<CartController>();
  final PaymentController _paymentController = PaymentController();
  bool _isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FF),
        elevation: 0,
        title: const Text(
          "My Cart",
          style: TextStyle(
              color: Color(0xFF2D3142),
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2D3142)),
        actions: [
          Obx(() => IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: (cartController.cart.value != null &&
                cartController.cart.value!.items.isNotEmpty)
                ? () => cartController.clearCart()
                : null,
          )),
        ],
      ),
      body: Obx(() {
        if (cartController.isLoading.value && cartController.cart.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final cart = cartController.cart.value;

        if (cart != null && cart.items.isEmpty) {
          return Column(
            children: [
              Expanded(child: _buildEmptyCart()),
              _buildRecommendationsSection(cartController),
            ],
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: cart?.items.length ?? 0,
                itemBuilder: (context, index) {
                  final item = cart!.items[index];
                  return _buildCartItem(item, cartController);
                },
              ),
            ),
            _buildRecommendationsSection(cartController),
            if (cart != null) _buildCheckoutSection(cart.totalPrice),
          ],
        );
      }),
    );
  }

  Widget _buildRecommendationsSection(CartController controller) {
    return Obx(() {
      if (controller.isRecommendationsLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.recommendedProducts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        color: const Color(0xFFF8F9FF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "You might like",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.recommendedProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.recommendedProducts[index];
                  return _buildRecommendationItem(product, controller);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRecommendationItem(Product product, CartController controller) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, CartController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                item.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.shopping_bag_outlined,
                      color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "\$${item.product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.grey),
                        onPressed: () => controller.decreaseQuantity(item.product.id),
                      ),
                      Text(
                        'x${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () =>
                  controller.removeFromCart(item.product.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0x157FBD72),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF7FBD72).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5)
              ],
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                size: 70, color: Color(0xFF4CAF50)),
          ),
          const SizedBox(height: 30),
          const Text("Your Cart is Empty",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142))),
          const SizedBox(height: 15),
          const Text("Add items to your cart to see them here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9C9EB9), fontSize: 16)),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Start Shopping",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  
  Widget _buildCheckoutSection(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4CAF50))),
              Text('\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142))),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: (totalPrice > 0 && !_isProcessingPayment)
                  ? () async {
                setState(() {
                  _isProcessingPayment = true;
                });

                try {
                  await _paymentController.makePayment(context);
                  await cartController.fetchCart();
                } catch (e) {
                  
                  print("Checkout button caught an error: $e");
                } finally {
                  if (mounted) {
                    setState(() {
                      _isProcessingPayment = false;
                    });
                  }
                }
              }
                  : null, 
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: const Color(0xFFD7D9E4),
                backgroundColor: const Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: _isProcessingPayment
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Checkout",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}