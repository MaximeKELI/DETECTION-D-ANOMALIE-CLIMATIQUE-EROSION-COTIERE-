import 'dart:convert';
import '../config/api_config.dart';
import 'package:http/http.dart' as http;

class RoboflowService {
  // Remplacez ces valeurs par vos informations Roboflow
  static const String _workspace = 'votre-workspace';
  static const String _model = 'votre-model';
  static const String _version = '1';  // Version de votre modèle
  static const String _baseUrl = 'https://api.roboflow.com';
  final String _apiKey;

  RoboflowService() : _apiKey = ApiConfig.roboflowApiKey;

  Future<Map<String, dynamic>> predict(String imageBase64, {double confidence = 0.5}) async {
    try {
      final url = '$_baseUrl/model/$_workspace/$_model/$_version/predict';
      print('URL de l\'API: $url'); // Pour le débogage

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'image': imageBase64,
          'confidence': confidence,
        }),
      );

      print('Status Code: ${response.statusCode}'); // Pour le débogage
      print('Response Headers: ${response.headers}'); // Pour le débogage

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('Résultat de la prédiction: ${jsonEncode(result)}'); // Pour le débogage
        return result;
      } else {
        print('Erreur de réponse: ${response.body}'); // Pour le débogage
        throw Exception('Erreur lors de la prédiction: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception: $e'); // Pour le débogage
      throw Exception('Erreur lors de l\'appel à l\'API Roboflow: $e');
    }
  }

  // Méthode pour vérifier la configuration
  Future<bool> checkConfiguration() async {
    try {
      final url = '$_baseUrl/model/$_workspace/$_model/$_version';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (response.statusCode == 200) {
        print('Configuration valide: ${response.body}');
        return true;
      } else {
        print('Configuration invalide: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erreur de configuration: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> trainModel(String modelId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/model/$modelId/train'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors de l\'entraînement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'appel à l\'API Roboflow: $e');
    }
  }
} 