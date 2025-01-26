import 'package:btox/db/database.dart';
import 'package:btox/logger.dart';
import 'package:btox/models/id.dart';
import 'package:btox/models/persistence.dart';
import 'package:btox/models/profile_settings.dart';
import 'package:btox/providers/database.dart';
import 'package:btox/widgets/nickname_field.dart';
import 'package:btox/widgets/status_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _logger = Logger(['CreateProfilePage']);

final class CreateProfilePage extends HookConsumerWidget {
  final Function(Id<Profiles>)? onProfileCreated;

  const CreateProfilePage({
    super.key,
    this.onProfileCreated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameController = useTextEditingController(
      text: 'Yanciman',
    );
    final statusMessageController = useTextEditingController(
      text: 'Producing works of art in Kannywood',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newProfile),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NicknameField(
              controller: nicknameController,
            ),
            const Padding(
              padding: EdgeInsets.all(8),
            ),
            StatusMessageField(
              controller: statusMessageController,
            ),
            const Padding(
              padding: EdgeInsets.all(8),
            ),
            ElevatedButton(
              onPressed: () async {
                _logger.d('Creating new profile');
                final db = await ref.read(databaseProvider.future);
                final id = await db.addProfile(ProfilesCompanion(
                  active: const Value(true),
                  settings: Value(ProfileSettings(
                    nickname: nicknameController.text,
                    statusMessage: statusMessageController.text,
                  )),
                ));
                _logger.d('Created new profile with ID $id');
                onProfileCreated?.call(id);
              },
              child: Text(AppLocalizations.of(context)!.create),
            ),
          ],
        ),
      ),
    );
  }
}
