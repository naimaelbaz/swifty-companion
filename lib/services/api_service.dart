import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<String> getToken() async {
  var response = await http.post(
    Uri.parse('https://api.intra.42.fr/oauth/token'),
    body: {
      'grant_type': 'client_credentials',
      'client_id': dotenv.env['CLIENT_ID'],
      'client_secret': dotenv.env['CLIENT_SECRET'],
    }
  );
  if (response.statusCode != 200) {
    throw Exception("Failed to get token");
  }
  final Map<String, dynamic> res = jsonDecode(response.body);
  final String token = res['access_token'];
  await storage.write(key: 'access_token', value: token);
  await storage.write(key: 'expires_at', value:
    (DateTime.now().millisecondsSinceEpoch + (res['expires_in'] * 1000)).toString());
  return token;
}

Future<String> getValidToken() async {
  final expiresAt = await storage.read(key: 'expires_at');
  final timeNow = DateTime.now().millisecondsSinceEpoch;
  if (expiresAt != null && int.parse(expiresAt) < timeNow) {
    return await getToken();
  }
  return await storage.read(key: 'access_token') ?? await getToken();
}


Future<User> fetchUser(String login, String accessToken) async {
  final user = await http.get(
    Uri.parse('https://api.intra.42.fr/v2/users/$login'),
    headers: {'Authorization': 'Bearer $accessToken'}
  );
  if (user.statusCode == 404) throw Exception("User not found!");
  if (user.statusCode != 200) throw Exception("Something went wrong!");
  return User.fromJson(jsonDecode(user.body));
}

Future<Coalition> fetchUserCoalitions(String login, String accessToken) async {
  final coalition = await http.get(
    Uri.parse('https://api.intra.42.fr/v2/users/$login/coalitions'),
    headers: {'Authorization': 'Bearer $accessToken'}
  );
  if (coalition.statusCode == 404) throw Exception("User not found!");
  if (coalition.statusCode != 200) throw Exception("Something went wrong!");
  final List<dynamic> response = jsonDecode(coalition.body);
  if (response.isEmpty) {
    return Coalition(name: "No Coalition", imageUrl: "", color: "#1A2A3A");
  }
  return Coalition.fromJson(response[0]);
}