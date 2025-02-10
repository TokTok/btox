import 'package:btox/api/toxcore/tox_events.dart';
import 'package:btox/db/database.dart';
import 'package:btox/ffi/toxcore.dart';
import 'package:btox/providers/tox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class ConnectionStatusIcon extends ConsumerWidget {
  final Profile profile;

  const ConnectionStatusIcon({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(toxEventsProvider(profile.secretKey, profile.nospam)).when(
          data: (event) {
            final online = event is ToxEventSelfConnectionStatus &&
                event.connectionStatus != Tox_Connection.TOX_CONNECTION_NONE;
            return Icon(
              online ? Icons.online_prediction : Icons.offline_bolt_outlined,
              color: online ? Colors.green : Colors.red,
            );
          },
          loading: () => const Icon(
            Icons.offline_bolt_outlined,
            color: Colors.red,
          ),
          error: (error, _) => Text('Error: $error'),
        );
  }
}
