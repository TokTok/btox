import 'package:btox/db/database.dart';
import 'package:btox/l10n/generated/app_localizations.dart';
import 'package:btox/widgets/attachment_selector.dart';
import 'package:btox/widgets/chat_bubble.dart';
import 'package:btox/widgets/circle_identicon.dart';
import 'package:btox/widgets/message_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class ChatPage extends HookWidget {
  final Profile profile;
  final Stream<Contact> contact;
  final Stream<List<Message>> messages;
  final void Function(Message? parent, String message)? onSendMessage;

  const ChatPage({
    super.key,
    required this.profile,
    required this.contact,
    required this.messages,
    this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final replyingTo = useState<Message?>(null);
    final selectingAttachment = useState(false);

    return StreamBuilder<Contact>(
      stream: contact,
      builder: (context, snapshot) {
        final contact = snapshot.data;
        if (contact == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircleIdenticon(publicKey: contact.publicKey),
                ),
                Text(contact.name ??
                    AppLocalizations.of(context)!.defaultContactName)
              ],
            ),
          ),
          body: StreamBuilder<List<Message>>(
            stream: messages,
            builder: ((context, snapshot) {
              final messages = snapshot.data ?? const [];
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = messages.length - index - 1;
                        final message = messages[reversedIndex];
                        return ChatBubble(
                          message: message,
                          isSender: message.author == profile.publicKey,
                          onReply: () {
                            replyingTo.value = message;
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: MessageInput(
                      hintText: AppLocalizations.of(context)!.messageInput,
                      replyingTo: replyingTo.value?.content ?? '',
                      onAdd: () {
                        selectingAttachment.value = !selectingAttachment.value;
                      },
                      onSend: (message) {
                        onSendMessage?.call(messages.lastOrNull, message);
                        replyingTo.value = null;
                      },
                      onTapCloseReply: () {
                        replyingTo.value = null;
                      },
                    ),
                  ),
                  if (selectingAttachment.value)
                    AttachmentSelector(
                      onAdd: () {
                        selectingAttachment.value = false;
                      },
                    ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
