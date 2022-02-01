import 'package:flutter/material.dart';

import 'strings.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key, required this.onAddContact})
      : super(key: key);

  final Function(String) onAddContact;

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _messageInputFocus = FocusNode();
  final _messageInputController = TextEditingController();

  void _onAddContact() {
    widget.onAddContact(_messageInputController.text);
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
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: Strings.toxId,
                suffixIcon: IconButton(
                  onPressed: () => _onAddContact(),
                  icon: const Icon(Icons.send),
                ),
              ),
              onEditingComplete: () => _onAddContact(),
              controller: _messageInputController,
              focusNode: _messageInputFocus,
              textInputAction: TextInputAction.send,
              autofocus: true,
            ),
          ),
        ],
      ),
    );
  }
}
