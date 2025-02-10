import 'package:btox/api/toxcore/tox.dart';
import 'package:btox/api/toxcore/tox_events.dart';
import 'package:btox/api/toxcore/tox_options.dart';
import 'package:btox/ffi/tox_constants.dart' as ffi;
import 'package:btox/ffi/tox_library.dart' as ffi;
import 'package:btox/ffi/toxcore.dart' as ffi;
import 'package:btox/logger.dart';
import 'package:btox/providers/bootstrap_nodes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tox.g.dart';

const _logger = Logger(['ToxProvider']);

@riverpod
Future<Tox> tox(Ref ref) async {
  final options = ToxOptions();
  final tox = ffi.Toxcore(await ref.read(ffi.toxFfiProvider.future), options);
  ref.onDispose(tox.kill);
  _logger.d('Tox instance created: ${tox.address.toUpperCase()}');
  return tox;
}

@riverpod
Future<ToxConstants> toxConstants(Ref ref) async {
  return ffi.toxcoreConstants(await ref.read(ffi.toxFfiProvider.future));
}

@riverpod
Stream<Event> toxEvents(Ref ref) async* {
  final tox = await ref.watch(toxProvider.future);

  final nodes = (await ref.watch(bootstrapNodesProvider.future))
      .nodes
      .where((node) => node.tcpPorts.isNotEmpty)
      .toList();
  _logger.d('Got ${nodes.length} bootstrap nodes; using 8...');
  for (final node in nodes.take(8)) {
    tox.bootstrap(node.ipv4, node.port, node.publicKey);
    tox.addTcpRelay(node.ipv4, node.tcpPorts.first, node.publicKey);
  }

  while (tox.isAlive) {
    for (final event in tox.iterate()) {
      if (event is ToxEventDhtNodesResponse) {
        continue;
      }
      _logger.d('Tox event: $event');
      yield event;
    }
    await Future.delayed(Duration(milliseconds: tox.iterationInterval));
  }
}
