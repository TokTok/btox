import 'dart:typed_data';

import 'package:sodium/sodium.dart';

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
  Crypto get crypto => throw UnimplementedError();

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
