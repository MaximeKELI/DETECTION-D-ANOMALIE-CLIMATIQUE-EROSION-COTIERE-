import 'dart:io';
import 'dart:convert';
import '../lib/config/api_config.dart';
import '../lib/services/roboflow_service.dart';

void main() async {
  print('=== Test d\'intégration Roboflow ===');
  
  // Vérifier la clé API
  print('\n1. Vérification de la clé API');
  print('Clé API Roboflow: ${ApiConfig.roboflowApiKey}');
  
  // Créer le service Roboflow
  final roboflowService = RoboflowService();
  
  // Vérifier la configuration
  print('\n2. Vérification de la configuration');
  final isConfigured = await roboflowService.checkConfiguration();
  if (!isConfigured) {
    print('❌ La configuration n\'est pas valide. Veuillez vérifier :');
    print('- Le workspace (_workspace)');
    print('- Le nom du modèle (_model)');
    print('- La version du modèle (_version)');
    print('- La clé API');
    return;
  }
  print('✅ Configuration valide');
  
  // Tester avec une image
  print('\n3. Test avec une image');
  final imageFile = File('test/assets/test_image.jpg');
  
  if (!await imageFile.exists()) {
    print('❌ Image de test non trouvée dans test/assets/test_image.jpg');
    return;
  }
  print('✅ Image de test trouvée');

  // Lire l'image et la convertir en base64
  final bytes = await imageFile.readAsBytes();
  final base64Image = base64Encode(bytes);
  print('✅ Image convertie en base64');

  try {
    print('\n4. Envoi de l\'image à l\'API Roboflow');
    final result = await roboflowService.predict(base64Image);
    
    print('\n5. Résultat de la prédiction :');
    print(jsonEncode(result));
    
    // Vérifier si le résultat contient des prédictions
    if (result.containsKey('predictions') && result['predictions'] is List) {
      final predictions = result['predictions'] as List;
      print('\nNombre de prédictions : ${predictions.length}');
      
      for (var i = 0; i < predictions.length; i++) {
        final prediction = predictions[i];
        print('\nPrédiction ${i + 1}:');
        print('- Classe: ${prediction['class']}');
        print('- Confiance: ${prediction['confidence']}');
        if (prediction.containsKey('bbox')) {
          print('- Bounding Box: ${prediction['bbox']}');
        }
      }
    } else {
      print('\n❌ Aucune prédiction trouvée dans la réponse');
    }
  } catch (e) {
    print('\n❌ Erreur lors du test :');
    print(e.toString());
  }
} 