import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

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

class Contact {
  final String publicKey;
  final String name;

  Contact({
    required this.publicKey,
    this.name = "",
  });

  factory Contact.fake(int id) {
    var random = Random(id);
    var bytes = List<int>.generate(32, (index) => random.nextInt(255));
    return Contact(
      publicKey: (bytes.map((e) => e.toRadixString(16).toUpperCase())).join(),
      name: "Contact $id",
    );
  }
}

class ContactListItem extends StatelessWidget {
  const ContactListItem({Key? key, required this.contact}) : super(key: key);

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.name.isNotEmpty ? contact.name : "Unknown"),
      subtitle: Text(contact.publicKey, overflow: TextOverflow.ellipsis),
    );
  }
}

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  int _contacts = 1;

  void _addContact() {
    setState(() {
      _contacts++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _contacts,
        itemBuilder: (context, index) {
          return ContactListItem(contact: Contact.fake(index));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        tooltip: 'Add contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
