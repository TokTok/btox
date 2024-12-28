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
  final _formKey = GlobalKey<FormState>();
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
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  key: const Key('toxId'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    value ??= '';
                    if (value.length != 76) {
                      return '${AppLocalizations.of(context)!.toxIdLengthError} (${value.length}/76)';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.toxId,
                  ),
                  controller: _toxIdInputController,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.messageEmptyError;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.message,
                  ),
                  onEditingComplete: () => _onAddContact(),
                  controller: _messageInputController,
                  textInputAction: TextInputAction.send,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _onAddContact,
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

  void _onAddContact() {
    if (_formKey.currentState!.validate()) {
      widget.onAddContact(
          _toxIdInputController.text, _messageInputController.text);
      Navigator.pop(context);
    }
  }
}
