import 'dart:io';

import 'package:btox/db/database.dart';
import 'package:btox/logger.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

const _logger = Logger(['NativeDatabase']);

// https://drift.simonbinder.eu/platforms/encryption/#setup
final _setupSqlCipher = Future<void>(() async {
  await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
  open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
});

Future<Database> constructDb(String databaseKey) async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(path.join(dbFolder.path, 'bTox.sqlite'));
  _logger.d('Database file: ${file.path}');

  await _setupSqlCipher;

  // https://drift.simonbinder.eu/platforms/encryption/#using
  return Database(NativeDatabase(file, setup: (database) {
    // https://drift.simonbinder.eu/platforms/encryption/#important-notice
    final cipherVersion = database.select('PRAGMA cipher_version;');
    assert(cipherVersion.isNotEmpty, 'Failed to get cipher version');
    _logger.d('Encrypted database: ${cipherVersion.first}');

    final escapedKey = databaseKey.replaceAll("'", "''");
    database.execute("PRAGMA key = '$escapedKey';");

    // Recommended option, not enabled by default on SQLCipher
    database.config.doubleQuotedStringLiterals = false;
  }));
}
