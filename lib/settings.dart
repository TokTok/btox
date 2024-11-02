import 'package:btox/strings.dart';
import 'package:flutter/material.dart';

final class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.menuSettings),
      ),
    );
  }
}
