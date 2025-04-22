import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calorie_counter/models/nutrition_data.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Referencia a la colección de usuarios
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Obtener el ID del usuario actual
  String? get _currentUserId => _auth.currentUser?.uid;

  // Guardar un registro de nutrición
  Future<bool> saveNutritionRecord(
    NutritionData nutritionData,
    String imageUrl,
  ) async {
    try {
      if (_currentUserId == null) {
        return false;
      }

      // Crear un nuevo documento en la subcolección 'records'
      await _usersCollection.doc(_currentUserId).collection('records').add({
        'alimento': nutritionData.alimento,
        'estado': nutritionData.estado,
        'peso': {
          'valor': nutritionData.peso.valor,
          'unidad': nutritionData.peso.unidad,
          'margen_error': nutritionData.peso.margenError,
        },
        'volumen': {
          'valor': nutritionData.volumen.valor,
          'unidad': nutritionData.volumen.unidad,
          'margen_error': nutritionData.volumen.margenError,
        },
        'portion': {
          'volume': nutritionData.portion.volume,
          'weight': nutritionData.portion.weight,
          'household_measure': nutritionData.portion.householdMeasure,
          'error_margin': nutritionData.portion.errorMargin,
        },
        'nutricion': {
          'kilocalories_per100g': nutritionData.nutricion.kilocaloriesPer100g,
          'proteins_per100g': nutritionData.nutricion.proteinsPer100g,
          'fats_per100g': nutritionData.nutricion.fatsPer100g,
          'carbohydrates_per100g': nutritionData.nutricion.carbohydratesPer100g,
          'fiber_per100g': nutritionData.nutricion.fiberPer100g,
        },
        'costo_api_total': nutritionData.costoApiTotal,
        'tokens_usados': nutritionData.tokensUsados,
        'imagen_url': imageUrl,
        'fecha': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error al guardar registro de nutrición: $e');
      return false;
    }
  }

  // Obtener todos los registros de nutrición del usuario
  Future<List<Map<String, dynamic>>> getNutritionRecords() async {
    try {
      if (_currentUserId == null) {
        return [];
      }

      final QuerySnapshot snapshot =
          await _usersCollection
              .doc(_currentUserId)
              .collection('records')
              .orderBy('fecha', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();
    } catch (e) {
      print('Error al obtener registros de nutrición: $e');
      return [];
    }
  }

  // Eliminar un registro de nutrición
  Future<bool> deleteNutritionRecord(String recordId) async {
    try {
      if (_currentUserId == null) {
        return false;
      }

      await _usersCollection
          .doc(_currentUserId)
          .collection('records')
          .doc(recordId)
          .delete();

      return true;
    } catch (e) {
      print('Error al eliminar registro de nutrición: $e');
      return false;
    }
  }
}
