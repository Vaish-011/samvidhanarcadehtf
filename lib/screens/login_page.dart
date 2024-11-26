import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_account_page.dart';
import '../services/forgot_pass.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  // Navigate to the sign-up screen
  void goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountPage()),
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

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User account not found. Please sign up.")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
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
            Container(
              padding: EdgeInsets.only(top: 150, bottom: 80),
              child: Column(
                children: [
                  SizedBox(height: isSmallScreen ? 80 : 110),
                  _Header(isSmallScreen: isSmallScreen),
                  _InputWrapper(
                    isSmallScreen: isSmallScreen,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onSignIn: _login,
                    goToSignup: goToSignup,
                    isLoading: isLoading,
                  ),
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
  final Function(BuildContext) goToSignup;
  final bool isLoading;

  const _InputWrapper({
    required this.isSmallScreen,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
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
                  );
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
          style: TextStyle(fontSize: isSmallScreen ? 16 : 20,  color: Colors.white),
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
