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
  final friendPk = PublicKey.fromString(
      '0000000000000000000000000000000000000000000000000000000000000000');

  test('Messages can be added to the database', () async {
    final Database db = Database(NativeDatabase.memory());
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

    expect(firstMsg.sha.toHex(),
        'D956A81987691ABB5368B97B5E0656E1BF65731D699138B9A891C36A632B7209');

    // Happy new year in 2026.
    final secondMsg = await db.getMessage(await db.addMessage(newMessage(
      contactId: contactId,
      parent: firstMsg,
      origin: myToxId.publicKey,
      timestamp: DateTime(2026, 1, 1, 0, 2, 10, 123),
      content: 'Happy new year!',
    )));

    expect(secondMsg.sha.toHex(),
        '99A179417DF7DD59EF3CC02D4B3F031903728DD137F0B1494F346557A1841845');

    await db.close();
  }, tags: ['persistence']);

  test('Two separate histories can be merged', () async {
    final Database db = Database(NativeDatabase.memory());
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

    expect(mergedMessage.sha.toHex(),
        'E894463EAD4313D1A58E682BD087A94028A13A5528BFBBE1DFE2D7F203FEA170');
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
