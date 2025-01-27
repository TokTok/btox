final class ApiException<T extends Enum> implements Exception {
  final T error;

  const ApiException(this.error);

  @override
  String toString() {
    return 'ApiException: $error';
  }
}

abstract class Tox {
  String get address;

  bool get isAlive;

  int get iterationInterval;

  set name(String value);

  set statusMessage(String value);

  void addTcpRelay(String host, int port, String publicKey);

  void bootstrap(String host, int port, String publicKey);

  List<String> iterate();

  void kill();
}

final class ToxConstants {
  final int addressSize;
  final int conferenceIdSize;
  final int fileIdLength;
  final int groupChatIdSize;
  final int groupMaxCustomLosslessPacketLength;
  final int groupMaxCustomLossyPacketLength;
  final int groupMaxGroupNameLength;
  final int groupMaxMessageLength;
  final int groupMaxPartLength;
  final int groupMaxPasswordSize;
  final int groupMaxTopicLength;
  final int groupPeerPublicKeySize;
  final int hashLength;
  final int maxCustomPacketSize;
  final int maxFilenameLength;
  final int maxFriendRequestLength;
  final int maxHostnameLength;
  final int maxMessageLength;
  final int maxNameLength;
  final int maxStatusMessageLength;
  final int nospamSize;
  final int publicKeySize;
  final int secretKeySize;

  const ToxConstants({
    required this.addressSize,
    required this.conferenceIdSize,
    required this.fileIdLength,
    required this.groupChatIdSize,
    required this.groupMaxCustomLosslessPacketLength,
    required this.groupMaxCustomLossyPacketLength,
    required this.groupMaxGroupNameLength,
    required this.groupMaxMessageLength,
    required this.groupMaxPartLength,
    required this.groupMaxPasswordSize,
    required this.groupMaxTopicLength,
    required this.groupPeerPublicKeySize,
    required this.hashLength,
    required this.maxCustomPacketSize,
    required this.maxFilenameLength,
    required this.maxFriendRequestLength,
    required this.maxHostnameLength,
    required this.maxMessageLength,
    required this.maxNameLength,
    required this.maxStatusMessageLength,
    required this.nospamSize,
    required this.publicKeySize,
    required this.secretKeySize,
  });
}
