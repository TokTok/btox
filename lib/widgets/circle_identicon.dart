import 'package:btox/models/crypto.dart';
import 'package:btox/models/identicon.dart';
import 'package:flutter/material.dart';

final class CircleIdenticon extends StatelessWidget {
  final PublicKey publicKey;

  const CircleIdenticon({
    super.key,
    required this.publicKey,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: IdenticonImageProvider(
        Identicon.fromPublicKey(publicKey),
      ),
    );
  }
}
