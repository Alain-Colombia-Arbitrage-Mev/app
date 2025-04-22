import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> record;

  const DetailScreen({super.key, required this.record});

  // Formatear fecha
  String _formatDate(dynamic timestamp) {
    if (timestamp == null) {
      return 'Fecha desconocida';
    }

    try {
      final DateTime date = timestamp.toDate();
      return DateFormat('dd/MM/yyyy - HH:mm').format(date);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(record['alimento'] ?? 'Detalles de alimento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del alimento
            if (record['imagen_url'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: record['imagen_url'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 80),
                      ),
                ),
              ),

            const SizedBox(height: 20),

            // Información básica
            _buildInfoSection('Información Básica', [
              _buildInfoRow('Alimento', record['alimento'] ?? 'Desconocido'),
              _buildInfoRow('Estado', record['estado'] ?? 'No especificado'),
              _buildInfoRow('Fecha', _formatDate(record['fecha'])),
            ]),

            const SizedBox(height: 16),

            // Información de peso y volumen
            _buildInfoSection('Peso y Volumen', [
              _buildInfoRow(
                'Peso',
                '${record['peso']?['valor'] ?? 0} ${record['peso']?['unidad'] ?? 'g'} (±${record['peso']?['margen_error'] ?? '0%'})',
              ),
              _buildInfoRow(
                'Volumen',
                '${record['volumen']?['valor'] ?? 0} ${record['volumen']?['unidad'] ?? 'ml'} (±${record['volumen']?['margen_error'] ?? '0%'})',
              ),
              if (record['portion'] != null)
                _buildInfoRow(
                  'Porción',
                  '${record['portion']['weight'] ?? '0 g'} / ${record['portion']['volume'] ?? '0 ml'} (${record['portion']['household_measure'] ?? 'No especificado'})',
                ),
            ]),

            const SizedBox(height: 16),

            // Información nutricional
            _buildInfoSection('Información Nutricional (por 100g)', [
              _buildInfoRow(
                'Calorías',
                '${record['nutricion']?['kilocalories_per100g'] ?? 0} kcal',
              ),
              _buildInfoRow(
                'Proteínas',
                '${record['nutricion']?['proteins_per100g'] ?? 0} g',
              ),
              _buildInfoRow(
                'Grasas',
                '${record['nutricion']?['fats_per100g'] ?? 0} g',
              ),
              _buildInfoRow(
                'Carbohidratos',
                '${record['nutricion']?['carbohydrates_per100g'] ?? 0} g',
              ),
              _buildInfoRow(
                'Fibra',
                '${record['nutricion']?['fiber_per100g'] ?? 0} g',
              ),
            ]),

            const SizedBox(height: 16),

            // Información del API
            _buildInfoSection('Información del Análisis', [
              _buildInfoRow(
                'Costo API',
                record['costo_api_total'] ?? 'No disponible',
              ),
              _buildInfoRow(
                'Tokens usados',
                (record['tokens_usados'] ?? 'No disponible').toString(),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // Construir sección de información
  Widget _buildInfoSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  // Construir fila de información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
