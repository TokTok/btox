import 'package:flutter/material.dart';

import 'contact_list_page.dart';
import 'db/database.dart';
import 'strings.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.database}) : super(key: key);

  final Database database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactListPage(title: Strings.title),
    );
  }
}
