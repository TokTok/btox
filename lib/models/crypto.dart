import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:sodium/sodium.dart';

/// Compares two [Uint8List]s by comparing 8 bytes at a time.
bool _memEquals(Uint8List bytes1, Uint8List bytes2) {
  if (identical(bytes1, bytes2)) {
    return true;
  }

  if (bytes1.lengthInBytes != bytes2.lengthInBytes) {
    return false;
  }

  // Treat the original byte lists as lists of 8-byte words.
  final numWords = bytes1.lengthInBytes ~/ 8;
  final words1 = bytes1.buffer.asUint64List(0, numWords);
  final words2 = bytes2.buffer.asUint64List(0, numWords);

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

final class NospamConverter extends TypeConverter<ToxAddressNospam, int>
    with JsonTypeConverter2<ToxAddressNospam, int, int> {
  const NospamConverter();

  @override
  ToxAddressNospam fromJson(int json) => ToxAddressNospam(json);
  @override
  ToxAddressNospam fromSql(int fromDb) => fromJson(fromDb);
  @override
  int toJson(ToxAddressNospam value) => value.value;
  @override
  int toSql(ToxAddressNospam value) => toJson(value);
}

final class PublicKey extends _CryptoNumber {
  static const kLength = 32;

  PublicKey(super.bytes);

  factory PublicKey.fromJson(String value) {
    return PublicKey(Uint8List.fromList(hex.decode(value)));
  }

  @override
  int get length => PublicKey.kLength;
}

final class PublicKeyConverter extends TypeConverter<PublicKey, String>
    with JsonTypeConverter2<PublicKey, String, String> {
  const PublicKeyConverter();

  @override
  PublicKey fromJson(String json) => PublicKey.fromJson(json);
  @override
  PublicKey fromSql(String fromDb) => fromJson(fromDb);
  @override
  String toJson(PublicKey value) => value.toJson();
  @override
  String toSql(PublicKey value) => toJson(value);
}

final class SecretKey extends _CryptoNumber {
  static const kLength = 32;

  SecretKey(super.bytes);

  factory SecretKey.fromSodium(SecureKey value) {
    return SecretKey(Uint8List.fromList(value.extractBytes()));
  }

  factory SecretKey.fromString(String value) {
    return SecretKey(Uint8List.fromList(hex.decode(value)));
  }

  @override
  int get length => SecretKey.kLength;
}

final class SecretKeyConverter extends TypeConverter<SecretKey, String>
    with JsonTypeConverter2<SecretKey, String, String> {
  const SecretKeyConverter();

  @override
  SecretKey fromJson(String json) => SecretKey.fromString(json);
  @override
  SecretKey fromSql(String fromDb) => fromJson(fromDb);
  @override
  String toJson(SecretKey value) => value.toJson();
  @override
  String toSql(SecretKey value) => toJson(value);
}

final class Sha256 extends _CryptoNumber {
  static const kLength = 32;

  Sha256(super.bytes);

  factory Sha256.fromDigest(Digest digest) {
    return Sha256(Uint8List.fromList(digest.bytes));
  }

  factory Sha256.fromString(String value) {
    return Sha256(Uint8List.fromList(hex.decode(value)));
  }

  @override
  int get length => Sha256.kLength;
}

final class Sha256Converter extends TypeConverter<Sha256, String>
    with JsonTypeConverter2<Sha256, String, String> {
  const Sha256Converter();

  @override
  Sha256 fromJson(String json) => Sha256.fromString(json);
  @override
  Sha256 fromSql(String fromDb) => fromJson(fromDb);
  @override
  String toJson(Sha256 value) => value.toJson();
  @override
  String toSql(Sha256 value) => toJson(value);
}

final class ToxAddress extends _CryptoNumber {
  static const kLength = 38;

  ToxAddress(super.bytes);

  factory ToxAddress.fromString(String value) {
    return ToxAddress(Uint8List.fromList(hex.decode(value)));
  }

  ToxAddressHash get hash => ToxAddressHash(bytes.buffer
      .asByteData()
      .getUint16(PublicKey.kLength + ToxAddressNospam.kLength));

  @override
  int get length => ToxAddress.kLength;
  ToxAddressNospam get nospam =>
      ToxAddressNospam(bytes.buffer.asByteData().getUint32(PublicKey.kLength));
  PublicKey get publicKey =>
      PublicKey(Uint8List.fromList(bytes.sublist(0, PublicKey.kLength)));
}

final class ToxAddressHash {
  static const kLength = 2;

  final int value;

  ToxAddressHash(this.value) {
    if (value < 0 || value > 0xFFFF) {
      throw ArgumentError('Tox address hash must be a 16-bit unsigned integer');
    }
  }
}

final class ToxAddressNospam {
  static const kLength = 4;

  final int value;

  ToxAddressNospam(this.value) {
    if (value < 0 || value > 0xFFFFFFFF) {
      throw ArgumentError('Nospam must be a 32-bit unsigned integer');
    }
  }
}

sealed class _CryptoNumber {
  final Uint8List bytes;

  _CryptoNumber(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError('Invalid $runtimeType length: ${bytes.length}');
    }
  }

  @override
  int get hashCode => bytes.hashCode;

  int get length;

  @override
  bool operator ==(Object other) {
    return other is _CryptoNumber &&
        other.runtimeType == runtimeType &&
        _memEquals(bytes, other.bytes);
  }

  String toJson() {
    return hex.encode(bytes).toUpperCase();
  }

  @override
  String toString() {
    return '$runtimeType(${toJson()})';
  }
}
