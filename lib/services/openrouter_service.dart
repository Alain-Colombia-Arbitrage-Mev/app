import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:calorie_counter/config/openrouter_config.dart';
import 'package:calorie_counter/models/nutrition_data.dart';

class OpenRouterService {
  Future<NutritionData?> analyzeImage(File imageFile) async {
    try {
      // Convertir imagen a base64
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // Preparar payload para la API
      final Map<String, dynamic> payload = {
        "model": OpenRouterConfig.modelName,
        "messages": [
          {
            "role": "user",
            "content": [
              {"type": "text", "text": OpenRouterConfig.getPrompt(base64Image)},
              {
                "type": "image_url",
                "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
              },
            ],
          },
        ],
      };

      // Hacer la solicitud a la API
      final response = await http.post(
        Uri.parse(OpenRouterConfig.completionsEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${OpenRouterConfig.apiKey}',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Extraer texto de la respuesta
        final String responseText = data['choices'][0]['message']['content'];

        // Extraer JSON de la respuesta de texto
        final RegExp jsonRegex = RegExp(r'\{[\s\S]*\}');
        final Match? match = jsonRegex.firstMatch(responseText);

        if (match != null) {
          final String jsonString = match.group(0) ?? '{}';
          final Map<String, dynamic> nutritionJson = jsonDecode(jsonString);

          // Crear objeto NutritionData a partir del JSON
          return NutritionData.fromJson(nutritionJson);
        }
      }

      return null;
    } catch (e) {
      print('Error al analizar la imagen: $e');
      return null;
    }
  }
}
