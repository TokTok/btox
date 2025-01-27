import 'dart:convert';
import 'dart:ffi';

import 'package:btox/api/toxcore/tox.dart' as api;
import 'package:btox/api/toxcore/tox_options.dart' as api;
import 'package:btox/ffi/generated/toxcore.native.dart';
import 'package:btox/logger.dart';
import 'package:convert/convert.dart';
import 'package:ffi/ffi.dart';

final _logger = Logger(['Tox']);

U _handleError<T extends Enum, U>(
    T Function(int) toEnum, U Function(Pointer<UnsignedInt>) callback) {
  return _scoped(malloc<UnsignedInt>(), f: (err) {
    final result = callback(err);
    if (err.value != 0) {
      throw api.ApiException(toEnum(err.value));
    }
    return result;
  });
}

U _scoped<T extends NativeType, U>(Pointer<T> ptr,
    {required U Function(Pointer<T>) f, void Function(Pointer<T>)? cleanup}) {
  try {
    return f(ptr);
  } finally {
    (cleanup ?? malloc.free)(ptr);
  }
}

final class Toxcore extends api.Tox {
  final ToxFfi _ffi;
  Pointer<Tox> _tox;

  factory Toxcore(ToxFfi ffi, api.ToxOptions options) {
    _logger.d('Creating Tox instance');
    return options.withNative(ffi, (options) {
      _logger.d('Tox options: $options');
      final ptr = _handleError(
        Tox_Err_New.fromValue,
        (err) => ffi.tox_new(options, err),
      );
      ffi.tox_events_init(ptr);
      return Toxcore._(ffi, ptr);
    });
  }

  Toxcore._(this._ffi, this._tox);

  @override
  String get address {
    return _scoped(malloc<Uint8>(_ffi.tox_address_size()), f: (ptr) {
      _ffi.tox_self_get_address(_tox, ptr);
      return hex.encode(ptr.asTypedList(_ffi.tox_address_size()));
    });
  }

  @override
  bool get isAlive => _tox != nullptr;

  @override
  int get iterationInterval => _ffi.tox_iteration_interval(_tox);

  @override
  set name(String value) {
    value.scopedBytes((value, length) {
      _handleError(
        Tox_Err_Set_Info.fromValue,
        (err) => _ffi.tox_self_set_name(_tox, value, length, err),
      );
    });
  }

  @override
  set statusMessage(String value) {
    value.scopedBytes((value, length) {
      _handleError(
        Tox_Err_Set_Info.fromValue,
        (err) => _ffi.tox_self_set_status_message(
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
    _bootstrap(host, port, publicKey, _ffi.tox_add_tcp_relay);
  }

  @override
  void bootstrap(String host, int port, String publicKey) {
    _bootstrap(host, port, publicKey, _ffi.tox_bootstrap);
  }

  @override
  List<String> iterate() {
    final events = _handleError(Tox_Err_Events_Iterate.fromValue, (err) {
      return _ffi.tox_events_iterate(_tox, true, err);
    });

    return List.generate(_ffi.tox_events_get_size(events), (i) {
      final event = _ffi.tox_events_get(events, i);
      return _ffi.tox_event_get_type(event).name;
    });
  }

  @override
  void kill() {
    _logger.d('Killing Tox instance: $address');
    final ptr = _tox;
    _tox = nullptr;
    _ffi.tox_kill(ptr);
  }

  void _bootstrap(
      String host,
      int port,
      String publicKey,
      bool Function(
        Pointer<Tox> tox,
        Pointer<Char> host,
        int port,
        Pointer<Uint8> publicKey,
        Pointer<UnsignedInt> error,
      ) f) {
    host.scopedCString((host) {
      publicKey.scopedBytesFromHex(_ffi.tox_public_key_size(), (publicKey) {
        _handleError(Tox_Err_Bootstrap.fromValue,
            (err) => f(_tox, host, port, publicKey, err));
      });
    });
  }
}

extension on api.ToxOptions {
  T withNative<T>(ToxFfi ffi, T Function(Pointer<Tox_Options>) callback) {
    return _scoped(
        _handleError(Tox_Err_Options_New.fromValue, ffi.tox_options_new),
        cleanup: ffi.tox_options_free, f: (options) {
      ffi.tox_options_set_ipv6_enabled(options, ipv6Enabled);
      ffi.tox_options_set_udp_enabled(options, udpEnabled);
      ffi.tox_options_set_local_discovery_enabled(
          options, localDiscoveryEnabled);
      return callback(options);
    });
  }
}

extension on String {
  T scopedBytes<T>(T Function(Pointer<Uint8>, int) f) {
    final units = utf8.encode(this);
    return _scoped(malloc<Uint8>(units.length), f: (ptr) {
      for (var i = 0; i < units.length; i++) {
        ptr[i] = units[i];
      }
      return f(ptr, units.length);
    });
  }

  T scopedBytesFromHex<T>(int length, T Function(Pointer<Uint8>) f) {
    final intList = hex.decode(this);
    if (intList.length != length) {
      throw Exception('Invalid length: ${intList.length} != $length');
    }
    return _scoped(malloc<Uint8>(intList.length), f: (ptr) {
      for (var i = 0; i < intList.length; i++) {
        ptr[i] = intList[i];
      }
      return f(ptr);
    });
  }

  T scopedCString<T>(T Function(Pointer<Char>) f) {
    return _scoped(toNativeUtf8().cast<Char>(), f: f);
  }
}
