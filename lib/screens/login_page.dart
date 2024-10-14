import 'package:flutter/material.dart';
import 'create_account_page.dart'; // Import the CreateAccountPage




class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600; // Adjust threshold as needed





    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of the Scaffold
      body: SingleChildScrollView( // Wrap the content with SingleChildScrollView
        child: Stack(
          children: [
            // Gradient Background
            Container(
              width: double.infinity,
              height: screenSize.height, // Set to full height
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF26A69A), // Bright Teal
                    Color(0xFF4DB6AC), // Mid Bright Teal
                    Color(0xFF80CBC4), // Light Teal
                    Color(0xFFB2DFDB), // Very Light Teal
                    Color(0xFFE0F2F1), // Softest Teal
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
            // Main Content
            Container(
              padding: EdgeInsets.only(top: 60, bottom: 20),
              child: Column(
                children: [
                  SizedBox(height: isSmallScreen ? 80 : 110), // Space above header
                  _Header(isSmallScreen: isSmallScreen), // Pass size flag
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: _InputWrapper(isSmallScreen: isSmallScreen), // Pass size flag
                  ),
                  // White background at the bottom
                  Container(
                    height: 200, // Height of the white area
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class _Header extends StatelessWidget {
  final bool isSmallScreen;

  const _Header({required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: isSmallScreen ? 24 : 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004D40),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: 280,
              decoration: BoxDecoration(
                color: Color(0xFF004D40),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(0.0),
                  topRight: Radius.circular(6.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class _InputWrapper extends StatelessWidget {
  final bool isSmallScreen;

  const _InputWrapper({required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _InputField(
            label: 'Email',
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(0.0),
            ),
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 16),
          _InputField(
            label: 'Password',
            obscureText: true,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(0.0),
            ),
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Add forgot password logic here
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFF004D40),
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountPage()),
                  );
                },
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Color(0xFF004D40),
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF004D40),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(0.0),
                ),
              ),
            ),
            onPressed: () {
              // Add your login logic here
            },
            child: Text(
              'SIGN IN',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            height: 1,
            color: Color(0xFF004D40),
          ),
          const SizedBox(height: 16),
          Text(
            'or',
            style: TextStyle(
              color: Color(0xFF004D40),
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Color(0xFF004D40), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    // Add your Google login logic here
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/google_icon.jpg',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Color(0xFF004D40),
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final BorderRadius borderRadius;
  final bool isSmallScreen;

  const _InputField({
    required this.label,
    this.obscureText = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(30.0)),
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE0F2F1),
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF004D40)),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF80CBC4)),
            borderRadius: borderRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF004D40)),
            borderRadius: borderRadius,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: LoginPage(),
));
