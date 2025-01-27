import 'package:btox/api/toxcore/tox.dart';
import 'package:btox/widgets/friend_request_message_field.dart';
import 'package:btox/widgets/tox_id_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class AddContactPage extends HookWidget {
  final ToxConstants constants;
  final String selfName;
  final Function(String, String) onAddContact;

  const AddContactPage({
    super.key,
    required this.constants,
    required this.selfName,
    required this.onAddContact,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final toxIdInputController = useTextEditingController();
    final messageInputController = useTextEditingController(
      text: AppLocalizations.of(context)!.defaultAddContactMessage(selfName),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addContact),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ToxIdField(
                constants: constants,
                controller: toxIdInputController,
              ),
              FriendRequestMessageField(
                constants: constants,
                controller: messageInputController,
                onEditingComplete: () => _onAddContact(
                  context,
                  formKey.currentState!,
                  toxIdInputController.text,
                  messageInputController.text,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => _onAddContact(
                      context,
                      formKey.currentState!,
                      toxIdInputController.text,
                      messageInputController.text,
                    ),
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

  void _onAddContact(
      BuildContext context, FormState form, String toxId, String message) {
    if (form.validate()) {
      onAddContact(toxId, message);
      Navigator.pop(context);
    }
  }
}
