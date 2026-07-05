import 'dart:async';
import 'package:flutter/material.dart';
import '../user/user_home_screen.dart';
import '../../services/api_service.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;

  const OtpScreen({
    super.key,
    required this.mobile,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}


class _OtpScreenState extends State<OtpScreen> {

  final TextEditingController otpController =
      TextEditingController();

  int seconds = 30;
  Timer? timer;


  @override
  void initState() {
    super.initState();  
    startTimer();
  }
    
  
  void startTimer() { 

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {

        if (seconds > 0) {

          setState(() {
            seconds--;
          });

        } else {

          t.cancel();

        }

      },
    );

  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }



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
                "Verify OTP",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),


              const SizedBox(height: 40),


              TextField(

  controller: otpController,

  keyboardType: TextInputType.number,

  textAlign: TextAlign.center,

  maxLength: 6,

                decoration: InputDecoration(

                  hintText: "Enter OTP",

                  counterText: "",

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

  if (otpController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Enter OTP"),
      ),
    );
    return;
  }

  try {

    final response = await ApiService.verifyOtp(
      widget.mobile,
      otpController.text.trim(),
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

    }

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );

  }

},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),

                  child: const Text(
                    "VERIFY OTP",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ),

              ),


              const SizedBox(height: 20),



              Text(
                seconds > 0
                    ? "Resend OTP in $seconds seconds"
                    : "You can resend OTP",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),



              TextButton(

                onPressed: seconds == 0
    ? () async {
        try {
          final response =
              await ApiService.sendOtp(widget.mobile);

          if (response["success"] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "OTP Sent: ${response["otp"]}",
                ),
              ),
            );

            setState(() {
              seconds = 30;
            });

            startTimer();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response["message"]),
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
      }
    : null,

                child: const Text(
                  "RESEND OTP",
                  style: TextStyle(
                    color: Colors.red,
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