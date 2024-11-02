import 'package:flutter/material.dart';

import 'contact_list_page.dart';
import 'db/database.dart';
import 'strings.dart';

class App extends StatelessWidget {
  final Database database;

  const App({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListPage(title: Strings.title, database: database),
    );
  }
}
