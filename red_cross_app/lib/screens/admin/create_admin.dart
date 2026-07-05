import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({super.key});

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}


class _CreateAdminState extends State<CreateAdmin> {


  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Admin"),
        backgroundColor: Colors.red,
      ),


      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [


            const Text(
              "Create New Admin",
              style: TextStyle(
                fontSize: 28,
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

                onPressed: () async {
  try {
    final result = await ApiService.createAdmin(
      phoneController.text.trim(),
      passwordController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result["message"]),
      ),
    );

    phoneController.clear();
    passwordController.clear();
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

                  "CREATE ADMIN",

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

    );

  }

}