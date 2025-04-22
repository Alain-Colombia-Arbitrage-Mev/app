import 'package:flutter/material.dart';
import 'package:calorie_counter/models/nutrition_data.dart';

class NutritionCard extends StatelessWidget {
  final NutritionData nutritionData;

  const NutritionCard({super.key, required this.nutritionData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nutritionData.alimento,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nutritionData.estado,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Peso y volumen
            Row(
              children: [
                _buildInfoItem(
                  'Peso',
                  '${nutritionData.peso.valor} ${nutritionData.peso.unidad}',
                  '±${nutritionData.peso.margenError}',
                  Icons.scale,
                ),
                const SizedBox(width: 24),
                _buildInfoItem(
                  'Volumen',
                  '${nutritionData.volumen.valor} ${nutritionData.volumen.unidad}',
                  '±${nutritionData.volumen.margenError}',
                  Icons.water_drop,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Datos nutricionales
            const Text(
              'Información Nutricional (por 100g)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Macronutrientes
            _buildNutrientRow(
              'Calorías',
              '${nutritionData.nutricion.kilocaloriesPer100g} kcal',
              Colors.red[400]!,
            ),
            _buildNutrientRow(
              'Proteínas',
              '${nutritionData.nutricion.proteinsPer100g} g',
              Colors.blue[400]!,
            ),
            _buildNutrientRow(
              'Grasas',
              '${nutritionData.nutricion.fatsPer100g} g',
              Colors.yellow[700]!,
            ),
            _buildNutrientRow(
              'Carbohidratos',
              '${nutritionData.nutricion.carbohydratesPer100g} g',
              Colors.orange[400]!,
            ),
            _buildNutrientRow(
              'Fibra',
              '${nutritionData.nutricion.fiberPer100g} g',
              Colors.green[400]!,
            ),

            const SizedBox(height: 16),

            // Porción
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.dining, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Porción',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${nutritionData.portion.weight} / ${nutritionData.portion.volume}',
                        ),
                        Text(
                          nutritionData.portion.householdMeasure,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Barra de metadatos
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Tokens: ${nutritionData.tokensUsados}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Text(
                  'Costo: ${nutritionData.costoApiTotal}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para información de peso/volumen
  Widget _buildInfoItem(
    String label,
    String value,
    String margin,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(margin, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  // Widget para fila de nutriente
  Widget _buildNutrientRow(String nutrient, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              nutrient,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
