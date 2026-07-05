import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class RegistrationFormScreen extends StatefulWidget {

  final String campId;

  const RegistrationFormScreen({
    super.key,
    required this.campId,
  });

  @override
  State<RegistrationFormScreen> createState() =>
      _RegistrationFormScreenState();
}

class _RegistrationFormScreenState
    extends State<RegistrationFormScreen> {

  final fullNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final ageController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final occupationController = TextEditingController();

  // Read-only mobile number
late final TextEditingController mobileController;

  final emailController = TextEditingController();
  final bloodGroupController = TextEditingController();

  final donationCountController =
      TextEditingController();

  final lastDonationController =
      TextEditingController();

  String sex = "Male";

  bool donatedPreviously = false;
  @override
void initState() {
  super.initState();

  mobileController = TextEditingController(
    text: ApiService.mobile ?? "",
  );
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Camp Registration"),
        backgroundColor: Colors.red,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            buildField(
              fullNameController,
              "Full Name",
            ),

            const SizedBox(height: 15),

            buildField(
              fatherNameController,
              "Father's Name",
            ),

            const SizedBox(height: 15),

            buildField(
              ageController,
              "Age",
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(

              value: sex,

              decoration: const InputDecoration(
                labelText: "Sex",
                border: OutlineInputBorder(),
              ),

              items: const [

                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male"),
                ),

                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),

                DropdownMenuItem(
                  value: "Other",
                  child: Text("Other"),
                ),

              ],

              onChanged: (value) {

                setState(() {
                  sex = value!;
                });

              },

            ),

            const SizedBox(height: 15),

            buildField(
              dobController,
              "Date of Birth",
            ),

            const SizedBox(height: 15),

            buildField(
              addressController,
              "Address for Communication",
            ),

            const SizedBox(height: 15),

            buildField(
              occupationController,
              "Occupation",
            ),

            const SizedBox(height: 15),

            TextField(
              controller: mobileController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            buildField(
              emailController,
              "Email ID",
              keyboard: TextInputType.emailAddress,
            ),

            const SizedBox(height: 15),

            buildField(
              bloodGroupController,
              "Blood Group",
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Have you ever donated blood previously?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            RadioListTile(

              title: const Text("Yes"),

              value: true,

              groupValue: donatedPreviously,

              onChanged: (value) {

                setState(() {
                  donatedPreviously = value!;
                });

              },

            ),

            RadioListTile(

              title: const Text("No"),

              value: false,

              groupValue: donatedPreviously,

              onChanged: (value) {

                setState(() {
                  donatedPreviously = value!;
                });

              },

            ),

            if (donatedPreviously) ...[

              buildField(
                donationCountController,
                "How Many Times?",
                keyboard: TextInputType.number,
              ),

              const SizedBox(height: 15),

              buildField(
                lastDonationController,
                "When Last?",
              ),

            ],

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed: () async {
  try {
    final response = await ApiService.registerCamp({
      "campId": widget.campId,
      "name": fullNameController.text.trim(),
      "fatherName": fatherNameController.text.trim(),
      "email": emailController.text.trim(),
      "bloodGroup": bloodGroupController.text.trim(),
      "age": int.parse(ageController.text.trim()),
      "gender": sex,
      "dob": dobController.text.trim(),
      "address": addressController.text.trim(),
      "occupation": occupationController.text.trim(),
      "hasDonatedBefore": donatedPreviously,
      "donationCount": donatedPreviously
          ? int.parse(donationCountController.text.trim())
          : 0,
      "lastDonationDate": donatedPreviously
          ? lastDonationController.text.trim()
          : null,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response["message"]),
      ),
    );

    Navigator.pop(context);

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
                  "SUBMIT REGISTRATION",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

              ),

            ),

            const SizedBox(height: 20),

          ],

        ),

      ),

    );

  }

  Widget buildField(
    TextEditingController controller,
    String label, {
    TextInputType keyboard =
        TextInputType.text,
  }) {

    return TextField(

      controller: controller,

      keyboardType: keyboard,

      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),

    );

  }
}