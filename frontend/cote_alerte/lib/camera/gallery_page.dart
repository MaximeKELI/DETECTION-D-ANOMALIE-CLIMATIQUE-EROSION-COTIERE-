import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../home/image_analysis.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageAnalysisPage(imagePath: pickedFile.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sélectionner une image')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pickImage(context),
          child: const Text('Choisir une image'),
        ),
      ),
    );
  }
}
