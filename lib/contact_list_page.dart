import 'package:flutter/material.dart';

import 'add_contact_page.dart';
import 'chat_page.dart';
import 'contact.dart';
import 'ffi/proxy.dart';
import 'strings.dart';
import 'ffi/toxcore_generated_bindings.dart';
import 'tox.dart';

final ToxFfi toxLib = ToxFfi(loadToxcore());

final int Function() toxVersionMajor = toxLib.tox_version_major;
final int Function() toxVersionMinor = toxLib.tox_version_minor;
final int Function() toxVersionPatch = toxLib.tox_version_patch;

class ContactListItem extends StatelessWidget {
  const ContactListItem({Key? key, required this.contact, required this.onTap})
      : super(key: key);

  final Contact contact;
  final Function(Contact) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          contact.name.isNotEmpty ? contact.name : Strings.defaultContactName),
      subtitle: Text(contact.publicKey, overflow: TextOverflow.ellipsis),
      onTap: () => onTap(contact),
    );
  }
}

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key, required this.title, required this.tox})
      : super(key: key);

  final String title;
  final ToxWrapper tox;

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final _contacts = <Contact>[];

  void _onAddContact(String toxID) {
    widget.tox.addContact(toxID);
    setState(() {
      _contacts.add(Contact(publicKey: toxID.substring(0, toxID.length - 12)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                return ContactListItem(
                  contact: _contacts[index],
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
          ),
          Text(
              '${toxVersionMajor()}.${toxVersionMinor()}.${toxVersionPatch()}'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddContactPage(onAddContact: _onAddContact),
              ),
            ),
        tooltip: Strings.addContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}
