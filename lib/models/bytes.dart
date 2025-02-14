import 'dart:typed_data';

/// Compares two [Uint8List]s by comparing 4 bytes at a time.
bool memEquals(Uint8List bytes1, Uint8List bytes2) {
  if (identical(bytes1, bytes2)) {
    return true;
  }

  if (bytes1.lengthInBytes != bytes2.lengthInBytes) {
    return false;
  }

  // Treat the original byte lists as lists of 4-byte words.
  final numWords = bytes1.lengthInBytes ~/ 4;
  final words1 = bytes1.buffer.asUint32List(0, numWords);
  final words2 = bytes2.buffer.asUint32List(0, numWords);

  for (var i = 0; i < words1.length; i += 1) {
    if (words1[i] != words2[i]) {
      return false;
    }
  }

  // Compare any remaining bytes.
  for (var i = words1.lengthInBytes; i < bytes1.lengthInBytes; i += 1) {
    if (bytes1[i] != bytes2[i]) {
      return false;
    }
  }

  return true;
}

/// Returns a hash code for the given [Uint8List].
int memHash(Uint8List bytes) {
  // Very slow, but ok for now. Can optimize later.
  return Object.hashAll(bytes);
}
