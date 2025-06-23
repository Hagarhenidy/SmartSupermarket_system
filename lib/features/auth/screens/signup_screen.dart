import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/screens/home_page.dart';
import '../controller/auth_controller.dart';
import 'login_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _agreedToPolicy = false;
  bool _isLoading = false;

  void _signUp() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate() && _agreedToPolicy) {
      setState(() {
        _isLoading = true;
      });

      final name = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text;

      try {
        final success =
        await _authController.signup(name, email, phone, password);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registered successfully! Please log in."),
              backgroundColor: Colors.green,
            ),
          );
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else if (mounted) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration failed. Please try again."),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        
        String errorMessage = "An unknown error occurred.";

        
        if (e.toString().contains("this user already exist")) {
          errorMessage = "This user already exists. Please try to log in.";
        } else if (e.toString().contains("→")) { 
          final jsonString = e.toString().split('→')[1].trim();
          try {
            final jsonBody = jsonDecode(jsonString);
            errorMessage = jsonBody['message'] ?? "Registration failed.";
          } catch (_) {
            errorMessage = "Failed to parse server response.";
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if(mounted){
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else if (!_agreedToPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must agree to the personal data policy."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xFF639543),
              Color(0xFF50723A),
              Color(0xFF385426),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 70),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 30),
                        const Text(
                          'Get Started',
                          style: TextStyle(
                            color: Color(0xFF639543),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Full Name Field
                        _buildInputBox(
                          controller: _fullNameController,
                          hint: "Full Name",
                          validatorText: "Please enter your full name",
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        _buildInputBox(
                          controller: _emailController,
                          hint: "Email",
                          validatorText: "Please enter your email",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // Phone Field
                        _buildInputBox(
                          controller: _phoneController,
                          hint: "Phone Number",
                          validatorText: "Please enter your phone number",
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        _buildInputBox(
                          controller: _passwordController,
                          hint: "Password",
                          obscureText: true,
                          validatorText: "Please enter your password",
                        ),
                        const SizedBox(height: 30),

                        // Terms Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _agreedToPolicy,
                              onChanged: (value) {
                                setState(() {
                                  _agreedToPolicy = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF639543),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'I agree to the processing of ',
                                  style: TextStyle(color: Colors.grey[700]),
                                  children: const [
                                    TextSpan(
                                      text: 'personal data',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF639543),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF639543),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 15,
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(color: Colors.black45),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Color(0xFF639543),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBox({
    required TextEditingController controller,
    required String hint,
    required String validatorText,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: _inputBoxDecoration(),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorText;
          }
          if (hint == "Email" && !GetUtils.isEmail(value)) {
            return "Enter a valid email address";
          }
          if (hint == "Password" && value.length < 6) {
            return "Password must be at least 6 characters";
          }
          return null;
        },
      ),
    );
  }

  BoxDecoration _inputBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border.all(color: Colors.grey.shade200),
    );
  }
}