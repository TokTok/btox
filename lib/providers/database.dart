import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:btox/db/database.dart';
import 'package:btox/db/shared.dart';
import 'package:btox/logger.dart';

part 'database.g.dart';

const _logger = Logger(['DatabaseProvider']);

@riverpod
Future<Database> database(Ref ref) async {
  _logger.d('Opening database');
  final db = await constructDb();
  ref.onDispose(() => db.close());
  _logger.d('Database opened: schema version ${db.schemaVersion}');
  return db;
}
