import 'dart:ffi';
import 'dart:io';

import 'package:btox/ffi/generated/toxcore.native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'package:btox/ffi/generated/toxcore.native.dart' show ToxFfi;

part 'tox_ffi.native.g.dart';

@riverpod
ToxFfi toxFfi(Ref ref) {
  if (Platform.isAndroid) {
    return ToxFfi(DynamicLibrary.open('libtoxcore.so'));
  }
  return ToxFfi(DynamicLibrary.process());
}
