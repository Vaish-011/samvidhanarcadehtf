import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_account_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
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
                    onSignIn: _signIn,
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

  const _InputWrapper({
    required this.isSmallScreen,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
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
            onSignIn: onSignIn,
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Forgot Password action
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xFF004D40)),
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'or',
                  style: TextStyle(color: Color(0xFF004D40)),
                ),
              ),
              Expanded(child: Divider(color: Color(0xFF004D40), thickness: 1)),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // Google sign-in logic here
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF004D40), width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/google_icon.jpg', width: 24, height: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(color: Color(0xFF004D40), fontSize: 16),
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

class _SignInButton extends StatelessWidget {
  final VoidCallback onSignIn;
  final bool isSmallScreen;

  const _SignInButton({
    required this.onSignIn,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSignIn,
      child: Container(
        width: isSmallScreen ? 180 : 200,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFF004D40),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        child: Center(
          child: Text(
            'SIGN IN',
            style: TextStyle(fontSize: isSmallScreen ? 16 : 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final bool isSmallScreen;

  const _InputField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE0F2F1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(0.0),
        ),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF004D40)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: LoginPage(),
));
