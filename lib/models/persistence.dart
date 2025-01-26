import 'package:btox/models/id.dart';
import 'package:btox/models/profile_settings.dart';
import 'package:drift/drift.dart';

class Contacts extends Table {
  IntColumn get id =>
      integer().autoIncrement().map(const IdConverter<Contacts>())();
  IntColumn get profileId =>
      integer().references(Profiles, #id).map(const IdConverter<Profiles>())();

  TextColumn get name => text().nullable()();
  TextColumn get publicKey => text()();
}

class Messages extends Table {
  IntColumn get id =>
      integer().autoIncrement().map(const IdConverter<Messages>())();
  IntColumn get contactId =>
      integer().references(Contacts, #id).map(const IdConverter<Contacts>())();

  DateTimeColumn get timestamp => dateTime()();
  TextColumn get content => text()();
}

class Profiles extends Table {
  IntColumn get id =>
      integer().autoIncrement().map(const IdConverter<Profiles>())();

  BoolColumn get active => boolean().withDefault(const Constant(false))();
  TextColumn get settings => text().map(const ProfileSettingsConverter())();
}
