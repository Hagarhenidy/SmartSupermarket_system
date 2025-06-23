import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_supermarket/features/auth/controller/auth_controller.dart';
import 'package:smart_supermarket/features/auth/screens/login_page.dart';
import 'package:smart_supermarket/features/profile/screens/receipts_screen.dart';
import 'package:smart_supermarket/features/profile/screens/update_profile_screen.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _authController.loadUserFromPrefs();
  }

  void _logout() async {
    await _authController.logout();
    if (mounted) {
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF5E8941),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF5E8941),
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: Obx(() => Column( 
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_authController.userName.value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(_authController.userEmail.value, style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Menu items
            _buildProfileMenuOption(
              icon: Icons.receipt_long,
              title: "My Receipts",
              onTap: () => Get.to(() => const ReceiptsScreen()),
            ),
            _buildProfileMenuOption(
              icon: Icons.person_outline,
              title: "Update Profile",
              onTap: () => Get.to(() => const UpdateProfileScreen()),
            ),
            const Divider(height: 40),
            _buildProfileMenuOption(
              icon: Icons.logout,
              title: "Log Out",
              color: Colors.red,
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Get.theme.iconTheme.color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color ?? Colors.grey),
      onTap: onTap,
    );
  }
}
