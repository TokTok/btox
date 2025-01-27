import 'package:btox/api/toxcore/tox.dart';
import 'package:btox/db/database.dart';
import 'package:btox/logger.dart';
import 'package:btox/pages/create_profile_page.dart';
import 'package:flutter/material.dart';

const _logger = Logger(['SelectProfilePage']);

final class SelectProfilePage extends StatelessWidget {
  final ToxConstants constants;
  final Database database;
  final List<Profile> profiles;

  const SelectProfilePage({
    super.key,
    required this.constants,
    required this.database,
    required this.profiles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Profile'),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return ListTile(
            title: Text(profile.settings.nickname),
            subtitle: Text(profile.settings.statusMessage),
            onTap: () async {
              _logger.d('Selecting profile: ${profile.id}');
              await database.activateProfile(profile.id);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateProfilePage(
                constants: constants,
                database: database,
                onProfileCreated: (profileId) {
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
