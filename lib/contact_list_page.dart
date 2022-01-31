import 'package:flutter/material.dart';

import 'chat_page.dart';
import 'contact.dart';

class ContactListItem extends StatelessWidget {
  const ContactListItem({Key? key, required this.contact, required this.onTap})
      : super(key: key);

  final Contact contact;
  final Function(Contact) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.name.isNotEmpty ? contact.name : "Unknown"),
      subtitle: Text(contact.publicKey, overflow: TextOverflow.ellipsis),
      onTap: () => onTap(contact),
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
          return ContactListItem(
            contact: Contact.fake(index),
            onTap: (Contact contact) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(contact: contact),
                ),
              );
            },
          );
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
