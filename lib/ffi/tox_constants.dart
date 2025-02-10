import 'package:btox/api/toxcore/tox.dart';
import 'package:btox/ffi/tox_library.dart';
import 'package:btox/models/crypto.dart';

ToxConstants toxcoreConstants(ToxLibrary lib) {
  final constants = ToxConstants(
    addressSize: lib.ffi.tox_address_size(),
    conferenceIdSize: lib.ffi.tox_conference_id_size(),
    fileIdLength: lib.ffi.tox_file_id_length(),
    groupChatIdSize: lib.ffi.tox_group_chat_id_size(),
    groupMaxCustomLosslessPacketLength:
        lib.ffi.tox_group_max_custom_lossless_packet_length(),
    groupMaxCustomLossyPacketLength:
        lib.ffi.tox_group_max_custom_lossy_packet_length(),
    groupMaxGroupNameLength: lib.ffi.tox_group_max_group_name_length(),
    groupMaxMessageLength: lib.ffi.tox_group_max_message_length(),
    groupMaxPartLength: lib.ffi.tox_group_max_part_length(),
    groupMaxPasswordSize: lib.ffi.tox_group_max_password_size(),
    groupMaxTopicLength: lib.ffi.tox_group_max_topic_length(),
    groupPeerPublicKeySize: lib.ffi.tox_group_peer_public_key_size(),
    hashLength: lib.ffi.tox_hash_length(),
    maxCustomPacketSize: lib.ffi.tox_max_custom_packet_size(),
    maxFilenameLength: lib.ffi.tox_max_filename_length(),
    maxFriendRequestLength: lib.ffi.tox_max_friend_request_length(),
    maxHostnameLength: lib.ffi.tox_max_hostname_length(),
    maxMessageLength: lib.ffi.tox_max_message_length(),
    maxNameLength: lib.ffi.tox_max_name_length(),
    maxStatusMessageLength: lib.ffi.tox_max_status_message_length(),
    nospamSize: lib.ffi.tox_nospam_size(),
    publicKeySize: lib.ffi.tox_public_key_size(),
    secretKeySize: lib.ffi.tox_secret_key_size(),
  );

  assert(constants.addressSize == ToxAddress.kLength);
  assert(constants.publicKeySize == PublicKey.kLength);
  assert(constants.secretKeySize == SecretKey.kLength);
  return constants;
}
