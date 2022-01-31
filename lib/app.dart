import 'package:flutter/material.dart';

import 'contact_list_page.dart';

const String title = "bTox (working title)";

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactListPage(title: title),
    );
  }
}
