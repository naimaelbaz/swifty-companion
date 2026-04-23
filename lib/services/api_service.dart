import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<String> getCode() async {
    final result = await FlutterWebAuth2.authenticate(
        url: "https://api.intra.42.fr/oauth/authorize?client_id=${dotenv.env['CLIENT_ID']}&redirect_uri=myapp://callback&response_type=code",
        callbackUrlScheme: "myapp",
    );
    final code = Uri.parse(result).queryParameters['code'];
    if (code == null) {
        throw Exception("No code received from 42!");
    }
    return code;
}

Future<String> getToken(String code) async{
  var response = await http.post(
     Uri.parse('https://api.intra.42.fr/oauth/token'),
     body: {
        'client_id': dotenv.env['CLIENT_ID'],
        'client_secret': dotenv.env['CLIENT_SECRET'],
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': 'myapp://callback',
     });
  if (response.statusCode != 200) {
    throw Exception("invalid token");
  }
  final res = jsonDecode(response.body);
  final token = res['access_token'];

  await storage.write(key: 'access_token', value: token);
  await storage.write(key: 'expires_at', value: 
  (DateTime.now().millisecondsSinceEpoch + (res['expires_in'] * 1000)).toString());
  await storage.write(key: 'refresh_token', value: res['refresh_token']);
  return token;
}

Future<String?> getSavedToken() async {
  return await storage.read(key: 'access_token');
}

Future<void> clearToken() async {
  await storage.delete(key: 'access_token');
  await storage.delete(key: 'refresh_token');
  await storage.delete(key: 'expires_at');  
}

Future<String> refreshToken() async {
  final savedRefreshToken = await storage.read(key: 'refresh_token');
  var response = await http.post(
     Uri.parse('https://api.intra.42.fr/oauth/token'),
     body: {
        'grant_type': 'refresh_token',
        'refresh_token': savedRefreshToken,
        'client_id': dotenv.env['CLIENT_ID'],
        'client_secret': dotenv.env['CLIENT_SECRET'],
     });
  if (response.statusCode != 200) {
    await clearToken();
    throw Exception('Session expired. Please login again.');
  }
  final res = jsonDecode(response.body);
  final token = res['access_token'];
  await storage.write(key: 'access_token', value: token);
  await storage.write(key: 'expires_at', value:
  (DateTime.now().millisecondsSinceEpoch + (res['expires_in'] * 1000)).toString());
  await storage.write(key: 'refresh_token', value: res['refresh_token']);
  return token;
}

Future<String> getValidToken() async {
  final expiresAt = await storage.read(key: 'expires_at');
  final timeNow = DateTime.now().millisecondsSinceEpoch;
  if (expiresAt != null && int.parse(expiresAt) < timeNow) {
    return await refreshToken();
  }
  return await storage.read(key: 'access_token') ?? "";
}

Future<User> fetchUser(String login, String accessToken) async {

  final user = await http.get(
    Uri.parse('https://api.intra.42.fr/v2/users/$login'),
    headers: {
    'Authorization': 'Bearer $accessToken',
    }
  );
  if (user.statusCode == 404) {
    throw Exception("User not found!");
  }
  if (user.statusCode != 200) {
    throw Exception("Something went wrong!");
  }
  final response = jsonDecode(user.body);
  return User.fromJson(response);
}

Future<Coalition> fetchUserCoalitions(String login, String accessToken) async{
  final coalition = await http.get(
    Uri.parse('https://api.intra.42.fr/v2/users/$login/coalitions'),
      headers:{
        'Authorization' : 'Bearer $accessToken',
      }
    );
    if (coalition.statusCode == 404) {
      throw Exception("User not found!");
    }
    if (coalition.statusCode != 200) {
      throw Exception("Something went wrong!");
    }
  final List<dynamic> response = jsonDecode(coalition.body);
  if (response.isEmpty) {
    return Coalition(name: "No Coalition", imageUrl: "", color: "#1A2A3A");
  }

  return Coalition.fromJson(response[0]);
}


Future<void> forceExpireToken() async {
  await storage.write(key: 'expires_at', value: '0'); // ← sets expiry to 1970
}