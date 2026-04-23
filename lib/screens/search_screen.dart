import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';


class SearchScreen extends StatefulWidget {
  // final String token;
  // SearchScreen({required this.token});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _controller = TextEditingController();
  String inputString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1A2A3A),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 50,
            ),
            GestureDetector(
              onTap: () async{
                await clearToken();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 6),
                width:110,
                height: 30,
                decoration: BoxDecoration(
                  // color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF00babc), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Padding for the text to move it away from the left edge
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'LOGOUT',
                        style: TextStyle(
                          color: Color(0xFF00babc),
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    Container(
                      width: 40,
                      height: 36,
                      // margin: const EdgeInsets.all(
                      //   2,
                      // ), // Creates a tiny gap from the border
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          22,
), // Matches the pill shape
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Color(0xFF00babc),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xff1A2A3A),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          // Keeps the content centered horizontally
          // child: SingleChildScrollView(
            // Prevents overflow on mobile keyboards
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.07,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- HEADER SECTION ---
                  Column(
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5, // Increased for a tech look
                          ),
                          children: [
                            TextSpan(
                              text: 'SWIFTY',
                              style: TextStyle(color: Color(0xFF00babc)),
                            ),
                            TextSpan(
                              text: 'COMPANION',
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        height: 1.5,
                        color: const Color(0xFF00babc).withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '42 STUDENT PROFILE VIEWER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 5,
                          fontWeight: FontWeight.w200,
                          fontSize: 12,
                          color: Color(0xFF00babc),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // --- INPUT & BUTTON SECTION (Constrained for Large Screens) ---
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        const Text(
                          'Search any 42 student and view their profile, skills and projects.',
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          cursorColor: const Color(0xFF00babc),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Enter a 42 login',
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            labelStyle: const TextStyle(color: Colors.grey),
                            floatingLabelStyle: const TextStyle(
                              color: Color(0xFF00babc),
                            ),
                            prefixIcon: const Icon(
                              Icons.person_search,
                              color: Color(0xFF00babc),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Color(0xFF00babc),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Color(0xFF00babc),
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              inputString = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : () async {
                            if (inputString.trim().isEmpty)
                              return;
                            setState(() {    
                              _isLoading = true; 
                              _errorMessage = null;
                            });          
                            try {
                              final token = await getValidToken();
                              final results = await Future.wait([
                                fetchUser(inputString.trim(), token),
                                fetchUserCoalitions(inputString.trim(), token),
                              ]);
                            final user = results[0] as User;
                            final coalition = results[1] as Coalition;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(user: user, coalition: coalition),
                                ),
                              );
                            } catch (e) {
                              setState(() => _errorMessage = e.toString()
                                    .replaceAll('Exception: ', ''));
                            } finally {
                              setState(() => _isLoading = false);  // ← ADD THIS
                            }
                          },
                          icon: const Icon(Icons.search), // Added the icon here
                          label: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'SEARCH STUDENT',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                              double.infinity,
                              55,
                            ), // Fills the 400px width
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF00babc),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.1),
                              border: Border.all(
                                color: Colors.redAccent.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    // );
  }
}
