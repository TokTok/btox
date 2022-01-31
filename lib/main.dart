import 'package:flutter/material.dart';

import 'app.dart';
import 'ffi/proxy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFfi();
  runApp(const App());
}
