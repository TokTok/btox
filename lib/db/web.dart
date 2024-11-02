import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import 'database.dart';

Database constructDb() => Database(
    DatabaseConnection.delayed(Future(() async => (await WasmDatabase.open(
          databaseName: 'db',
          sqlite3Uri: Uri(path: 'sqlite3.wasm'),
          driftWorkerUri: Uri(path: 'drift_worker.js'),
        ))
            .resolvedExecutor)));
