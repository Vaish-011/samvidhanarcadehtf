import 'package:flutter/material.dart';
import 'home_page.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Rounded card for input fields
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(60), // Custom corner radii
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Full Name Field
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          Divider(),
                          // Email Field
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Divider(),
                          // Password Field
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                          ),
                          Divider(),
                          // Gender Dropdown
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            items: <String>['Male', 'Female', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {},
                          ),
                          Divider(),
                          // Date of Birth Field
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Date of birth',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => HomePage()));
                      },
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white, // Set font color to white
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.teal.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded button
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Already have an account? Sign In text
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Already have an account? Sign in',
                      style: TextStyle(
                        color: Colors.teal.shade800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}