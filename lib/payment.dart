import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  int _authAttempts = 0; // Counter for authentication attempts

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _authenticateAndProceed() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to complete the transaction',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true, // Display error dialogs
          stickyAuth: true, // Keep authentication session alive
        ),
      );

      if (!mounted) return;

      if (authenticated) {
        setState(() {
          _authAttempts = 0; // Reset attempts after successful authentication
          print(
              'Authenticated! Processing payment of ${_amountController.text}');
          _showSuccessDialog(); // Show success dialog or navigate to success page
        });
      } else {
        _handleAuthenticationFailure();
      }
    } on PlatformException catch (e) {
      print("Authentication error: $e");
      _handleAuthenticationFailure();
    }
  }

  void _handleAuthenticationFailure() {
    setState(() {
      _authAttempts++; // Increment the counter for every failed attempt
      print("Authentication failed $_authAttempts time(s)");
      if (_authAttempts >= 3) {
        // If failed 3 times
        _showBlockedAccountDialog(); // Show blocked account dialog
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Payment Success"),
          content: Text("The payment was successful."),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showBlockedAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Account Blocked"),
          content: Text(
              "Too many failed attempts. Please contact admin to proceed."),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Enter amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _authenticateAndProceed(); // Trigger fingerprint authentication on button press
                    }
                  },
                  child: Text('Submit Payment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
