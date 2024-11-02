import 'package:drift/drift.dart';

part 'database.g.dart';

class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get publicKey => text()();
  TextColumn get name => text().nullable()();
}

class Messages extends Table {
  IntColumn get contactId => integer().references(Contacts, #id)();
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
}

@DriftDatabase(tables: [Contacts, Messages])
final class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 2;

  // TODO(robinlinden): Remove before first real release.
  @override
  MigrationStrategy get migration => destructiveFallback;

  void addContact(ContactsCompanion entry) => into(contacts).insert(entry);

  Stream<List<Contact>> watchContacts() => select(contacts).watch();

  Stream<Contact> watchContact(int id) =>
      (select(contacts)..where((c) => c.id.equals(id))).watchSingle();

  void addMessage(MessagesCompanion entry) => into(messages).insert(entry);

  Stream<List<Message>> watchMessagesFor(int id) =>
      (select(messages)..where((m) => m.contactId.equals(id))).watch();
}
