import 'package:flutter/material.dart';
import 'registration_form_screen.dart';
import '../../services/api_service.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List camps = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCamps();
  }

  Future<void> fetchCamps() async {
    try {
      final data = await ApiService.getPublicCamps();

      setState(() {
  camps = data["data"];
  loading = false;
});
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Camps"),
        backgroundColor: Colors.red,
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : camps.isEmpty
              ? const Center(
                  child: Text(
                    "No Camps Available",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: camps.length,
                  itemBuilder: (context, index) {
                    final camp = camps[index];

                    return campCard(
                      context,
                      campName: camp["title"] ?? "",
                      venue: camp["venue"] ?? "",
                      date: camp["date"] ?? "",
                      time: camp["time"] ?? "",
                      description: camp["description"] ?? "",
                      campId: camp["_id"],
                    );
                  },
                ),
    );
  }

  Widget campCard(
    BuildContext context, {
    required String campName,
    required String venue,
    required String date,
    required String time,
    required String description,
    required String campId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("Venue: $venue"),
            Text("Date: $date"),
            Text("Time: $time"),

            const SizedBox(height: 10),

            Text(
              description,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegistrationFormScreen(
                        campId: campId,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "REGISTER",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}