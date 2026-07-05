import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:universal_html/html.dart' as html;

class CampDetails extends StatefulWidget {
  final String campId;

  const CampDetails({super.key, required this.campId});

  @override
  State<CampDetails> createState() => _CampDetailsState();
}

class _CampDetailsState extends State<CampDetails> {
  bool loading = true;
  bool downloading = false;

  Map<String, dynamic>? camp;

  @override
  void initState() {
    super.initState();
    fetchCamp();
  }

  Future<void> fetchCamp() async {
  try {
    setState(() => loading = true);

    final data = await ApiService.getCampDetails(widget.campId);

    setState(() {
      camp = {
        ...data["camp"],
        "registrations": data["totalRegistrations"],
        "users": data["registrations"],
      };

      loading = false;
    });
  } catch (e) {
    setState(() => loading = false);

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
        title: const Text("Camp Details"),
        backgroundColor: Colors.red,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : camp == null
              ? const Center(child: Text("No camp data found"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        camp!["title"] ?? "",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      infoTile("Venue", camp!["venue"] ?? ""),
                      infoTile("Date", camp!["date"] ?? ""),
                      infoTile("Time", camp!["time"] ?? ""),
                      infoTile(
                        "Total Registrations",
                        "${camp!["registrations"] ?? 0}",
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Registered People",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      ...(camp!["users"] ?? []).map<Widget>((u) {
                        return personCard(
                          name: u["name"] ?? "",
                          phone: u["phone"] ?? "",
                          age: "${u["age"] ?? ""}",
                        );
                      }).toList(),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton.icon(
                          onPressed: downloading
    ? null
    : () async {
        setState(() => downloading = true);

        try {
  final response =
      await ApiService.downloadCampReport(widget.campId);

  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;

    final blob = html.Blob([bytes], 'application/pdf');

    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
        "download",
        "camp_report_${widget.campId}.pdf",
      )
      ..click();

    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("PDF downloaded successfully"),
      ),
    );
  } else {
    throw Exception("Failed to download PDF");
  }
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(e.toString()),
    ),
  );
} catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }

        setState(() => downloading = false);
      },

                          icon: downloading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download,
                                  color: Colors.white),

                          label: Text(
                            downloading
                                ? "DOWNLOADING..."
                                : "DOWNLOAD AS PDF",
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget personCard({
    required String name,
    required String phone,
    required String age,
  }) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.red),
        title: Text(name),
        subtitle: Text("Phone: $phone\nAge: $age"),
      ),
    );
  }
}