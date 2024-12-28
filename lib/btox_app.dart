import 'package:btox/btox_state.dart';
import 'package:btox/contact_list_page.dart';
import 'package:btox/db/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class BtoxApp extends StatelessWidget {
  final Database database;
  final Store<BtoxState> store;

  const BtoxApp({
    super.key,
    required this.database,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return StoreProvider<BtoxState>(
      store: store,
      child: MaterialApp(
        title: 'bTox',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: ContactListPage(
          database: database,
        ),
      ),
    );
  }
}
