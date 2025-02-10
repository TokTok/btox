import 'package:btox/api/toxcore/tox.dart';
import 'package:btox/api/toxcore/tox_events.dart';
import 'package:btox/db/database.dart';
import 'package:btox/ffi/tox_library.dart';
import 'package:btox/logger.dart';
import 'package:btox/pages/settings_page.dart';
import 'package:btox/pages/user_profile_page.dart';
import 'package:btox/providers/tox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _logger = Logger(['MainMenu']);

final class MainMenu extends ConsumerWidget {
  final ToxConstants constants;
  final Profile profile;
  final Database database;

  const MainMenu({
    super.key,
    required this.constants,
    required this.profile,
    required this.database,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: ListTile(
            title: Text(
              profile.settings.nickname,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              profile.settings.statusMessage,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.w100,
              ),
            ),
            trailing: ref.watch(toxEventsProvider).when(
                  data: (event) {
                    final online = event is ToxEventSelfConnectionStatus &&
                        event.connectionStatus !=
                            Tox_Connection.TOX_CONNECTION_NONE;
                    return Icon(
                      online ? Icons.online_prediction : Icons.offline_bolt,
                      color: online ? Colors.green : Colors.red,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text('Error: $error'),
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(AppLocalizations.of(context)!.menuProfile),
          onTap: () {
            Navigator.pop(context); // close drawer before navigating away
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StreamBuilder<Profile>(
                  stream: database.watchProfile(profile.id),
                  builder: (context, snapshot) {
                    final profile = snapshot.data;
                    if (profile == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return UserProfilePage(
                      constants: constants,
                      profile: profile,
                      onUpdateProfile: (settings) async {
                        await database.updateProfileSettings(
                            profile.id, settings);
                        _logger.d('Updated profile settings');
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context)!.menuSettings),
          onTap: () {
            Navigator.pop(context); // close drawer before navigating away
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(
                  database: database,
                  profile: profile,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(AppLocalizations.of(context)!.logout),
          onTap: () async {
            Navigator.pop(context); // close drawer before navigating away
            _logger.d('Logging out');
            await database.deactivateProfiles();
          },
        ),
        if (defaultTargetPlatform == TargetPlatform.android)
          ListTile(
            leading: const Icon(Icons.close),
            title: Text(AppLocalizations.of(context)!.menuQuit),
            onTap: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          )
      ],
    );
  }
}
