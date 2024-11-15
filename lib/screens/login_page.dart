import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'create_account_page.dart';
import 'home_page.dart';
import '../services/forgot_pass.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  // Navigate to the sign-up screen
  void goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountPage()), // Removed const
    );
  }

  // Handle login with email and password
  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Check if the user is logged in successfully
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Removed const
        );
      } else {
        // User account not found, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User account not found. Please sign up.")),
        );
      }
    } catch (e) {
      print("Error: $e"); // Logging error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Disconnect any previous Google Sign-In session to ensure the user is prompted for an account
      await _googleSignIn.disconnect(); // Disconnect the previous session (if any)
      await _googleSignIn.signOut();     // Sign out any previously signed-in account

      // Start the Google Sign-In process (this will trigger the account picker)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in process
      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return; // User canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in the user with the credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Navigate to home if the user is logged in
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
        );
      } else {
        // If there is any issue with Google sign-in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred during Google sign-in. Please try again.")),
        );
      }
    } catch (e) {
      print("Error during Google login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred during Google sign-in. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Gradient Background
            Container(
              width: double.infinity,
              height: screenSize.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF26A69A),
                    Color(0xFF4DB6AC),
                    Color(0xFF80CBC4),
                    Color(0xFFB2DFDB),
                    Color(0xFFE0F2F1),
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
            // Main Content
            Container(
              padding: EdgeInsets.only(top: 80, bottom: 20),
              child: Column(
                children: [
                  SizedBox(height: isSmallScreen ? 80 : 110),
                  _Header(isSmallScreen: isSmallScreen),
                  _InputWrapper(
                    isSmallScreen: isSmallScreen,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onSignIn: _login,
                    isLoading: isLoading,
                    onGoogleSignIn: _loginWithGoogle,
                    goToSignup: goToSignup,
                  ),
                  // Add white bottom space as background
                  Container(
                    height: 150,
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
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignIn;
  final VoidCallback onGoogleSignIn;
  final Function(BuildContext) goToSignup;
  final bool isLoading;

  const _InputWrapper({
    required this.isSmallScreen,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.onGoogleSignIn,
    required this.goToSignup,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _InputField(
            controller: emailController,
            label: 'Email',
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 12),
          _InputField(
            controller: passwordController,
            label: 'Password',
            obscureText: true,
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 20),
          _SignInButton(
            onSignIn: isLoading ? null : onSignIn,
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );// Forgot Password action
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xFF004D40)),
                ),
              ),
              TextButton(
                onPressed: () => goToSignup(context),
                child: Text(
                  'Create Account',
                  style: TextStyle(color: Color(0xFF004D40)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Divider(color: Color(0xFF004D40), thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("OR"),
              ),
              Expanded(child: Divider(color: Color(0xFF004D40), thickness: 1)),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: isLoading ? null : onGoogleSignIn,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFF004D40)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/google_icon.jpg', height: 20), // Ensure the asset exists
                  const SizedBox(width: 10),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(
                      color: Color(0xFF004D40),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool isSmallScreen;

  const _InputField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      style: TextStyle(fontSize: isSmallScreen ? 16 : 20),
    );
  }
}

class _SignInButton extends StatelessWidget {
  final VoidCallback? onSignIn;
  final bool isSmallScreen;

  const _SignInButton({
    required this.onSignIn,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSignIn,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Text(
          'Sign In',
          style: TextStyle(fontSize: isSmallScreen ? 16 : 20),
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF004D40)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
