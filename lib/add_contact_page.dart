import 'package:btox/widgets/friend_request_message_field.dart';
import 'package:btox/widgets/tox_id_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class AddContactPage extends StatefulWidget {
  final String selfName;
  final Function(String, String) onAddContact;

  const AddContactPage({
    super.key,
    required this.selfName,
    required this.onAddContact,
  });

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

final class _AddContactPageState extends State<AddContactPage> {
  final _toxIdInputController = TextEditingController();
  final _messageInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_messageInputController.text.isEmpty) {
      _messageInputController.text = AppLocalizations.of(context)!
          .defaultAddContactMessage(widget.selfName);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addContact),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              ToxIdField(controller: _toxIdInputController),
              FriendRequestMessageField(
                controller: _messageInputController,
                onEditingComplete: () => _onAddContact(Form.of(context)),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => _onAddContact(Form.of(context)),
                    child: Text(AppLocalizations.of(context)!.add),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddContact(FormState form) {
    if (form.validate()) {
      widget.onAddContact(
          _toxIdInputController.text, _messageInputController.text);
      Navigator.pop(context);
    }
  }
}
