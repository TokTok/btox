import 'dart:ffi';
import 'dart:io';

import 'package:btox/ffi/generated/toxcore.ffi.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'dart:ffi';

export 'package:btox/ffi/generated/toxcore.ffi.dart';

part 'tox_library.ffi.g.dart';

@riverpod
Future<ToxLibrary> toxFfi(Ref ref) async {
  return ToxLibrary(
    malloc,
    ToxFfi(Platform.isAndroid
        ? DynamicLibrary.open('libtoxcore.so')
        : DynamicLibrary.process()),
  );
}

typedef CChar = Char;

typedef CEnum = UnsignedInt;

final class ToxLibrary {
  final Allocator allocator;
  final ToxFfi ffi;

  const ToxLibrary(this.allocator, this.ffi);
}
