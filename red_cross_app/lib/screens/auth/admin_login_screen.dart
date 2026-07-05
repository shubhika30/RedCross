import 'package:flutter/material.dart';
import '../admin/admin_dashboard.dart';
import '../../services/api_service.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Text(
                "Admin Login",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  onPressed: isLoading ? null : () async {

                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final response = await ApiService.adminLogin(
                        phoneController.text.trim(),
                        passwordController.text.trim(),
                      );

                      print("LOGIN RESPONSE: $response"); // DEBUG

                      // ✅ FIX: check token instead of "success"
                      if (response["token"] != null) {

                        ApiService.setToken(response["token"]);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminDashboard(),
                          ),
                        );

                      } else {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              response["message"] ?? "Login failed",
                            ),
                          ),
                        );

                      }

                    } catch (e) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                        ),
                      );

                    }

                    setState(() {
                      isLoading = false;
                    });

                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),

                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),

                ),
              )

            ],

          ),

        ),
      ),
    );
  }
}