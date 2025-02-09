import 'dart:convert';

import 'package:btox/api/toxcore/tox.dart' as api;
import 'package:btox/api/toxcore/tox_options.dart' as api;
import 'package:btox/ffi/tox_library.dart';
import 'package:btox/logger.dart';
import 'package:convert/convert.dart';

final _logger = Logger(['Tox']);

U _handleError<T extends Enum, U>(Allocator allocator, T Function(int) toEnum,
    U Function(Pointer<CEnum>) callback) {
  return _scoped(allocator, allocator<CEnum>(), f: (err) {
    final result = callback(err);
    if (err.value != 0) {
      throw api.ApiException(toEnum(err.value));
    }
    return result;
  });
}

U _scoped<T extends NativeType, U>(Allocator allocator, Pointer<T> ptr,
    {required U Function(Pointer<T>) f, void Function(Pointer<T>)? cleanup}) {
  try {
    return f(ptr);
  } finally {
    (cleanup ?? allocator.free)(ptr);
  }
}

final class Toxcore extends api.Tox {
  final ToxLibrary _lib;
  Pointer<Tox> _tox;

  factory Toxcore(ToxLibrary lib, api.ToxOptions options) {
    _logger.d('Creating Tox instance');
    return options.withNative(lib, (options) {
      _logger.d('Tox options: $options');
      final ptr = _handleError(
        lib.allocator,
        Tox_Err_New.fromValue,
        (err) => lib.ffi.tox_new(options, err),
      );
      lib.ffi.tox_events_init(ptr);
      return Toxcore._(lib, ptr);
    });
  }

  Toxcore._(this._lib, this._tox);

  @override
  String get address {
    return _scoped(
        _lib.allocator, _lib.allocator<Uint8>(_lib.ffi.tox_address_size()),
        f: (ptr) {
      _lib.ffi.tox_self_get_address(_tox, ptr);
      return hex.encode(ptr.asTypedList(_lib.ffi.tox_address_size()));
    });
  }

  @override
  bool get isAlive => _tox != nullptr;

  @override
  int get iterationInterval => _lib.ffi.tox_iteration_interval(_tox);

  @override
  set name(String value) {
    value.scopedBytes(_lib.allocator, (value, length) {
      _handleError(
        _lib.allocator,
        Tox_Err_Set_Info.fromValue,
        (err) => _lib.ffi.tox_self_set_name(_tox, value, length, err),
      );
    });
  }

  @override
  set statusMessage(String value) {
    value.scopedBytes(_lib.allocator, (value, length) {
      _handleError(
        _lib.allocator,
        Tox_Err_Set_Info.fromValue,
        (err) => _lib.ffi.tox_self_set_status_message(
          _tox,
          value,
          length,
          err,
        ),
      );
    });
  }

  @override
  void addTcpRelay(String host, int port, String publicKey) {
    _bootstrap(host, port, publicKey, _lib.ffi.tox_add_tcp_relay);
  }

  @override
  void bootstrap(String host, int port, String publicKey) {
    _bootstrap(host, port, publicKey, _lib.ffi.tox_bootstrap);
  }

  @override
  List<String> iterate() {
    final events =
        _handleError(_lib.allocator, Tox_Err_Events_Iterate.fromValue, (err) {
      return _lib.ffi.tox_events_iterate(_tox, true, err);
    });

    return List.generate(_lib.ffi.tox_events_get_size(events), (i) {
      final event = _lib.ffi.tox_events_get(events, i);
      return _lib.ffi.tox_event_get_type(event).name;
    });
  }

  @override
  void kill() {
    _logger.d('Killing Tox instance: $address');
    final ptr = _tox;
    _tox = nullptr;
    _lib.ffi.tox_kill(ptr);
  }

  void _bootstrap(
      String host,
      int port,
      String publicKey,
      bool Function(
        Pointer<Tox> tox,
        Pointer<CChar> host,
        int port,
        Pointer<Uint8> publicKey,
        Pointer<CEnum> error,
      ) f) {
    host.scopedCString(_lib.allocator, (host) {
      publicKey.scopedBytesFromHex(
          _lib.allocator, _lib.ffi.tox_public_key_size(), (publicKey) {
        _handleError(_lib.allocator, Tox_Err_Bootstrap.fromValue,
            (err) => f(_tox, host, port, publicKey, err));
      });
    });
  }
}

extension on api.ToxOptions {
  T withNative<T>(ToxLibrary lib, T Function(Pointer<Tox_Options>) callback) {
    return _scoped(
        lib.allocator,
        _handleError(lib.allocator, Tox_Err_Options_New.fromValue,
            lib.ffi.tox_options_new),
        cleanup: lib.ffi.tox_options_free, f: (options) {
      lib.ffi.tox_options_set_ipv6_enabled(options, ipv6Enabled);
      lib.ffi.tox_options_set_udp_enabled(options, udpEnabled);
      lib.ffi.tox_options_set_local_discovery_enabled(
          options, localDiscoveryEnabled);
      return callback(options);
    });
  }
}

extension on String {
  T scopedBytes<T>(Allocator allocator, T Function(Pointer<Uint8>, int) f) {
    final units = utf8.encode(this);
    return _scoped(allocator, allocator.allocate<Uint8>(units.length),
        f: (ptr) {
      for (var i = 0; i < units.length; i++) {
        ptr[i] = units[i];
      }
      return f(ptr, units.length);
    });
  }

  T scopedBytesFromHex<T>(
      Allocator allocator, int length, T Function(Pointer<Uint8>) f) {
    final intList = hex.decode(this);
    if (intList.length != length) {
      throw Exception('Invalid length: ${intList.length} != $length');
    }
    return _scoped(allocator, allocator.allocate<Uint8>(intList.length),
        f: (ptr) {
      for (var i = 0; i < intList.length; i++) {
        ptr[i] = intList[i];
      }
      return f(ptr);
    });
  }

  T scopedCString<T>(Allocator allocator, T Function(Pointer<CChar>) f) {
    final units = utf8.encode(this);
    final result = allocator<Uint8>(units.length + 1);
    final nativeString = result.asTypedList(units.length + 1);
    nativeString.setAll(0, units);
    nativeString[units.length] = 0;
    return _scoped(allocator, result.cast<CChar>(), f: f);
  }
}
