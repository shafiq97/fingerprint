import 'package:fingerprint/database_helper.dart';
import 'package:fingerprint/main.dart';
import 'package:fingerprint/user_model.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    User? user = (await DatabaseHelper.instance.getUser(widget.username));
    setState(() {
      currentUser = user;
      _usernameController.text = user!.username; // Pre-fill the username
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: currentUser == null
          ? CircularProgressIndicator() // Show loading indicator until user data is loaded
          : ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                if (currentUser!.imageUrl.isNotEmpty)
                  Image.network(currentUser!.imageUrl),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                // ... other fields like password, etc.
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Update Profile'),
                ),
                ElevatedButton(
                  onPressed: _navigateToAuthenticate,
                  child: Text('Authenticate'),
                ),
              ],
            ),
    );
  }

  _navigateToAuthenticate() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MyApp(username: widget.username)));
  }

  Future<void> _updateProfile() async {
    String newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty) {
      // Handle empty username
      print("Username cannot be empty.");
      return;
    }

    if (currentUser != null) {
      // Update the user's username
      currentUser!.username =
          newUsername; // assuming currentUser is of type User and has a username field

      // Update user in the database
      int result = await DatabaseHelper.instance.updateUser(currentUser!);

      // Handle result
      if (result == 1) {
        // Success: Update UI or navigate away
        print("User profile updated successfully.");
        setState(() {
          // Update the state to reflect the new username
        });
        // Optionally navigate back or show a success message
      } else {
        // Error: Show an error message
        print("Failed to update user profile.");
      }
    } else {
      // Error: No current user found
      print("No user found to update.");
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
