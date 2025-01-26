import 'package:btox/db/database.dart';
import 'package:btox/logger.dart';
import 'package:btox/pages/create_profile_page.dart';
import 'package:btox/providers/database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _logger = Logger(['SelectProfilePage']);

final class SelectProfilePage extends ConsumerWidget {
  final List<Profile> profiles;

  const SelectProfilePage({
    super.key,
    required this.profiles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              final db = await ref.read(databaseProvider.future);
              await db.activateProfile(profile.id);
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
