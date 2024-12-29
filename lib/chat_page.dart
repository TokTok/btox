import 'package:btox/db/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class ChatPage extends StatefulWidget {
  final Stream<Contact> contact;
  final Stream<List<Message>> messages;
  final void Function(String message) onSendMessage;

  const ChatPage({
    super.key,
    required this.contact,
    required this.messages,
    required this.onSendMessage,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

final class _ChatPageState extends State<ChatPage> {
  final _messageInputFocus = FocusNode();
  final _messageInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Contact>(
      stream: widget.contact,
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data?.name ??
              AppLocalizations.of(context)!.defaultContactName),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: widget.messages,
                builder: ((context, snapshot) {
                  final messages = snapshot.data ?? [];
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = messages.length - index - 1;
                      final message = messages[reversedIndex];
                      return ListTile(
                        title: Text(message.content),
                        subtitle: Text(message.timestamp.toLocal().toString()),
                      );
                    },
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.messageInput,
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
      ),
    );
  }

  void _onSendMessage() {
    widget.onSendMessage(_messageInputController.text);
    _messageInputController.clear();
    _messageInputFocus.requestFocus();
  }
}
