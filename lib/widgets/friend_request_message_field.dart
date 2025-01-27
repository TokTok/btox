import 'package:btox/api/toxcore/tox.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class FriendRequestMessageField extends StatelessWidget {
  final ToxConstants constants;
  final TextEditingController controller;
  final void Function() onEditingComplete;

  const FriendRequestMessageField({
    super.key,
    required this.constants,
    required this.controller,
    required this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.messageEmptyError;
          }
          if (value.length > constants.maxFriendRequestLength) {
            return AppLocalizations.of(context)!.addContactMessageLengthError(
              constants.maxFriendRequestLength,
              value.length,
            );
          }
          return null;
        },
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: AppLocalizations.of(context)!.message,
        ),
        onEditingComplete: onEditingComplete,
        controller: controller,
        textInputAction: TextInputAction.send,
      ),
    );
  }
}
