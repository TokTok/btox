import 'package:btox/db/database.dart';
import 'package:btox/models/crypto.dart';
import 'package:btox/models/id.dart';
import 'package:btox/models/messaging.dart';
import 'package:btox/models/profile_settings.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final mySecretKey = SecretKey.fromString(
      String.fromCharCodes(Iterable.generate(64, (_) => 'F'.codeUnits.first)));
  final myToxId = ToxAddress.fromString(
      String.fromCharCodes(Iterable.generate(76, (_) => '0'.codeUnits.first)));
  final friendPk = PublicKey.fromJson(
      '0000000000000000000000000000000000000000000000000000000000000000');

  testDatabase('Messages can be added to the database', (Database db) async {
    final profileId = await db.addProfile(
      ProfilesCompanion.insert(
        active: Value(true),
        settings: ProfileSettings(
          nickname: 'Yeetman',
          statusMessage: 'Yeeting everyone',
        ),
        secretKey: mySecretKey,
        publicKey: myToxId.publicKey,
        nospam: myToxId.nospam,
      ),
    );

    expect(profileId.value, 1);

    final contactId = await db.addContact(
      ContactsCompanion.insert(
        profileId: profileId,
        name: Value('Neatman'),
        publicKey: friendPk,
      ),
    );

    expect(contactId.value, 1);

    // Happy new year in 2025.
    final firstMsg = await db.getMessage(await db.addMessage(newMessage(
      contactId: contactId,
      parent: null,
      origin: myToxId.publicKey,
      timestamp: DateTime(2025, 1, 1, 0, 2, 10, 123),
      content: 'Happy new year!',
    )));

    expect(firstMsg.sha.toJson(),
        'C64A25D0DE1AC055731897680A9123E35F920270DBF02F3A30614F5BCD7C5039');

    // Happy new year in 2026.
    final secondMsg = await db.getMessage(await db.addMessage(newMessage(
      contactId: contactId,
      parent: firstMsg,
      origin: myToxId.publicKey,
      timestamp: DateTime(2026, 1, 1, 0, 2, 10, 123),
      content: 'Happy new year!',
    )));

    expect(secondMsg.sha.toJson(),
        'C1C848C6AA953FEB9D02CBB80FE8AAECA15820CF83BF354A7454123B661C6B25');
  }, tags: ['persistence']);

  testDatabase('Two separate histories can be merged', (db) async {
    final profileId = await db.addProfile(
      ProfilesCompanion.insert(
        active: Value(true),
        settings: ProfileSettings(
          nickname: 'Yeetman',
          statusMessage: 'Yeeting everyone',
        ),
        secretKey: mySecretKey,
        publicKey: myToxId.publicKey,
        nospam: myToxId.nospam,
      ),
    );

    expect(profileId.value, 1);

    final contactId = await db.addContact(
      ContactsCompanion.insert(
        profileId: profileId,
        name: Value('Neatman'),
        publicKey: friendPk,
      ),
    );

    expect(contactId.value, 1);

    // Happy new year in 2025.
    final myFirstMsg = await db.getMessage(await db.addMessage(newMessage(
      contactId: contactId,
      parent: null,
      origin: myToxId.publicKey,
      // 2 minutes after midnight.
      timestamp: DateTime(2025, 1, 1, 0, 2, 10, 123),
      content: 'Happy new year!',
    )));

    // Friend's happy new year in 2025.
    final friendFirstMsg = await db.getMessage(await db.addMessage(newMessage(
      contactId: contactId,
      parent: null,
      origin: friendPk,
      // 1 minute before my message.
      timestamp: myFirstMsg.timestamp.subtract(const Duration(minutes: 1)),
      content: 'Happy new year!',
    )));

    final mergedMessage = await db.getMessage(await db.addMessage(newMessage(
      contactId: contactId,
      parent: myFirstMsg,
      merged: friendFirstMsg,
      origin: myToxId.publicKey,
      // 1 minute after my message.
      timestamp: myFirstMsg.timestamp.add(const Duration(minutes: 1)),
      content: 'Haha, jinx!',
    )));

    expect(mergedMessage.sha.toJson(),
        'D6281BF3A62840613D354EFFF57016E200E78F76BDB2CCF7D8A3611B826F38D9');
  }, tags: ['persistence']);

  test('Microseconds are ignored in hash calculation', () async {
    final msg1 = newMessage(
      contactId: Id(1),
      parent: null,
      origin: myToxId.publicKey,
      timestamp: DateTime(2025, 1, 1, 0, 2, 10, 123, 456),
      content: 'Happy new year!',
    );

    final msg2 = newMessage(
      contactId: Id(1),
      parent: null,
      origin: myToxId.publicKey,
      timestamp: msg1.timestamp.value.add(const Duration(microseconds: 100)),
      content: 'Happy new year!',
    );

    expect(msg1.sha, msg2.sha);
  }, tags: ['persistence']);

  test('Milliseconds are not ignored in hash calculation', () async {
    final msg1 = newMessage(
      contactId: Id(1),
      parent: null,
      origin: myToxId.publicKey,
      timestamp: DateTime(2025, 1, 1, 0, 2, 10, 123),
      content: 'Happy new year!',
    );

    final msg2 = newMessage(
      contactId: Id(1),
      parent: null,
      origin: myToxId.publicKey,
      timestamp: msg1.timestamp.value.add(const Duration(microseconds: 1000)),
      content: 'Happy new year!',
    );

    expect(msg1.sha, isNot(msg2.sha));
  }, tags: ['persistence']);
}

void testDatabase(
  String description,
  Future<void> Function(Database) body, {
  List<String> tags = const [],
}) {
  test(description, () async {
    final db = Database(NativeDatabase.memory());

    try {
      await body(db);
    } finally {
      await db.close();
    }
  }, tags: tags);
}
