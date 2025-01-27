import 'package:btox/api/toxcore/tox.dart';
import 'package:btox/ffi/tox_ffi.web.dart';

ToxConstants toxcoreConstants(ToxFfi ffi) => const ToxConstants(
      addressSize: 38,
      conferenceIdSize: 32,
      fileIdLength: 32,
      groupChatIdSize: 32,
      groupMaxCustomLosslessPacketLength: 1373,
      groupMaxCustomLossyPacketLength: 1373,
      groupMaxGroupNameLength: 48,
      groupMaxMessageLength: 1372,
      groupMaxPartLength: 128,
      groupMaxPasswordSize: 32,
      groupMaxTopicLength: 512,
      groupPeerPublicKeySize: 32,
      hashLength: 32,
      maxCustomPacketSize: 1373,
      maxFilenameLength: 255,
      maxFriendRequestLength: 921,
      maxHostnameLength: 255,
      maxMessageLength: 1372,
      maxNameLength: 128,
      maxStatusMessageLength: 1007,
      nospamSize: 4,
      publicKeySize: 32,
      secretKeySize: 32,
    );
