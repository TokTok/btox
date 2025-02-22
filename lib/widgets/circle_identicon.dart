import 'package:btox/logger.dart';
import 'package:btox/models/crypto.dart';
import 'package:btox/models/identicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _logger = Logger(['CircleIdenticon']);

final class CircleIdenticon extends ConsumerWidget {
  final PublicKey publicKey;

  const CircleIdenticon({
    super.key,
    required this.publicKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(identiconProvider(publicKey)).when(
          data: (identicon) =>
              CircleAvatar(backgroundImage: IdenticonImageProvider(identicon)),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) {
            _logger.e('Failed to load identicon: $error');
            return const Icon(Icons.error);
          },
        );
  }
}
