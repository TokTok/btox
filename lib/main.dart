import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btox/btox_app.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const ProviderScope(child: BtoxApp()));
}
