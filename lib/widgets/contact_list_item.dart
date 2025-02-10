import 'package:btox/db/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class ContactListItem extends StatelessWidget {
  final Contact contact;
  final Function(Contact) onTap;

  const ContactListItem({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          contact.name ?? AppLocalizations.of(context)!.defaultContactName),
      subtitle:
          Text(contact.publicKey.toJson(), overflow: TextOverflow.ellipsis),
      onTap: () => onTap(contact),
    );
  }
}
