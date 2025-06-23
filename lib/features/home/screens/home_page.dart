import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:smart_supermarket/features/home/screens/search_results_page.dart';

import '../../../shared/Widgets/CategoriesWidget.dart';
import '../../auth/controller/auth_controller.dart';
import '../../cart/controller/cart_controller.dart';
import '../../cart/screens/my_cart_page.dart';
import '../../profile/screens/profile_page.dart';
import '../../scan/screens/scan_screen.dart';
import '../controller/home_controller.dart';
import '../model/category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  final HomeController _homeController = HomeController();
  final AuthController _authController = AuthController();
  final CartController _cartController = Get.put(CartController());
  List<Category> _categories = [];
  bool _isLoading = true;
  String _userName = "User";

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _cartController.fetchCart();
  }

  Future<void> _loadInitialData() async {
    await fetchCategories();
    await _fetchUserName();
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await _homeController.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: \$e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchUserName() async {
    final name = await _authController.getUserName();
    if (mounted) {
      setState(() {
        _userName = name;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5E8941),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Obx(() {
                    final itemCount = _cartController.cart.value?.items.length ?? 0;
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF71A94F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: badges.Badge(
                        showBadge: itemCount > 0,
                        badgeContent: Text(
                          '$itemCount',
                          style: const TextStyle(color: Colors.white),
                        ),
                        badgeColor: Colors.red,
                        padding: const EdgeInsets.all(7),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyCartPage()),
                            ).then((_) => _cartController.fetchCart());
                          },
                          child: const Icon(
                            CupertinoIcons.cart,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome,",
                    style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _userName,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final query = _searchController.text;
                        if (query.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SearchResultsPage(searchQuery: query)),
                          );
                        }
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search here...",
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (query) {
                          if (query.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SearchResultsPage(searchQuery: query)),
                            );
                          }
                        },
                      ),
                    ),
                    const Icon(Icons.filter_list),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _categories.isEmpty
                    ? const Center(
                  child: Text(
                    'No categories available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                    : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: _categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    String fullImageUrl = "";
                    if (category.image != null && category.image!.isNotEmpty) {
                      const String imageBaseUrl = "https://super-market-five.vercel.app/uploads/";
                      fullImageUrl = imageBaseUrl + category.image!;
                    }
                    return CategoriesWidget(
                      title: category.name,
                      imageUrl: fullImageUrl,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF5E8941),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
