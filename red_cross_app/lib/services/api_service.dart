import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    "BASE_URL",
    defaultValue: "https://redcross-backend-je7s.onrender.com/api",
  );
}

  // =========================
  // TOKEN MANAGEMENT
  // =========================
  static String? _token;
static String? _mobile;

  static void setToken(String token) {
    _token = token;
  }

  static String? get token => _token;
  static String? get mobile => _mobile;

  // =========================
  // HEADERS HELPERS
  // =========================
  static Map<String, String> _headers({bool auth = false}) {
    return {
      "Content-Type": "application/json",
      if (auth && _token != null) "Authorization": "Bearer $_token",
    };
  }

  // =========================
  // SEND OTP
  // =========================
  static Future<Map<String, dynamic>> sendOtp(String mobile) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/send-otp"),
      headers: _headers(),
      body: jsonEncode({"mobile": mobile}),
    );

    return _handleResponse(response);
  }

  // =========================
// VERIFY OTP
// =========================
static Future<Map<String, dynamic>> verifyOtp(
  String mobile,
  String otp,
) async {
  final response = await http.post(
    Uri.parse("${ApiConfig.baseUrl}/auth/verify-otp"),
    headers: _headers(),
    body: jsonEncode({
      "mobile": mobile,
      "otp": otp,
    }),
  );

  final data = _handleResponse(response);

  // Save JWT token after successful login
  if (data["token"] != null) {
    _token = data["token"];
    _mobile = mobile;
  }

  return data;
}

  // =========================
  // ADMIN LOGIN
  // =========================
  static Future<Map<String, dynamic>> adminLogin(
      String mobile,
      String password) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/admin-login"),
      headers: _headers(),
      body: jsonEncode({
        "mobile": mobile,
        "password": password,
      }),
    );

    final data = _handleResponse(response);

    if (data["token"] != null) {
      _token = data["token"];
    }

    return data;
  }


  // =========================
// CREATE ADMIN
// =========================
static Future<Map<String, dynamic>> createAdmin(
  String mobile,
  String password,
) async {
  final response = await http.post(
    Uri.parse("${ApiConfig.baseUrl}/auth/create-admin"),
    headers: _headers(auth: true),
    body: jsonEncode({
      "mobile": mobile,
      "password": password,
    }),
  );

  return _handleResponse(response);
}
  // =========================
// GET PUBLISHED CAMPS
// =========================
static Future<Map<String, dynamic>> getPublicCamps() async {
  final response = await http.get(
    Uri.parse("${ApiConfig.baseUrl}/camps/public/all"),
    headers: _headers(),
  );

  return _handleResponse(response);
}


// =========================
// REGISTER FOR CAMP
// =========================
static Future<Map<String, dynamic>> registerCamp(
    Map<String, dynamic> data) async {

  final response = await http.post(
    Uri.parse("${ApiConfig.baseUrl}/registrations/register"),
    headers: _headers(auth: true),
    body: jsonEncode(data),
  );

  return _handleResponse(response);
}

  // =========================
  // GET ALL CAMPS (ADMIN)
  // =========================
  static Future<Map<String, dynamic>> getAllCamps() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/camps"),
      headers: _headers(auth: true),
    );

    return _handleResponse(response);
  }

  // =========================
  // CREATE CAMP (ADMIN)
  // =========================
  static Future<Map<String, dynamic>> createCamp(
    Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse("${ApiConfig.baseUrl}/camps/create"),
    headers: _headers(auth: true),
    body: jsonEncode(data),
  );

  return _handleResponse(response);
}

  // =========================
  // DELETE CAMP (ADMIN)
  // =========================
  static Future<Map<String, dynamic>> deleteCamp(String id) async {
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/camps/delete/$id"),
      headers: _headers(auth: true),
    );

    return _handleResponse(response);
  }

  // =========================
  // GET CAMP DETAILS
  // =========================
  static Future<Map<String, dynamic>> getCampDetails(String id) async {
    final response = await http.get(
    Uri.parse("${ApiConfig.baseUrl}/camps/details/$id"),
    headers: _headers(auth: true),
  );

  return _handleResponse(response);
}

  // =========================
  // DOWNLOAD PDF REPORT
  // =========================
  static Future<http.Response> downloadCampReport(String id) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/camps/$id/report"),
      headers: _headers(auth: true),
    );

    return response;
  }

  // =========================
  // RESPONSE HANDLER (SAFE)
  // =========================
  static dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data["message"] ?? "API Error");
    }
  }
}