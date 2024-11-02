import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'add_contact_page.dart';
import 'app_state.dart';
import 'chat_page.dart';
import 'db/database.dart';
import 'profile.dart';
import 'settings.dart';
import 'strings.dart';

class ContactListItem extends StatelessWidget {
  const ContactListItem(
      {super.key, required this.contact, required this.onTap});

  final Contact contact;
  final Function(Contact) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.name ?? Strings.defaultContactName),
      subtitle: Text(contact.publicKey, overflow: TextOverflow.ellipsis),
      onTap: () => onTap(contact),
    );
  }
}

class ContactListPage extends StatefulWidget {
  ContactListPage({super.key, required this.title, required this.database});

  final String title;
  final Database database;
  final appState = AppState();

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  void _onAddContact(String toxID, String message) {
    widget.database.addContact(
      ContactsCompanion.insert(
        publicKey: toxID.substring(0, toxID.length - 12),
      ),
    );
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
                  valueListenable: widget.appState.nickname,
                  builder: (context, String nickname, _) {
                    return Text(
                      nickname,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
                subtitle: ValueListenableBuilder(
                  valueListenable: widget.appState.statusMessage,
                  builder: (context, String statusMessage, _) {
                    return Text(
                      statusMessage,
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
            if (defaultTargetPlatform == TargetPlatform.android)
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text(Strings.menuQuit),
                onTap: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              )
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
      body: StreamBuilder<List<Contact>>(
        stream: widget.database.watchContacts(),
        builder: ((context, snapshot) {
          final contacts = snapshot.data ?? [];

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return ContactListItem(
                contact: contacts[index],
                onTap: (Contact contact) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        contact: widget.database.watchContact(contact.id),
                        messages: widget.database.watchMessagesFor(contact.id),
                        onSendMessage: (String message) {
                          widget.database.addMessage(MessagesCompanion.insert(
                            contactId: contact.id,
                            content: message,
                            timestamp: DateTime.now().toUtc(),
                          ));
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
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
