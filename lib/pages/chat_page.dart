import 'package:btox/db/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class ChatPage extends HookWidget {
  final Stream<Contact> contact;
  final Stream<List<Message>> messages;
  final void Function(Message? parent, String message) onSendMessage;

  const ChatPage({
    super.key,
    required this.contact,
    required this.messages,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final messageInputController = useTextEditingController();
    final messageInputFocus = useFocusNode();

    return StreamBuilder<Contact>(
      stream: contact,
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data?.name ??
              AppLocalizations.of(context)!.defaultContactName),
        ),
        body: StreamBuilder<List<Message>>(
          stream: messages,
          builder: ((context, snapshot) {
            final messages = snapshot.data ?? <Message>[];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    key: const Key('messageField'),
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.messageInput,
                      suffixIcon: IconButton(
                        onPressed: () => _onSendMessage(
                          messages.lastOrNull,
                          messageInputController,
                          messageInputFocus,
                        ),
                        icon: const Icon(Icons.send),
                      ),
                    ),
                    onEditingComplete: () => _onSendMessage(
                      messages.lastOrNull,
                      messageInputController,
                      messageInputFocus,
                    ),
                    controller: messageInputController,
                    focusNode: messageInputFocus,
                    textInputAction: TextInputAction.send,
                    autofocus: true,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _onSendMessage(
    Message? parent,
    TextEditingController messageInputController,
    FocusNode messageInputFocus,
  ) {
    onSendMessage(parent, messageInputController.text);
    messageInputController.clear();
    messageInputFocus.requestFocus();
  }
}
