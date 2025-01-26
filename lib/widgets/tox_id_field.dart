import 'package:btox/models/tox_constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class ToxIdField extends StatelessWidget {
  final TextEditingController controller;

  const ToxIdField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        key: const Key('toxId'),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          value ??= '';
          if (value.length != ToxConstants.addressSize * 2) {
            final msg = AppLocalizations.of(context)!
                .toxIdLengthError(ToxConstants.addressSize * 2);
            return '$msg (${value.length}/76)';
          }
          return null;
        },
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: AppLocalizations.of(context)!.toxId,
        ),
        controller: controller,
        textInputAction: TextInputAction.next,
        autofocus: true,
      ),
    );
  }
}
