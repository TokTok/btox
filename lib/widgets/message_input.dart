import 'package:btox/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class MessageInput extends HookWidget {
  final String hintText;
  final String replyingTo;
  final Color buttonColor;
  final void Function() onAdd;
  final void Function(String) onSend;
  final void Function() onTapCloseReply;

  const MessageInput({
    super.key,
    required this.hintText,
    this.replyingTo = '',
    this.buttonColor = Colors.blue,
    required this.onAdd,
    required this.onSend,
    required this.onTapCloseReply,
  });

  @override
  Widget build(BuildContext context) {
    final messageInputController = useTextEditingController();
    final messageInputFocus = useFocusNode();
    final sendMode = useState(false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (replyingTo.isNotEmpty)
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
        if (replyingTo.isNotEmpty) const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('messageField'),
                  controller: messageInputController,
                  focusNode: messageInputFocus,
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 3,
                  onChanged: (value) => sendMode.value = value.isNotEmpty,
                  onSubmitted: (_) => _onSend(
                    messageInputController,
                    messageInputFocus,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintMaxLines: 1,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    fillColor: Theme.of(context).splashColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                color: buttonColor,
                icon: sendMode.value
                    ? const Icon(Icons.send)
                    : const Icon(Icons.add_circle),
                onPressed: () {
                  if (sendMode.value) {
                    _onSend(
                      messageInputController,
                      messageInputFocus,
                    );
                  } else {
                    onAdd();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onSend(
    TextEditingController messageInputController,
    FocusNode messageInputFocus,
  ) {
    final message = messageInputController.text;
    if (message.isNotEmpty) {
      onSend(message);
      messageInputController.text = '';
      messageInputFocus.requestFocus();
    }
  }
}
