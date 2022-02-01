import 'package:flutter/material.dart';

import 'contact.dart';
import 'strings.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.contact, required this.onSendMessage})
      : super(key: key);

  final Contact contact;
  final Function(String, String) onSendMessage;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messages = <String>[];
  final _messageInputFocus = FocusNode();
  final _messageInputController = TextEditingController();

  void _onSendMessage() {
    var message = _messageInputController.text;
    widget.onSendMessage(widget.contact.publicKey, message);
    setState(() {
      _messages.add(message);
    });
    _messageInputController.clear();
    _messageInputFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name.isNotEmpty
            ? widget.contact.name
            : Strings.defaultContactName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final reversedIndex = _messages.length - index - 1;
                return ListTile(
                  title: Text('$reversedIndex'),
                  subtitle: Text(_messages[reversedIndex]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: Strings.message.toLowerCase(),
                suffixIcon: IconButton(
                  onPressed: () => _onSendMessage(),
                  icon: const Icon(Icons.send),
                ),
              ),
              onEditingComplete: () => _onSendMessage(),
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
