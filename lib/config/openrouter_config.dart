class OpenRouterConfig {
  static const String apiKey =
      "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";
  static const String baseUrl = "https://openrouter.ai/api/v1";
  static const String completionsEndpoint = "$baseUrl/chat/completions";

  static const String modelName = "anthropic/claude-3-7-sonnet-thinking";

  static String getPrompt(String imageBase64) {
    return """
Analiza esta imagen de alimento como experto en nutrición: 
1. Identifica el alimento y su estado 
2. Estima peso (g), volumen (taza/cucharada) y margen de error 
3. Calcula calorías y macronutrientes básicos 
4. Incluye tokens usados y costo API aproximado 
Responde con: 
- JSON mínimo con la información anterior 
- Usa el diámetro del recipiente como referencia principal
    """;
  }
}
