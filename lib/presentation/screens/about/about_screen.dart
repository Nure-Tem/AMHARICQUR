import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// About screen — implementation pending.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            '${AppConstants.appName}\n\n'
            'Offline structured Islamic book reader.\n'
            'Implementation in progress.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
