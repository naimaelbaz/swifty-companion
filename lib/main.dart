import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/search_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  final token = await getSavedToken();
  runApp(MyApp(initialToken: token));
}

class MyApp extends StatelessWidget{
  final String? initialToken;
  MyApp({this.initialToken});

  @override

  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Swifty Companion',
      home: initialToken == null ? LoginScreen() : SearchScreen(),
    );
  }
}

