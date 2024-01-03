import 'package:fingerprint/database_helper.dart';
import 'package:fingerprint/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sqflite/sqflite.dart';
//... other imports ...

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              name: "username",
              decoration: const InputDecoration(
                labelText: "Username",
              ),
            ),
            FormBuilderTextField(
              name: "password",
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                _formKey.currentState?.save();
                if (_formKey.currentState?.validate() == true) {
                  var data = _formKey.currentState?.value;
                  Database db = await DatabaseHelper.instance.database;
                  await db.insert(
                    'users',
                    {
                      'username': data?['username'],
                      'password': data?['password']
                    },
                    conflictAlgorithm: ConflictAlgorithm.replace,
                  );
                  print("User registered: ${data?['username']}");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              child: const Text("Register"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the LoginPage
                Navigator.of(context)
                    .pop(); // If RegisterPage is on top of LoginPage
                // or
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginPage()),
                // ); // If LoginPage is not in the stack
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey, // Set a different color to distinguish
              ),
              child: const Text("Login instead"),
            )
          ],
        ),
      ),
    );
  }
}
