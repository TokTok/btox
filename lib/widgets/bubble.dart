import 'package:flutter/material.dart';

const double kStateIconBottom = 4;
const double kStateIconRight = 6;
const double kStateIconSize = 18;

final class Bubble extends StatelessWidget {
  final String text;
  final Color color;
  final double bubbleRadius;
  final BubbleDirection direction;
  final BubbleState state;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final double extraWidth;

  const Bubble({
    super.key,
    required this.text,
    required this.color,
    this.bubbleRadius = 16,
    this.direction = BubbleDirection.sent,
    this.state = BubbleState.none,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    this.extraWidth = 48,
  });

  @override
  Widget build(BuildContext context) {
    final Positioned? stateIcon = switch (state) {
      BubbleState.none => null,
      BubbleState.sent => const Positioned(
          bottom: kStateIconBottom,
          right: kStateIconRight,
          child: Icon(
            Icons.done,
            size: kStateIconSize,
            color: Color(0xFF97AD8E),
          ),
        ),
      BubbleState.delivered => const Positioned(
          bottom: kStateIconBottom,
          right: kStateIconRight,
          child: Icon(
            Icons.done_all,
            size: kStateIconSize,
            color: Color(0xFF97AD8E),
          ),
        ),
      BubbleState.seen => const Positioned(
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
        BubbleDirection.sent => MainAxisAlignment.end,
        BubbleDirection.received => MainAxisAlignment.start,
      },
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - extraWidth,
          ),
          padding: padding,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(bubbleRadius)),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: stateIcon != null
                      ? EdgeInsets.fromLTRB(12, 6, 28, 6)
                      : EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Text(text, style: textStyle),
                ),
                if (stateIcon != null) stateIcon,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum BubbleDirection { sent, received }

enum BubbleState { none, sent, delivered, seen }
