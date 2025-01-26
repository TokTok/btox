import 'package:btox/db/database.dart';
import 'package:btox/models/profile_settings.dart';
import 'package:btox/widgets/nickname_field.dart';
import 'package:btox/widgets/status_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class UserProfilePage extends HookWidget {
  final Profile profile;
  final void Function(ProfileSettings) onUpdateProfile;

  const UserProfilePage({
    super.key,
    required this.profile,
    required this.onUpdateProfile,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nickInputController = useTextEditingController(
      text: profile.settings.nickname,
    );
    final statusMessageInputController = useTextEditingController(
      text: profile.settings.statusMessage,
    );
    final applyButtonPressed = useState(false);

    void onValidate() {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (profile.settings.nickname != nickInputController.text ||
          profile.settings.statusMessage != statusMessageInputController.text) {
        applyButtonPressed.value = true;
        onUpdateProfile(
          profile.settings.copyWith(
            nickname: nickInputController.text,
            statusMessage: statusMessageInputController.text,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.menuProfile),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
            ),
            NicknameField(
              controller: nickInputController,
              onChanged: (value) => applyButtonPressed.value = false,
            ),
            const Padding(
              padding: EdgeInsets.all(8),
            ),
            StatusMessageField(
              controller: statusMessageInputController,
              onChanged: (value) => applyButtonPressed.value = false,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    applyButtonPressed.value ? Colors.green : Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => onValidate(),
              child: applyButtonPressed.value
                  ? Text(AppLocalizations.of(context)!.applied)
                  : Text(AppLocalizations.of(context)!.applyChanges),
            ),
          ],
        ),
      ),
    );
  }
}
