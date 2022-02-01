import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hex/hex.dart';

import 'app.dart';
import 'ffi/proxy.dart';
import 'ffi/toxcore_generated_bindings.dart';

const nodeHost = 'tox.herokuapp.com';
const nodePort = 443;
const nodePublicKey =
    '348B3819804E258CF76FB0AC2758D169B5904AC0504BAEEFFC360B46B2A12649';

Pointer<Int8> toCString(String str, Allocator alloc) {
  var bytes = ascii.encode(str);
  var cstr = alloc.allocate<Int8>(bytes.length + 1);
  cstr.asTypedList(bytes.length + 1).setAll(0, bytes);
  return cstr;
}

Pointer<Uint8> toCBytes(String str, Allocator alloc) {
  var bytes = HEX.decode(str);
  var cstr = alloc.allocate<Uint8>(bytes.length);
  cstr.asTypedList(bytes.length).setAll(0, bytes);
  return cstr;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFfi();

  final toxLib = loadToxcore();
  final toxFfi = ToxFfi(toxLib);
  final opts = toxFfi.tox_options_new(nullptr);
  toxFfi.tox_options_set_udp_enabled(opts, false);
  toxFfi.tox_options_set_local_discovery_enabled(opts, false);
  toxFfi.tox_options_set_ipv6_enabled(opts, false);
  final tox = toxFfi.tox_new(opts, nullptr);
  // This leaks memory, but this is just a test anyway.
  var err = toxLib.boundMemory.allocate<Int32>(1);
  print(toxFfi.tox_bootstrap(tox, toCString("127.0.0.1", toxLib.boundMemory), 33445,
      toCBytes(nodePublicKey, toxLib.boundMemory), err));
  print(err.value);
  print(toxFfi.tox_add_tcp_relay(tox, toCString(nodeHost, toxLib.boundMemory),
      nodePort, toCBytes(nodePublicKey, toxLib.boundMemory), nullptr));
  Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
    var before = toxFfi.tox_self_get_connection_status(tox);
    toxFfi.tox_iterate(tox, nullptr);
    var after = toxFfi.tox_self_get_connection_status(tox);

    if (before != after) {
      print('Connection status changed from ${before} to ${after}');
    }
  });

  runApp(const App());
}
