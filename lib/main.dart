import 'package:flutter/material.dart';

import 'app.dart';
import 'db/database.dart';
import 'db/shared.dart';

void main() {
  final Database db = constructDb();
  runApp(App(database: db));
}
