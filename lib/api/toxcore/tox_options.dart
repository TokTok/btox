import 'dart:typed_data';

import 'package:btox/ffi/toxcore.dart';

final class ToxOptions {
  final bool ipv6Enabled;
  final bool udpEnabled;
  final bool localDiscoveryEnabled;
  final Uint8List? savedata;
  final Tox_Savedata_Type savedataType;

  const ToxOptions({
    this.ipv6Enabled = true,
    this.udpEnabled = true,
    this.localDiscoveryEnabled = true,
    this.savedata,
    this.savedataType = Tox_Savedata_Type.TOX_SAVEDATA_TYPE_NONE,
  });
}
