import 'package:flutter/material.dart';

import 'appstate.dart';
import 'strings.dart';

// ignore: must_be_immutable
class UserProfilePage extends StatefulWidget {
  AppState appState;

  UserProfilePage({Key? key, required this.appState}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _statusMessageInputController = TextEditingController();
  final _nickInputController = TextEditingController();
  bool _applyButtonPressed = false;

  void _onUpdateNick() {
    if (_formKey.currentState!.validate()) {
      widget.appState.setNick(_nickInputController.text);
    }
  }

  void _onUpdateStatusMessage() {
    if (_formKey.currentState!.validate()) {
      widget.appState.setUserStatus(_statusMessageInputController.text);
    }
  }

  bool _nickIsValid(String nick) {
    return _nickInputController.text.isNotEmpty &&
        _nickInputController.text.length <= 32;
  }

  bool _statusMessageIsValid(String nick) {
    return _statusMessageInputController.text.length <= 256;
  }

  _onValidate() {
    if (!_nickIsValid(_nickInputController.text) ||
        !_statusMessageIsValid(_statusMessageInputController.text)) {
      return;
    }

    if (widget.appState.getNick() != _nickInputController.text ||
        widget.appState.getUserStatus() != _statusMessageInputController.text) {
      _setApplyButtonState(true);
      _onUpdateNick();
      _onUpdateStatusMessage();
      Navigator.pop(context);
    }
  }

  void _setApplyButtonState(bool pressed) {
    setState(() {
      _applyButtonPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    _nickInputController.text = widget.appState.getNick();
    _statusMessageInputController.text = widget.appState.getUserStatus();

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.menuProfile),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            const Text(
              'Nickname',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                key: const Key('nickName'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  value ??= '';
                  if (!_nickIsValid(value)) {
                    return Strings.nickLengthError;
                  }

                  return null;
                },
                controller: _nickInputController,
                textInputAction: TextInputAction.send,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            const Text(
              'Status message',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                key: const Key('statusMessage'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  value ??= '';
                  if (!_statusMessageIsValid(value)) {
                    return Strings.statusMessageLengthError;
                  }

                  return null;
                },
                controller: _statusMessageInputController,
                textInputAction: TextInputAction.send,
              ),
            ),
            ElevatedButton(
              child: _applyButtonPressed
                  ? const Text('Applied')
                  : const Text('Apply changes'),
              style: ElevatedButton.styleFrom(
                primary: _applyButtonPressed ? Colors.green : Colors.blue,
                onPrimary: Colors.white,
              ),
              onPressed: () => _onValidate(),
            ),
          ],
        ),
      ),
    );
  }
}
