import 'package:btox/add_contact_page.dart';
import 'package:btox/btox_state.dart';
import 'package:btox/chat_page.dart';
import 'package:btox/db/database.dart';
import 'package:btox/profile.dart';
import 'package:btox/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

final class ContactListItem extends StatelessWidget {
  final Contact contact;
  final Function(Contact) onTap;

  const ContactListItem({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          contact.name ?? AppLocalizations.of(context)!.defaultContactName),
      subtitle: Text(contact.publicKey, overflow: TextOverflow.ellipsis),
      onTap: () => onTap(contact),
    );
  }
}

final class ContactListPage extends StatelessWidget {
  final Database database;

  const ContactListPage({
    super.key,
    required this.database,
  });

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
                title: StoreConnector<BtoxState, String>(
                  converter: (store) => store.state.nickname,
                  builder: (context, nickname) {
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
                subtitle: StoreConnector<BtoxState, String>(
                  converter: (store) => store.state.statusMessage,
                  builder: (context, String statusMessage) {
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
              title: Text(AppLocalizations.of(context)!.menuProfile),
              onTap: () {
                Navigator.pop(context); // close drawer before navigating away
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreConnector<BtoxState, BtoxState>(
                      converter: (store) => store.state,
                      builder: (context, state) => UserProfilePage(
                        state: state,
                        store: StoreProvider.of(context),
                      ),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.menuSettings),
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
                title: Text(AppLocalizations.of(context)!.menuQuit),
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
        title: Text(AppLocalizations.of(context)!.title),
      ),
      body: StreamBuilder<List<Contact>>(
        stream: database.watchContacts(),
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
                        contact: database.watchContact(contact.id),
                        messages: database.watchMessagesFor(contact.id),
                        onSendMessage: (String message) {
                          database.addMessage(MessagesCompanion.insert(
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
        tooltip: AppLocalizations.of(context)!.addContact,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onAddContact(String toxID, String message) {
    database.addContact(
      ContactsCompanion.insert(
        publicKey: toxID.substring(0, toxID.length - 12),
      ),
    );
  }
}
