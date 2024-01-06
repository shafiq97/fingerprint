import 'package:fingerprint/login.dart';
import 'package:fingerprint/nfc_page.dart';
import 'package:fingerprint/profile_page.dart';
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
          biometricOnly: true, // Only biometrics are enabled
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (!mounted) return;

      if (authenticated) {
        // Success case
        _resetAuth();
        _showSuccessDialog(); // Show success dialog or navigate to success page
      } else {
        // Biometric authentication failed, navigate to custom PIN screen
        _navigateToPinScreen();
      }
    } on PlatformException catch (e) {
      print("Authentication error: $e");
      // Biometric authentication failed, navigate to custom PIN screen
      _navigateToPinScreen();
    }
  }

  void _resetAuth() {
    setState(() {
      _authAttempts = 0; // Reset attempts after successful authentication
    });
  }

  void _navigateToPinScreen() {
    // Navigate to your custom PIN screen
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => PinEntryScreen(onPinEntered: _validatePin)),
    );
  }

  void _validatePin(String enteredPin) {
    // Implement your logic to validate the entered PIN
    // For now, let's assume the correct PIN is '1234'
    if (enteredPin == '1234') {
      // Correct PIN
      _resetAuth();
      _showSuccessDialog();
    } else {
      // Incorrect PIN
      setState(() {
        _authAttempts++;
        if (_authAttempts >= 3) {
          _showBlockedAccountDialog(); // Show blocked account dialog
          _authAttempts = 0; // Reset for future
        } else {
          // Maybe give feedback about wrong PIN and allow to try again
          _navigateToPinScreen(); // Go back to PIN screen for another attempt
        }
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Payment Success"),
          content: const Text("The payment was successful."),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
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
          title: const Text("Account Blocked"),
          content: const Text(
              "Your account is blocked please go to nearby branch for assistance."),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
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
      appBar: AppBar(title: const Text('Payment')),
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
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
                      _authenticateAndProceed(); // Trigger authentication on button press
                    }
                  },
                  child: const Text('Submit Payment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PinEntryScreen extends StatelessWidget {
  final Function(String) onPinEntered;

  PinEntryScreen({required this.onPinEntered});

  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter PIN')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // You might want to use a more secure text field or a custom PIN entry widget
          TextField(
            controller: _pinController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'PIN',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            maxLength: 4, // Assuming PIN is 4 digits
          ),
          ElevatedButton(
            onPressed: () => onPinEntered(_pinController.text),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
