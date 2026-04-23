import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'search_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          height: 120,
                          width: 120,
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                              letterSpacing: 0.5,
                            ),
                            children: [
                              TextSpan(
                                text: 'S',
                                style: TextStyle(color: Color(0xFF00babc)),
                              ),
                              TextSpan(text: 'WIFTY '),
                              TextSpan(
                                text: 'C',
                                style: TextStyle(color: Color(0xFF00babc)),
                              ),
                              TextSpan(text: 'OMPANION'),
                            ],
                          ),
                        ),
                        const Text(
                          'SEARCH ANY 42 STUDENT PROFILE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 90),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: TextButton(
                        onPressed: _isLoading ? null : () async { 
                          setState(() => _isLoading = true);
                          try {
                            var code = await getCode();
                            var token = await getToken(code);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SearchScreen(),
                              ),
                            );
                          } catch (e) {
                            print("ERROR: $e");
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                        style: TextButton.styleFrom(
                          fixedSize: Size(screenWidth * 0.85, 80),
                          backgroundColor: const Color.fromRGBO(
                            0,
                            185,
                            188,
                            0.2,
                          ),
                          side: const BorderSide(
                            color: Color(0xFF00babc),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF00babc),
                              strokeWidth: 2,
                            ):
                          Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(40, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF00babc),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Login with 42 Intra',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Required to access the API',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
