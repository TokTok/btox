import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

final class ChatContextMenu {
  static Future<void> show(
    BuildContext context,
    Offset position, {
    required void Function() onReply,
    required void Function() onForward,
    required void Function() onCopy,
    required void Function() onSelect,
    required void Function() onInfo,
    required void Function() onDelete,
  }) {
    final menu = _build(
      position,
      onReply: onReply,
      onForward: onForward,
      onCopy: onCopy,
      onSelect: onSelect,
      onInfo: onInfo,
      onDelete: onDelete,
    );

    return menu.show<void>(context);
  }

  static ContextMenu _build(
    Offset position, {
    required void Function() onReply,
    required void Function() onForward,
    required void Function() onCopy,
    required void Function() onSelect,
    required void Function() onInfo,
    required void Function() onDelete,
  }) {
    final entries = [
      MenuItem(
        label: 'Reply',
        icon: Icons.reply_outlined,
        onSelected: onReply,
      ),
      MenuItem(
        label: 'Forward',
        icon: Icons.forward_outlined,
        onSelected: onForward,
      ),
      MenuItem(
        label: 'Copy',
        icon: Icons.copy,
        onSelected: onCopy,
      ),
      MenuItem(
        label: 'Select',
        icon: Icons.check_circle_outline,
        onSelected: onSelect,
      ),
      MenuItem(
        label: 'Info',
        icon: Icons.info_outline,
        onSelected: onInfo,
      ),
      MenuItem(
        label: 'Delete',
        icon: Icons.delete_outline,
        onSelected: onDelete,
      ),
    ];

    return ContextMenu(
      entries: entries,
      position: position,
      padding: const EdgeInsets.all(8.0),
    );
  }
}
