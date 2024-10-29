import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../widgets/textfield.dart';
import '../widgets/button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _auth = AuthService();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your email to receive a password reset link",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _email,
              hint: "Enter Email",
              label: "Email",
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Send Email",
              onPressed: () async {
                await _auth.sendPasswordResetLink(_email.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("An email for password reset has been sent to your email")),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }
}
