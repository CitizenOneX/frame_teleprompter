import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


void main() {
  runApp(MaterialApp(
    home: const TeleprompterPage(),
    theme: ThemeData.dark(),
  ));
}

class TeleprompterPage extends StatefulWidget {
  const TeleprompterPage({super.key});

  @override
  State<TeleprompterPage> createState() => _TeleprompterPageState();
}

class _TeleprompterPageState extends State<TeleprompterPage> {
  List<String> _splitFile = [];
  int _currentLine = -1;

  Future<void> _pickFile() async {
    try {
      // Open the file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // Read the file content and split into lines
        String content = await file.readAsString();
        _splitFile.clear();

        // Update the UI
        setState(() {
          _splitFile.addAll(content.split('\n'));
          _currentLine = 0;
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
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragEnd: (x) {
            // x.velocity.pixelsPerSecond.dy reports about +4000 or -4000
            // for Prev and Next buttons respectively
            if (x.velocity.pixelsPerSecond.dy > 0) {
              _currentLine > 0 ? --_currentLine : null;
            }
            else {
              _currentLine < _splitFile.length - 1 ? ++_currentLine : null;
            }
            if (mounted) setState(() {});
          },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                 _currentLine >= 0 ? _splitFile[_currentLine] : 'Load a file',
                 style: const TextStyle(fontSize: 24),
                                    ),
              const Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _pickFile, child: const Icon(Icons.file_open)),
    );
  }
}
