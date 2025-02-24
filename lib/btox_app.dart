import 'package:btox/api/toxcore/tox.dart';
import 'package:btox/db/database.dart';
import 'package:btox/l10n/generated/app_localizations.dart';
import 'package:btox/pages/contact_list_page.dart';
import 'package:btox/pages/create_profile_page.dart';
import 'package:btox/pages/select_profile_page.dart';
import 'package:btox/providers/database.dart';
import 'package:btox/providers/sodium.dart';
import 'package:btox/providers/tox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sodium/sodium.dart';

part 'btox_app.g.dart';

@riverpod
Future<(Database, Sodium, ToxConstants)> appInit(Ref ref) async {
  return (
    await ref.watch(databaseProvider.future),
    await ref.watch(sodiumProvider.future),
    await ref.watch(toxConstantsProvider.future),
  );
}

final class BtoxApp extends ConsumerWidget {
  const BtoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'bTox',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: _appContent(ref),
    );
  }

  Widget _appContent(WidgetRef ref) {
    return ref.watch(appInitProvider).when(
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => Scaffold(
            body: Center(
              child: Text('Error: $error'),
            ),
          ),
          data: (init) {
            final (database, sodium, constants) = init;
            return StreamBuilder<List<Profile>>(
              stream: database.watchProfiles(),
              builder: (context, snapshot) {
                final profiles = snapshot.data ?? const [];
                if (profiles.isEmpty) {
                  return CreateProfilePage(
                    constants: constants,
                    sodium: sodium,
                    database: database,
                  );
                }

                final activeProfiles =
                    profiles.where((profile) => profile.active);
                if (activeProfiles.isEmpty) {
                  return SelectProfilePage(
                    constants: constants,
                    sodium: sodium,
                    database: database,
                    profiles: profiles,
                  );
                }

                return ContactListPage(
                  constants: constants,
                  database: database,
                  profile: activeProfiles.first,
                );
              },
            );
          },
        );
  }
}
