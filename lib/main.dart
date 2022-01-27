import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
