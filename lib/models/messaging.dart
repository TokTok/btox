import 'dart:convert';
import 'dart:typed_data';

import 'package:btox/db/database.dart';
import 'package:btox/models/crypto.dart';
import 'package:btox/models/id.dart';
import 'package:btox/models/persistence.dart';
import 'package:crypto/crypto.dart';

import 'package:messagepack/messagepack.dart';

// [parent, merge, timestamp, origin, content]
Uint8List encodeMessage(Message? parent, Message? merge, DateTime timestamp,
    PublicKey origin, String content) {
  final Packer packer = Packer();

  packer.packListLength(4);
  if (parent != null) {
    packer.packBinary(parent.sha.bytes);
  } else {
    packer.packNull();
  }

  if (merge != null) {
    packer.packBinary(merge.sha.bytes);
  } else {
    packer.packNull();
  }

  packer.packInt(timestamp.millisecondsSinceEpoch);
  packer.packBinary(origin.bytes);
  packer.packBinary(utf8.encode(content));

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
