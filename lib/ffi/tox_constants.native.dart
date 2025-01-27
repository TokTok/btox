import 'package:btox/api/toxcore/tox.dart';
import 'package:btox/ffi/generated/toxcore.native.dart';

ToxConstants toxcoreConstants(ToxFfi ffi) => ToxConstants(
      addressSize: ffi.tox_address_size(),
      conferenceIdSize: ffi.tox_conference_id_size(),
      fileIdLength: ffi.tox_file_id_length(),
      groupChatIdSize: ffi.tox_group_chat_id_size(),
      groupMaxCustomLosslessPacketLength:
          ffi.tox_group_max_custom_lossless_packet_length(),
      groupMaxCustomLossyPacketLength:
          ffi.tox_group_max_custom_lossy_packet_length(),
      groupMaxGroupNameLength: ffi.tox_group_max_group_name_length(),
      groupMaxMessageLength: ffi.tox_group_max_message_length(),
      groupMaxPartLength: ffi.tox_group_max_part_length(),
      groupMaxPasswordSize: ffi.tox_group_max_password_size(),
      groupMaxTopicLength: ffi.tox_group_max_topic_length(),
      groupPeerPublicKeySize: ffi.tox_group_peer_public_key_size(),
      hashLength: ffi.tox_hash_length(),
      maxCustomPacketSize: ffi.tox_max_custom_packet_size(),
      maxFilenameLength: ffi.tox_max_filename_length(),
      maxFriendRequestLength: ffi.tox_max_friend_request_length(),
      maxHostnameLength: ffi.tox_max_hostname_length(),
      maxMessageLength: ffi.tox_max_message_length(),
      maxNameLength: ffi.tox_max_name_length(),
      maxStatusMessageLength: ffi.tox_max_status_message_length(),
      nospamSize: ffi.tox_nospam_size(),
      publicKeySize: ffi.tox_public_key_size(),
      secretKeySize: ffi.tox_secret_key_size(),
    );
