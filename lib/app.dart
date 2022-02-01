import 'package:flutter/material.dart';

import 'contact_list_page.dart';
import 'strings.dart';
import 'tox.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.tox}) : super(key: key);

  final ToxWrapper tox;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListPage(title: Strings.title, tox: tox),
    );
  }
}
