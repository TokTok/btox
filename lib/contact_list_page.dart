import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'add_contact_page.dart';
import 'appstate.dart';
import 'chat_page.dart';
import 'contact.dart';
import 'profile.dart';
import 'settings.dart';
import 'strings.dart';

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

// ignore: must_be_immutable
class ContactListPage extends StatefulWidget {
  ContactListPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final appState = AppState();

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final _contacts = <Contact>[];

  void _onAddContact(String toxID, String message) {
    setState(() {
      _contacts.add(Contact(publicKey: toxID.substring(0, toxID.length - 12)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: ListTile(
                title: ValueListenableBuilder(
                  valueListenable: widget.appState.nickName,
                  builder: (context, String nickName, _) {
                    return Text(
                      nickName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
                subtitle: ValueListenableBuilder(
                  valueListenable: widget.appState.userStatus,
                  builder: (context, String userStatus, _) {
                    return Text(
                      userStatus,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                      ),
                    );
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(Strings.menuProfile),
              onTap: () {
                Navigator.pop(context); // close drawer before navigating away
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfilePage(appState: widget.appState),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(Strings.menuSettings),
              onTap: () {
                Navigator.pop(context); // close drawer before navigating away
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            defaultTargetPlatform == TargetPlatform.android
                ? ListTile(
                    leading: const Icon(Icons.close),
                    title: const Text(Strings.menuQuit),
                    onTap: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(widget.title),
      ),
      body: ListView.builder(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddContactPage(onAddContact: _onAddContact),
          ),
        ),
        tooltip: Strings.addContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}
