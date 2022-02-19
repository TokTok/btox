import 'package:drift/drift.dart';

part 'database.g.dart';

class Contacts extends Table {
  TextColumn get publicKey => text()();
  TextColumn get name => text().nullable()();
}

@DriftDatabase(tables: [Contacts])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  // TODO(robinlinden): Remove before first real release.
  @override
  MigrationStrategy get migration => destructiveFallback;

  void addContact(ContactsCompanion entry) => into(contacts).insert(entry);

  Stream<List<Contact>> watchContacts() => select(contacts).watch();

  Stream<Contact> watchContact(String publicKey) =>
      (select(contacts)..where((c) => c.publicKey.equals(publicKey)))
          .watchSingle();
}
