import 'package:flutter/material.dart';
import 'create_camp.dart';
import 'create_admin.dart';
import 'camp_details.dart';
import '../../services/api_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List camps = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCamps();
  }

  Future<void> fetchCamps() async {
    try {
      setState(() {
        loading = true;
      });

      final response = await ApiService.getAllCamps();

      setState(() {
        camps = response["data"] ?? [];
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

  Future<void> deleteCamp(String id) async {
    try {
      await ApiService.deleteCamp(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Camp deleted successfully"),
        ),
      );

      fetchCamps();
    } catch (e) {
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
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.red,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateCamp(),
                ),
              );

              if (created == true) {
                fetchCamps();
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Camp"),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateAdmin(),
                ),
              );
            },
            icon: const Icon(Icons.person_add, size: 18),
            label: const Text("Admin"),
          ),
          const SizedBox(width: 10),
        ],
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
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount =
                              constraints.maxWidth >= 1200
                                  ? 3
                                  : constraints.maxWidth >= 700
                                      ? 2
                                      : 1;

                          return GridView.builder(
                            itemCount: camps.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 1.55,
                            ),
                            itemBuilder: (context, index) {
                              final camp = camps[index];

                              return campCard(
                                context,
                                id: camp["_id"],
                                name: camp["title"] ?? "",
                                venue: camp["venue"] ?? "",
                                date: camp["date"] ?? "",
                                time: camp["time"] ?? "",
                                registrations:
                                    (camp["registrations"] ?? 0).toString(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget campCard(
    BuildContext context, {
    required String id,
    required String name,
    required String venue,
    required String date,
    required String time,
    required String registrations,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CampDetails(campId: id),
          ),
        );
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text("Venue: $venue"),
              Text("Date: $date"),
              Text("Time: $time"),

              const Spacer(),

              Text(
                "Registrations: $registrations",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Camp"),
                        content: const Text(
                          "Are you sure you want to delete this camp?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () =>
                                Navigator.pop(context, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      deleteCamp(id);
                    }
                  },
                  child: const Text("DELETE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}