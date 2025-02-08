import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sodium_libs/sodium_libs.dart';

part 'sodium.g.dart';

@riverpod
Future<Sodium> sodium(Ref ref) async {
  return SodiumInit.init();
}

@riverpod
Stream<KeyPair> sodiumKeyPair(Ref ref) async* {
  final sodium = await ref.watch(sodiumProvider.future);
  while (true) {
    yield sodium.crypto.box.keyPair();
  }
}
