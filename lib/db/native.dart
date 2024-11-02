import 'dart:io';

import 'package:btox/db/database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Database constructDb() {
  return Database(
    LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase(file);
    }),
  );
}
