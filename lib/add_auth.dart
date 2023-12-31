import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class AddFingerprintGuidePage extends StatelessWidget {
  const AddFingerprintGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fingerprint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add a Fingerprint',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'To enhance your device security, you can add your fingerprint. Here are the general steps:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text(
              '1. Open your device Settings.\n'
              '2. Scroll to Security or Biometrics and security.\n'
              '3. Tap Fingerprint or Fingerprints.\n'
              '4. Follow the instructions to add your fingerprint.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () =>
                    AppSettings.openAppSettings(type: AppSettingsType.security),
                child: const Text('Open Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
