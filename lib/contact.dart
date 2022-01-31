import 'dart:math';

class Contact {
  final String publicKey;
  final String name;

  Contact({
    required this.publicKey,
    this.name = '',
  });

  factory Contact.fake(int id) {
    var random = Random(id);
    var bytes = List<int>.generate(32, (index) => random.nextInt(255));
    return Contact(
      publicKey: (bytes.map((e) => e.toRadixString(16).toUpperCase())).join(),
      name: 'Contact $id',
    );
  }
}
