import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CreateCamp extends StatefulWidget {
  const CreateCamp({super.key});

  @override
  State<CreateCamp> createState() => _CreateCampState();
}

class _CreateCampState extends State<CreateCamp> {

  final TextEditingController campNameController =
      TextEditingController();

  final TextEditingController venueController =
      TextEditingController();

  final TextEditingController dateController =
      TextEditingController();

  final TextEditingController timeController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  final TextEditingController instructionsController =
      TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Camp"),
        backgroundColor: Colors.red,
      ),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [


            buildField(
              controller: campNameController,
              label: "Camp Name",
            ),


            const SizedBox(height: 15),


            buildField(
              controller: venueController,
              label: "Venue",
            ),


            const SizedBox(height: 15),


            TextField(
  controller: dateController,
  readOnly: true,
  decoration: InputDecoration(
    labelText: "Date",
    hintText: "Select Date",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    suffixIcon: const Icon(Icons.calendar_today),
  ),
  onTap: () async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      dateController.text =
          "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";
    }
  },
),


            const SizedBox(height: 15),


            buildField(
              controller: timeController,
              label: "Time",
              hint: "10:00 AM",
            ),


            const SizedBox(height: 15),


            buildField(
              controller: instructionsController,
              label: "Instructions",
            ),


            const SizedBox(height: 15),


            TextField(

              controller: descriptionController,

              maxLines: 4,

              decoration: InputDecoration(

                labelText: "Description",

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

                  if (campNameController.text.trim().isEmpty ||
                      venueController.text.trim().isEmpty ||
                      dateController.text.trim().isEmpty ||
                      timeController.text.trim().isEmpty) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all required fields"),
                      ),
                    );
                    return;
                  }

                  try {

                    final response = await ApiService.createCamp({

                      "title": campNameController.text.trim(),

                      "venue": venueController.text.trim(),

                      "date": dateController.text.trim(),

                      "time": timeController.text.trim(),

                      "description": descriptionController.text.trim(),

                      "instructions": instructionsController.text.trim(),

                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response["message"]),
                      ),
                    );

                    Navigator.pop(context, true);

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

                  "CREATE CAMP",

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



  Widget buildField({

    required TextEditingController controller,

    required String label,

    String? hint,

    TextInputType keyboard = TextInputType.text,

  }) {

    return TextField(

      controller: controller,

      keyboardType: keyboard,

      decoration: InputDecoration(

        labelText: label,

        hintText: hint,

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(12),

        ),

      ),

    );

  }


}