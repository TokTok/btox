import 'package:btox/widgets/chat_text_bubble.dart';
import 'package:btox/widgets/chat_text_emoji.dart';
import 'package:flutter/material.dart';
import 'package:unicode/unicode.dart' as unicode;

const double kStateIconBottom = 4;
const double kStateIconRight = 6;
const double kStateIconSize = 18;

/// An emoji is one symbol followed by zero or more modifier symbols.
///
/// Multiple emojis are not an emoji, so we show them as a bubble. This is an
/// overestimate, because it includes things like ℉, but it's good enough for
/// now. Really deciding on whether something is an emoji is complicated:
/// https://tc39.es/proposal-regexp-unicode-sequence-properties/.
bool _isEmoji(String s) {
  final chars = _utf16To32(s.codeUnits);
  if (chars.isEmpty) {
    return false;
  }

  if (unicode.getUnicodeCategory(chars.first) !=
      unicode.UnicodeCategory.otherSymbol) {
    return false;
  }
  for (final char in chars.skip(1)) {
    final category = unicode.getUnicodeCategory(char);
    if (category != unicode.UnicodeCategory.modifierSymbol) {
      return false;
    }
  }
  return true;
}

List<int> _utf16To32(List<int> utf16) {
  final List<int> utf32 = [];
  for (int i = 0; i < utf16.length; i++) {
    if (utf16[i] & 0xF800 == 0xD800) {
      utf32.add(((utf16[i] & 0x3FF) << 10) + (utf16[i + 1] & 0x3FF) + 0x10000);
      i++;
    } else {
      utf32.add(utf16[i]);
    }
  }
  return utf32;
}

enum ChatItemDirection { sent, received }

enum ChatItemState { none, sent, delivered, seen }

final class ChatText extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle textStyle;
  final double bubbleRadius;
  final ChatItemDirection direction;
  final ChatItemState state;
  final EdgeInsets padding;
  final double extraWidth;

  const ChatText({
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
    if (_isEmoji(text)) {
      return ChatTextEmoji(
        stateIcon: stateIcon,
        emoji: text,
        textStyle: textStyle,
      );
    }
    return ChatTextBubble(
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
