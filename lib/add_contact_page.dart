import 'package:flutter/material.dart';

import 'strings.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key, required this.onAddContact})
      : super(key: key);

  final Function(String, String) onAddContact;

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _toxIdInputController = TextEditingController();
  final _messageInputController =
      TextEditingController(text: Strings.defaultAddContactMessage);

  void _onAddContact() {
    if (_formKey.currentState!.validate()) {
      widget.onAddContact(
          _toxIdInputController.text, _messageInputController.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.addContact),
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
                      return Strings.toxIdLengthError + ' (${value.length}/76)';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: Strings.toxId,
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
                      return Strings.messageEmptyError;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: Strings.message,
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
                    child: const Text(Strings.add),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
