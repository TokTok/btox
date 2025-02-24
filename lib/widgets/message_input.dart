import 'package:btox/l10n/generated/app_localizations.dart';
import 'package:btox/widgets/attachment_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum _SendMode {
  text,
  attachment,
}

final class MessageInput extends HookWidget {
  final String hintText;
  final String replyingTo;
  final Color buttonColor;
  final void Function(String) onSend;
  final void Function() onTapCloseReply;

  const MessageInput({
    super.key,
    required this.hintText,
    this.replyingTo = '',
    this.buttonColor = Colors.blue,
    required this.onSend,
    required this.onTapCloseReply,
  });

  @override
  Widget build(BuildContext context) {
    final messageInputController = useTextEditingController();
    final messageInputFocus = useFocusNode();
    final sendMode = useState(_SendMode.attachment);
    final selectingAttachment = useState(false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (replyingTo.isNotEmpty) ...[
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Row(
              children: [
                Icon(Icons.reply, color: buttonColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      AppLocalizations.of(context)!.re(replyingTo),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onTapCloseReply,
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Divider(height: 1),
          ),
        ],
        Row(
          children: [
            Expanded(
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    selectingAttachment.value = false;
                  }
                },
                child: TextField(
                  key: const Key('messageField'),
                  controller: messageInputController,
                  focusNode: messageInputFocus,
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 3,
                  onChanged: (value) {
                    sendMode.value = value.isNotEmpty
                        ? _SendMode.text
                        : _SendMode.attachment;
                  },
                  onSubmitted: (_) => _onSend(
                    messageInputController,
                    messageInputFocus,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hintText,
                    hintMaxLines: 1,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    fillColor: Theme.of(context).splashColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              color: buttonColor,
              icon: switch (sendMode.value) {
                _SendMode.text => const Icon(Icons.send),
                _SendMode.attachment => const Icon(Icons.add_circle),
              },
              iconSize: 42,
              padding: EdgeInsets.zero,
              onPressed: () {
                switch (sendMode.value) {
                  case _SendMode.text:
                    sendMode.value = _SendMode.attachment;
                    _onSend(
                      messageInputController,
                      messageInputFocus,
                    );
                    break;
                  case _SendMode.attachment:
                    selectingAttachment.value = !selectingAttachment.value;
                    if (selectingAttachment.value) {
                      messageInputFocus.unfocus();
                    } else {
                      messageInputFocus.requestFocus();
                    }
                    break;
                }
              },
            ),
          ],
        ),
        if (selectingAttachment.value)
          AttachmentSelector(
            onSelected: (message) {
              selectingAttachment.value = false;
              _onSend(
                messageInputController,
                messageInputFocus,
                message.toString(),
              );
            },
          ),
      ],
    );
  }

  void _onSend(
    TextEditingController messageInputController,
    FocusNode messageInputFocus, [
    String? message,
  ]) {
    message ??= messageInputController.text;
    if (message.isNotEmpty) {
      onSend(message);
      messageInputController.text = '';
      messageInputFocus.requestFocus();
    }
  }
}
