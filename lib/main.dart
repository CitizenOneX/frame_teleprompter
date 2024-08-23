import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


void main() {
  runApp(const MaterialApp(home: TeleprompterPage()));
}

class TeleprompterPage extends StatefulWidget {
  const TeleprompterPage({super.key});

  @override
  State<TeleprompterPage> createState() => _TeleprompterPageState();
}

class _TeleprompterPageState extends State<TeleprompterPage> {
  String _fileContent = '';

  Future<void> _pickFile() async {
    try {
      // Open the file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // Read the file content
        String content = await file.readAsString();

        // Update the UI
        setState(() {
          _fileContent = content;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frame Teleprompter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick Text File'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _fileContent,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
