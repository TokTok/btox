import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:inject_js/inject_js.dart' as js;
import 'package:web_ffi/web_ffi.dart';
import 'package:web_ffi/web_ffi_modules.dart';

import 'toxcore_generated_bindings.dart';

Module? _module;

Future<void> initFfi() async {
  assert(_module == null);
  Memory.init();
  registerOpaqueType<Tox>();
  registerOpaqueType<Tox_Options>();
  await js.importLibrary('asset/libtoxcore.js');
  String path = 'asset/libtoxcore.wasm';
  Uint8List wasmBinaries = (await rootBundle.load(path)).buffer.asUint8List();
  _module = await EmscriptenModule.compile(wasmBinaries, 'libtoxcore');
}

DynamicLibrary loadToxcore() {
  assert(_module != null);
  return DynamicLibrary.fromModule(_module!);
}
