import 'package:flutter/material.dart';

import 'appstate.dart';
import 'strings.dart';

class UserProfilePage extends StatefulWidget {
  final AppState appState;

  const UserProfilePage({Key? key, required this.appState}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _statusMessageInputController = TextEditingController();
  final _nickInputController = TextEditingController();
  bool _applyButtonPressed = false;

  @override
  initState() {
    super.initState();
    _nickInputController.text = widget.appState.nickName.value;
    _statusMessageInputController.text = widget.appState.userStatus.value;
  }

  _onValidate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.appState.nickName.value != _nickInputController.text ||
        widget.appState.userStatus.value !=
            _statusMessageInputController.text) {
      _setApplyButtonPressed(true);
      widget.appState.nickName.value = _nickInputController.text;
      widget.appState.userStatus.value = _statusMessageInputController.text;
    }
  }

  void _setApplyButtonPressed(bool pressed) {
    setState(() {
      _applyButtonPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.menuProfile),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
            ),
            const Text(
              Strings.profileTextFieldNick,
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
                  if (value.isEmpty || value.length > 32) {
                    return Strings.nickLengthError;
                  }

                  return null;
                },
                controller: _nickInputController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  _setApplyButtonPressed(false);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
            ),
            const Text(
              Strings.profileTextFieldUserStatusMessage,
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
                  if (value.length > 256) {
                    return Strings.statusMessageLengthError;
                  }

                  return null;
                },
                controller: _statusMessageInputController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  _setApplyButtonPressed(false);
                },
              ),
            ),
            ElevatedButton(
              child: _applyButtonPressed
                  ? const Text(Strings.applied)
                  : const Text(Strings.applyChanges),
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
