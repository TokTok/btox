import 'dart:async';
import 'dart:typed_data';

import 'package:btox/models/bytes.dart';
import 'package:sodium/sodium.dart';

final class FakeSecureKey implements SecureKey {
  final Uint8List _data;

  const FakeSecureKey(this._data);

  @override
  SecureKey copy() {
    return FakeSecureKey(Uint8List.fromList(_data));
  }

  @override
  void dispose() {}

  @override
  Uint8List extractBytes() {
    return _data;
  }

  @override
  int get length => _data.length;

  @override
  FutureOr<T> runUnlockedAsync<T>(SecureCallbackFn<FutureOr<T>> callback,
      {bool writable = false}) {
    return callback(_data);
  }

  @override
  T runUnlockedSync<T>(SecureCallbackFn<T> callback, {bool writable = false}) {
    return callback(_data);
  }

  @override
  int get hashCode => memHash(_data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SecureKey) return false;
    return memEquals(_data, other.extractBytes());
  }

  @override
  String toString() {
    return 'FakeSecureKey(${_data.length} bytes)';
  }
}

final class FakeBox implements Box {
  const FakeBox();

  @override
  DetachedCipherResult detached(
      {required Uint8List message,
      required Uint8List nonce,
      required Uint8List publicKey,
      required SecureKey secretKey}) {
    throw UnimplementedError();
  }

  @override
  Uint8List easy(
      {required Uint8List message,
      required Uint8List nonce,
      required Uint8List publicKey,
      required SecureKey secretKey}) {
    throw UnimplementedError();
  }

  @override
  KeyPair keyPair() {
    final aaaaa = Uint8List.fromList(List.filled(32, 'a'.codeUnitAt(0)));
    final zzzzz = Uint8List.fromList(List.filled(32, 'z'.codeUnitAt(0)));
    return KeyPair(publicKey: aaaaa, secretKey: FakeSecureKey(zzzzz));
  }

  @override
  int get macBytes => throw UnimplementedError();

  @override
  int get nonceBytes => throw UnimplementedError();

  @override
  Uint8List openDetached(
      {required Uint8List cipherText,
      required Uint8List mac,
      required Uint8List nonce,
      required Uint8List publicKey,
      required SecureKey secretKey}) {
    throw UnimplementedError();
  }

  @override
  Uint8List openEasy(
      {required Uint8List cipherText,
      required Uint8List nonce,
      required Uint8List publicKey,
      required SecureKey secretKey}) {
    throw UnimplementedError();
  }

  @override
  PrecalculatedBox precalculate(
      {required Uint8List publicKey, required SecureKey secretKey}) {
    throw UnimplementedError();
  }

  @override
  int get publicKeyBytes => throw UnimplementedError();

  @override
  Uint8List seal({required Uint8List message, required Uint8List publicKey}) {
    throw UnimplementedError();
  }

  @override
  int get sealBytes => throw UnimplementedError();

  @override
  Uint8List sealOpen(
      {required Uint8List cipherText,
      required Uint8List publicKey,
      required SecureKey secretKey}) {
    throw UnimplementedError();
  }

  @override
  int get secretKeyBytes => throw UnimplementedError();

  @override
  int get seedBytes => throw UnimplementedError();

  @override
  KeyPair seedKeyPair(SecureKey seed) {
    throw UnimplementedError();
  }
}

final class FakeCrypto implements Crypto {
  const FakeCrypto();

  @override
  Aead get aeadChaCha20Poly1305 => throw UnimplementedError();

  @override
  Aead get aeadXChaCha20Poly1305IETF => throw UnimplementedError();

  @override
  Auth get auth => throw UnimplementedError();

  @override
  Box get box => const FakeBox();

  @override
  GenericHash get genericHash => throw UnimplementedError();

  @override
  Kdf get kdf => throw UnimplementedError();

  @override
  Kx get kx => throw UnimplementedError();

  @override
  SecretBox get secretBox => throw UnimplementedError();

  @override
  SecretStream get secretStream => throw UnimplementedError();

  @override
  ShortHash get shortHash => throw UnimplementedError();

  @override
  Sign get sign => throw UnimplementedError();
}

final class FakeSodium implements Sodium {
  const FakeSodium();

  @override
  TransferrableKeyPair createTransferrableKeyPair(KeyPair keyPair) {
    throw UnimplementedError();
  }

  @override
  TransferrableSecureKey createTransferrableSecureKey(SecureKey secureKey) {
    throw UnimplementedError();
  }

  @override
  Crypto get crypto => const FakeCrypto();

  @override
  SodiumFactory get isolateFactory => throw UnimplementedError();

  @override
  KeyPair materializeTransferrableKeyPair(
      TransferrableKeyPair transferrableKeyPair) {
    throw UnimplementedError();
  }

  @override
  SecureKey materializeTransferrableSecureKey(
      TransferrableSecureKey transferrableSecureKey) {
    throw UnimplementedError();
  }

  @override
  Uint8List pad(Uint8List buf, int blocksize) {
    throw UnimplementedError();
  }

  @override
  Randombytes get randombytes => throw UnimplementedError();

  @override
  Future<T> runIsolated<T>(SodiumIsolateCallback<T> callback,
      {List<SecureKey> secureKeys = const [],
      List<KeyPair> keyPairs = const []}) {
    throw UnimplementedError();
  }

  @override
  SecureKey secureAlloc(int length) {
    throw UnimplementedError();
  }

  @override
  SecureKey secureCopy(Uint8List data) {
    throw UnimplementedError();
  }

  @override
  SecureKey secureRandom(int length) {
    throw UnimplementedError();
  }

  @override
  Uint8List unpad(Uint8List buf, int blocksize) {
    throw UnimplementedError();
  }

  @override
  SodiumVersion get version => throw UnimplementedError();
}
