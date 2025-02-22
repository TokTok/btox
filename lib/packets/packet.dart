import 'dart:typed_data';

import 'package:btox/packets/messagepack.dart';

abstract mixin class Packet {
  const Packet();

  Uint8List encode() {
    final Packer packer = Packer();
    pack(packer);
    return packer.takeBytes();
  }

  void pack(Packer packer);
}
