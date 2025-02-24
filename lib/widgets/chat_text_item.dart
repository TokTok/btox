import 'package:btox/widgets/chat_message_bubble.dart';
import 'package:btox/widgets/chat_message_emoji.dart';
import 'package:flutter/material.dart';

const double kStateIconBottom = 4;
const double kStateIconRight = 6;
const double kStateIconSize = 18;
final RegExp kRegexEmoji = RegExp(
    r'^(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])$');

enum ChatItemDirection { sent, received }

enum ChatItemState { none, sent, delivered, seen }

final class ChatTextItem extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle textStyle;
  final double bubbleRadius;
  final ChatItemDirection direction;
  final ChatItemState state;
  final EdgeInsets padding;
  final double extraWidth;

  const ChatTextItem({
    super.key,
    required this.text,
    required this.color,
    required this.textStyle,
    this.bubbleRadius = 20,
    this.direction = ChatItemDirection.sent,
    this.state = ChatItemState.none,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    this.extraWidth = 48,
  });

  @override
  Widget build(BuildContext context) {
    final Positioned? stateIcon = switch (state) {
      ChatItemState.none => null,
      ChatItemState.sent => const Positioned(
          bottom: kStateIconBottom,
          right: kStateIconRight,
          child: Icon(
            Icons.done,
            size: kStateIconSize,
            color: Color(0xFF97AD8E),
          ),
        ),
      ChatItemState.delivered => const Positioned(
          bottom: kStateIconBottom,
          right: kStateIconRight,
          child: Icon(
            Icons.done_all,
            size: kStateIconSize,
            color: Color(0xFF97AD8E),
          ),
        ),
      ChatItemState.seen => const Positioned(
          bottom: kStateIconBottom,
          right: kStateIconRight,
          child: Icon(
            Icons.done_all,
            size: kStateIconSize,
            color: Color(0xFF92DEDA),
          ),
        ),
    };

    return Row(
      mainAxisAlignment: switch (direction) {
        ChatItemDirection.sent => MainAxisAlignment.end,
        ChatItemDirection.received => MainAxisAlignment.start,
      },
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - extraWidth,
          ),
          padding: padding,
          child: _bubble(stateIcon),
        ),
      ],
    );
  }

  Widget _bubble(Positioned? stateIcon) {
    if (kRegexEmoji.hasMatch(text)) {
      return ChatMessageEmoji(
        stateIcon: stateIcon,
        emoji: text,
        textStyle: textStyle,
      );
    }
    return ChatMessageBubble(
      radius: bubbleRadius,
      color: color,
      stateIcon: stateIcon,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
