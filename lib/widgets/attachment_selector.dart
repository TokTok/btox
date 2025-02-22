import 'package:btox/logger.dart';
import 'package:btox/widgets/attachment_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

const _logger = Logger(['AttachmentSelector']);

final class AttachmentSelector extends StatelessWidget {
  final void Function() onAdd;

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
              AttachmentButton(
                icon: Icons.camera_alt,
                text: 'Camera',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Camera not implemented'),
                    ),
                  );
                },
              ),
              AttachmentButton(
                icon: Icons.photo,
                text: 'Gallery',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gallery not implemented'),
                    ),
                  );
                },
              ),
              AttachmentButton(
                icon: Icons.mic,
                text: 'Audio',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Audio not implemented'),
                    ),
                  );
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
                    _logger.d('Files selected: ${result.files}');
                  }
                },
              ),
              AttachmentButton(
                icon: Icons.location_on,
                text: 'Location',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Location not implemented'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
