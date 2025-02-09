import 'dart:convert';
import 'dart:typed_data';

import 'package:btox/db/database.dart';
import 'package:btox/models/crypto.dart';
import 'package:btox/models/id.dart';
import 'package:btox/models/persistence.dart';
import 'package:btox/packets/messagepack.dart';
import 'package:crypto/crypto.dart';

// [parent, merge, timestamp, origin, content]
Uint8List encodeMessage(Message? parent, Message? merge, DateTime timestamp,
    PublicKey origin, String content) {
  final Packer packer = Packer();

  packer
    ..packListLength(5)
    ..packBinary(parent?.sha.bytes)
    ..packBinary(merge?.sha.bytes)
    ..packInt(timestamp.millisecondsSinceEpoch)
    ..packBinary(origin.bytes)
    ..packBinary(utf8.encode(content));

  return packer.takeBytes();
}

MessagesCompanion newMessage({
  required Id<Contacts> contactId,
  required Message? parent,
  Message? merged,
  required PublicKey origin,
  required DateTime timestamp,
  required String content,
}) {
  return MessagesCompanion.insert(
    contactId: contactId,
    parent: Value.absentIfNull(parent?.id),
    origin: origin,
    timestamp: timestamp,
    content: content,
    sha: Sha256.fromDigest(
      sha256.convert(encodeMessage(parent, merged, timestamp, origin, content)),
    ),
  );
}
