import 'package:drift/drift.dart';

part 'database.g.dart';

@DriftDatabase()
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
