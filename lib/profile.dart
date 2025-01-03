import 'package:btox/btox_actions.dart';
import 'package:btox/btox_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:redux/redux.dart';

final class UserProfilePage extends StatefulWidget {
  final BtoxState state;
  final Store<BtoxState> store;

  const UserProfilePage({super.key, required this.state, required this.store});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

final class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _statusMessageInputController = TextEditingController();
  final _nickInputController = TextEditingController();
  bool _applyButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.menuProfile),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
            ),
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
                  if (value.isEmpty || value.length > 32) {
                    return AppLocalizations.of(context)!.nickLengthError;
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
            Text(
              AppLocalizations.of(context)!.profileTextFieldUserStatusMessage,
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
                    return AppLocalizations.of(context)!
                        .statusMessageLengthError;
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
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _applyButtonPressed ? Colors.green : Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _onValidate(),
              child: _applyButtonPressed
                  ? Text(AppLocalizations.of(context)!.applied)
                  : Text(AppLocalizations.of(context)!.applyChanges),
            ),
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    _nickInputController.text = widget.state.nickname;
    _statusMessageInputController.text = widget.state.statusMessage;
  }

  _onValidate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.state.nickname != _nickInputController.text ||
        widget.state.statusMessage != _statusMessageInputController.text) {
      _setApplyButtonPressed(true);
      widget.store
          .dispatch(BtoxUpdateNicknameAction(_nickInputController.text));
      widget.store.dispatch(
          BtoxUpdateStatusMessageAction(_statusMessageInputController.text));
    }
  }

  void _setApplyButtonPressed(bool pressed) {
    setState(() {
      _applyButtonPressed = pressed;
    });
  }
}
