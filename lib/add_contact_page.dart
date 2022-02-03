import 'package:flutter/material.dart';

import 'strings.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key, required this.onAddContact})
      : super(key: key);

  final Function(String, String) onAddContact;

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _toxIdInputController = TextEditingController();
  final _messageInputController =
      TextEditingController(text: Strings.defaultAddContactMessage);

  void _onAddContact() {
    widget.onAddContact(
        _toxIdInputController.text, _messageInputController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.addContact),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              key: const Key('toxId'),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: Strings.toxId,
              ),
              controller: _toxIdInputController,
              textInputAction: TextInputAction.next,
              autofocus: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: Strings.message,
              ),
              onEditingComplete: () => _onAddContact(),
              controller: _messageInputController,
              textInputAction: TextInputAction.send,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _onAddContact,
                child: const Text(Strings.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
