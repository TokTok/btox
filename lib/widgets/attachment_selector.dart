import 'dart:io';

import 'package:btox/logger.dart';
import 'package:btox/providers/geolocation.dart';
import 'package:btox/widgets/attachment_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const _logger = Logger(['AttachmentSelector']);

final class AttachmentSelector extends StatelessWidget {
  final void Function(String) onAdd;

  const AttachmentSelector({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Table(
        children: [
          TableRow(
            children: [
              if (Platform.isAndroid || Platform.isIOS)
                AttachmentButton(
                  icon: Icons.camera_alt,
                  text: 'Camera',
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      onAdd('Image selected: ${image.path}');
                    }
                  },
                ),
              AttachmentButton(
                icon: Icons.photo,
                text: 'Gallery',
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.image,
                  );
                  if (result != null) {
                    onAdd('Files selected: ${result.files}');
                  }
                },
              ),
              AttachmentButton(
                icon: Icons.file_copy,
                text: 'File',
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                  );
                  if (result != null) {
                    onAdd('Files selected: ${result.files}');
                  }
                },
              ),
              AttachmentButton(
                icon: Icons.location_on,
                text: 'Location',
                onPressed: () async {
                  try {
                    final location = await geolocation();
                    onAdd(location.toString());
                  } catch (e) {
                    _logger.e('Error adding location: $e');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
