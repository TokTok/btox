import 'package:btox/db/database.dart';
import 'package:drift/wasm.dart';

Future<Database> constructDb() async {
  final db = await WasmDatabase.open(
    databaseName: 'db',
    sqlite3Uri: Uri(path: 'sqlite3.wasm'),
    driftWorkerUri: Uri(path: 'drift_worker.js'),
  );
  return Database(db.resolvedExecutor);
}
