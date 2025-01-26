import 'package:btox/models/tox_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class NicknameField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const NicknameField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        AppLocalizations.of(context)!.profileTextFieldNick,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            value ??= '';
            if (value.isEmpty || value.length > ToxConstants.maxNameLength) {
              return AppLocalizations.of(context)!.nickLengthError(
                ToxConstants.maxNameLength,
              );
            }

            return null;
          },
          controller: controller,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
        ),
      ),
    ]);
  }
}
