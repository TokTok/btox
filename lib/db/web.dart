import 'package:btox/db/database.dart';
import 'package:drift/wasm.dart';

Future<Database> constructDb(String databaseKey) async {
  final db = await WasmDatabase.open(
    databaseName: 'bTox',
    sqlite3Uri: Uri(path: 'sqlite3.wasm'),
    driftWorkerUri: Uri(path: 'drift_worker.js'),
  );
  return Database(db.resolvedExecutor);
}
