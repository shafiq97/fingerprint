import 'package:fingerprint/database_helper.dart';
import 'package:fingerprint/user_model.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Ensure non-empty credentials
                if (_usernameController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  // Show an error or alert that both fields are required.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Please enter both username and password")),
                  );
                  return;
                }

                // Fetch user from database
                User? user = await DatabaseHelper.instance
                    .getUser(_usernameController.text);

                // Check user and password
                if (user != null && user.password == _passwordController.text) {
                  // Correct credentials, navigate or unlock the app
                  print("Login successful!");
                  // Navigate to the next screen or dashboard
                } else {
                  // Incorrect credentials, show error
                  print("Incorrect username or password!");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Incorrect username or password!")),
                  );
                }
              },
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
