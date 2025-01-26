import 'package:btox/db/database.dart';
import 'package:btox/pages/contact_list_page.dart';
import 'package:btox/pages/create_profile_page.dart';
import 'package:btox/pages/select_profile_page.dart';
import 'package:btox/providers/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      home: ref.watch(databaseProvider).when(
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
            data: (db) => StreamBuilder<List<Profile>>(
              stream: db.watchProfiles(),
              builder: (context, snapshot) {
                final profiles = snapshot.data ?? const [];
                if (profiles.isEmpty) {
                  return const CreateProfilePage();
                }

                final activeProfiles =
                    profiles.where((profile) => profile.active).toList();
                if (activeProfiles.isEmpty) {
                  return SelectProfilePage(profiles: profiles);
                }

                return ContactListPage(
                  database: db,
                  profile: activeProfiles.first,
                );
              },
            ),
          ),
    );
  }
}
