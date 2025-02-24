import 'package:btox/btox_app.dart';
import 'package:btox/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await initializeService();
  runApp(const ProviderScope(child: BtoxApp()));
}
