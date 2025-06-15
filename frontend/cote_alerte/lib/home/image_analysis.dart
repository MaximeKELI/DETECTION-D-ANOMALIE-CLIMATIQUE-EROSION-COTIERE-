import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageAnalysisPage extends StatefulWidget {
  final String imagePath;

  const ImageAnalysisPage({super.key, required this.imagePath});

  @override
  _ImageAnalysisPageState createState() => _ImageAnalysisPageState();
}

class _ImageAnalysisPageState extends State<ImageAnalysisPage> {
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  Future<void> _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulation d'une analyse d'image
    // En production, vous utiliseriez une API comme Google Vision, AWS Rekognition, ou une solution maison
    await Future.delayed(const Duration(seconds: 2));

    // Résultat simulé
    final randomResult = {
      'erosion_risk': true,
      'already_eroded': false,
      'natural_disaster_impact': false,
      'natural_disaster_risk': true,
      'confidence': 0.78,
    };

    setState(() {
      _analysisResult = randomResult;
      _isAnalyzing = false;
    });

    _showAnalysisResult(randomResult);
  }

  void _showAnalysisResult(Map<String, dynamic> result) {
    String message = 'Résultats de l\'analyse:\n\n';

    if (result['erosion_risk'] == true) {
      message += '⚠️ Zone à risque d\'érosion\n';
    }
    if (result['already_eroded'] == true) {
      message += '⚠️ Zone déjà érodée\n';
    }
    if (result['natural_disaster_impact'] == true) {
      message += '⚠️ Zone ayant subi des catastrophes naturelles\n';
    }
    if (result['natural_disaster_risk'] == true) {
      message += '⚠️ Risque de catastrophes naturelles\n';
    }

    if (message == 'Résultats de l\'analyse:\n\n') {
      message += '✅ Aucun risque détecté';
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Résultats'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analyse d\'image')),
      body: Column(
        children: [
          Expanded(child: Image.file(File(widget.imagePath))),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                _isAnalyzing
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _analyzeImage,
                      child: const Text('Analyser l\'image'),
                    ),
          ),
        ],
      ),
    );
  }
}
