import 'dart:io';
import 'package:camera/camera.dart';
import '../home/image_analysis.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isCameraAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _isCameraAvailable = false;
        });
        return;
      }

      final firstCamera = cameras.first;
      _controller = CameraController(firstCamera, ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
      
      setState(() {
        _isCameraAvailable = true;
      });
    } catch (e) {
      print('Erreur lors de l\'initialisation de la caméra : $e');
      setState(() {
        _isCameraAvailable = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_isCameraAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La caméra n\'est pas disponible')),
      );
      return;
    }

    try {
      await _initializeControllerFuture;

      final image = await _controller!.takePicture();

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageAnalysisPage(imagePath: image.path),
        ),
      );
    } catch (e) {
      print('Erreur lors de la prise de photo : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la prise de photo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraAvailable) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prendre une photo')),
        body: const Center(
          child: Text('La caméra n\'est pas disponible sur cet appareil'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Prendre une photo')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
