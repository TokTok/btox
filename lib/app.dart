import 'package:flutter/material.dart';

import 'contact_list_page.dart';
import 'strings.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
