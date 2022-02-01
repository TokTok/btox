import 'dart:convert';

import 'ffi/proxy.dart';
import 'ffi/toxcore_generated_bindings.dart';

final _toxLib = loadToxcore();
final _toxFfi = ToxFfi(_toxLib);

Pointer<Int8> _toCString(String str, Allocator alloc) {
  var bytes = ascii.encode(str);
  var cstr = alloc.allocate<Int8>(bytes.length);
  cstr.asTypedList(bytes.length).setAll(0, bytes);
  return cstr;
}

Pointer<Uint8> _toCBytes(String str, Allocator alloc) {
  var bytes = ascii.encode(str);
  var cstr = alloc.allocate<Uint8>(bytes.length);
  cstr.asTypedList(bytes.length).setAll(0, bytes);
  return cstr;
}

class ToxWrapper {
  final Pointer<Tox> _tox;

  ToxWrapper._fromFfi(Pointer<Tox> tox) : _tox = tox;

  factory ToxWrapper.create({
    bool udpEnabled = true,
    bool localDiscoveryEnabled = true,
  }) {
    final options = _toxFfi.tox_options_new(nullptr);
    _toxFfi.tox_options_set_udp_enabled(options, udpEnabled);
    _toxFfi.tox_options_set_local_discovery_enabled(
        options, localDiscoveryEnabled);

    final tox = _toxFfi.tox_new(options, nullptr);
    _toxFfi.tox_options_free(options);
    return ToxWrapper._fromFfi(tox);
  }

  void bootstrap(String host, int port, String publicKey) {
    var hostPtr = _toCString(host, _toxLib.boundMemory);
    var pkPtr = _toCBytes(publicKey, _toxLib.boundMemory);
    _toxFfi.tox_bootstrap(_tox, hostPtr, port, pkPtr, nullptr);
    _toxLib.boundMemory.free(pkPtr);
    _toxLib.boundMemory.free(hostPtr);
  }

  void addTcpRelay(String host, int port, String publicKey) {
    var hostPtr = _toCString(host, _toxLib.boundMemory);
    var pkPtr = _toCBytes(publicKey, _toxLib.boundMemory);
    _toxFfi.tox_add_tcp_relay(_tox, hostPtr, port, pkPtr, nullptr);
    _toxLib.boundMemory.free(pkPtr);
    _toxLib.boundMemory.free(hostPtr);
  }

  void iterate() {
    _toxFfi.tox_iterate(_tox, nullptr);
  }

  int get selfConnectionStatus => _toxFfi.tox_self_get_connection_status(_tox);

  void addContact(String address) {
    var messagePtr = _toCString('bTox!', _toxLib.boundMemory);
    var addressPtr = _toCBytes(address, _toxLib.boundMemory);
    _toxFfi.tox_friend_add(_tox, addressPtr, messagePtr.cast(), 5, nullptr);
    _toxLib.boundMemory.free(addressPtr);
    _toxLib.boundMemory.free(messagePtr);
  }
}
