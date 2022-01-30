import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:ffi';

import 'chat_page.dart';
import 'contact.dart';
import 'strings.dart';

final DynamicLibrary toxLib = Platform.isAndroid
    ? DynamicLibrary.open('libtoxcore.so')
    : DynamicLibrary.process();

final int Function() toxVersionMajor = toxLib
    .lookup<NativeFunction<Int32 Function()>>('tox_version_major')
    .asFunction();
final int Function() toxVersionMinor = toxLib
    .lookup<NativeFunction<Int32 Function()>>('tox_version_minor')
    .asFunction();
final int Function() toxVersionPatch = toxLib
    .lookup<NativeFunction<Int32 Function()>>('tox_version_patch')
    .asFunction();

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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
          ),
          Text(
              '${toxVersionMajor()}.${toxVersionMinor()}.${toxVersionPatch()}'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        tooltip: Strings.addContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}
