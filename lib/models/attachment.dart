import 'dart:typed_data';

sealed class Attachment {
  const Attachment();
}

final class FileAttachment extends Attachment {
  final String path;
  final String name;
  final Uint8List bytes;

  const FileAttachment({
    required this.path,
    required this.name,
    required this.bytes,
  });

  @override
  String toString() =>
      'FileAttachment(path: $path, name: $name, bytes: ${bytes.length})';
}

final class LocationAttachment extends Attachment {
  final double latitude;
  final double longitude;

  const LocationAttachment({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => 'LocationAttachment($latitude, $longitude)';
}
