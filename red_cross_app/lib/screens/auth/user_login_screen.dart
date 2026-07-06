import 'package:flutter/material.dart';
import '../user/user_home_screen.dart';
import 'admin_login_screen.dart';
import '../../services/api_service.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {                      
  final TextEditingController mobileController =
      TextEditingController();

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
                "RED CROSS",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 50),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter Mobile Number",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,

                decoration: InputDecoration(
                  prefixText: "+91 ",
                  hintText: "Mobile Number",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  onPressed: () async {

                    if (mobileController.text.isEmpty) {

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Enter Mobile Number",
                          ),
                        ),
                      );

                      return;
                    }

                    try {

                      final response = await ApiService.userLogin(
                        mobileController.text.trim(),
                      );

                      if (response["success"] == true) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login Successful"),
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserHomeScreen(),
                          ),
                        );

                      } else {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              response["message"],
                            ),
                          ),
                        );

                      }

                    } catch (e) {

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            "Error: $e",
                          ),
                        ),
                      );

                    }

                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),

                  child: const Text(
                    "LOGIN AS USER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                ),
              ),

              const SizedBox(height: 25),

              TextButton(

                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AdminLoginScreen(),
                    ),
                  );

                },

                child: const Text(
                  "Login as Admin",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
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