import 'dart:io';

import 'package:btox/db/database.dart';
import 'package:btox/logger.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

const _logger = Logger(['NativeDatabase']);

Future<Database> constructDb() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(path.join(dbFolder.path, 'db.sqlite'));
  _logger.d('Database file: ${file.path}');
  return Database(NativeDatabase(file));
}
