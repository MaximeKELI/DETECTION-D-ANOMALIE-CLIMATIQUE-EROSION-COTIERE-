import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:cote_alerte/services/roboflow_service.dart';

void main() {
  group('RoboflowService Tests', () {
    late RoboflowService roboflowService;

    setUp(() {
      roboflowService = RoboflowService();
    });

    test('Test de prédiction avec une image', () async {
      // Chemin vers une image de test
      final imageFile = File('test/assets/test_image.jpg');
      
      // Vérifier si l'image existe
      if (!await imageFile.exists()) {
        fail('Image de test non trouvée. Veuillez ajouter une image de test dans test/assets/test_image.jpg');
      }

      // Lire l'image et la convertir en base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      try {
        // Appeler l'API Roboflow
        final result = await roboflowService.predict(base64Image, 'votre_model_id');

        // Vérifier que la réponse contient les champs attendus
        expect(result, isA<Map<String, dynamic>>());
        expect(result['predictions'], isA<List>());
        
        // Afficher les résultats pour le débogage
        print('Résultat de la prédiction :');
        print(jsonEncode(result));
      } catch (e) {
        fail('Erreur lors de l\'appel à l\'API Roboflow: $e');
      }
    });
  });
} 