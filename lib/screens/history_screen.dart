import 'package:flutter/material.dart';
import 'package:calorie_counter/services/database_service.dart';
import 'package:calorie_counter/screens/detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  // Cargar registros de comida
  Future<void> _loadRecords() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final records = await _databaseService.getNutritionRecords();

      setState(() {
        _records = records;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar registros: $e';
        _isLoading = false;
      });
    }
  }

  // Eliminar registro
  Future<void> _deleteRecord(String recordId) async {
    try {
      final success = await _databaseService.deleteNutritionRecord(recordId);

      if (success) {
        setState(() {
          _records.removeWhere((record) => record['id'] == recordId);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro eliminado'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRecords),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : _records.isEmpty
              ? const Center(child: Text('No hay registros disponibles'))
              : ListView.builder(
                itemCount: _records.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final record = _records[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(record: record),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Imagen
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  record['imagen_url'] != null
                                      ? CachedNetworkImage(
                                        imageUrl: record['imagen_url'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => const Center(
                                              child: SizedBox(
                                                width: 30,
                                                height: 30,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => const Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                            ),
                                      )
                                      : Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.no_food,
                                          size: 40,
                                        ),
                                      ),
                            ),
                            const SizedBox(width: 16),
                            // Información
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record['alimento'] ?? 'Desconocido',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Calorías: ${record['nutricion']?['kilocalories_per100g'] ?? 0} kcal/100g',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDate(record['fecha']),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Botón para eliminar
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRecord(record['id']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
