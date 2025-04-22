import 'dart:io';
import 'package:flutter/material.dart';
import 'package:calorie_counter/services/auth_service.dart';
import 'package:calorie_counter/services/camera_service.dart';
import 'package:calorie_counter/services/openrouter_service.dart';
import 'package:calorie_counter/services/database_service.dart';
import 'package:calorie_counter/models/nutrition_data.dart';
import 'package:calorie_counter/screens/login_screen.dart';
import 'package:calorie_counter/screens/camera_screen.dart';
import 'package:calorie_counter/screens/history_screen.dart';
import 'package:calorie_counter/widgets/nutrition_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final CameraService _cameraService = CameraService();
  final OpenRouterService _openRouterService = OpenRouterService();
  final DatabaseService _databaseService = DatabaseService();

  NutritionData? _currentNutritionData;
  String? _currentImagePath;
  bool _isLoading = false;
  bool _isProcessing = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Cargar perfil del usuario
  Future<void> _loadUserProfile() async {
    try {
      final userProfile = await _authService.getUserProfile();
      if (userProfile == null && mounted) {
        _logout();
      }
    } catch (e) {
      print('Error al cargar perfil: $e');
    }
  }

  // Cerrar sesión
  Future<void> _logout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  // Seleccionar imagen de la galería
  Future<void> _pickImage() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final File? imageFile = await _cameraService.pickImageFromGallery();

      if (imageFile != null) {
        setState(() {
          _currentImagePath = imageFile.path;
          _isLoading = false;
          _isProcessing = true;
        });

        // Analizar imagen con OpenRouter API
        final NutritionData? nutritionData = await _openRouterService
            .analyzeImage(imageFile);

        if (nutritionData != null) {
          // Subir imagen a Firebase Storage
          final String? imageUrl = await _cameraService.uploadImageToStorage(
            imageFile,
          );

          if (imageUrl != null) {
            // Guardar datos en Firestore
            await _databaseService.saveNutritionRecord(nutritionData, imageUrl);
          }

          setState(() {
            _currentNutritionData = nutritionData;
            _isProcessing = false;
          });
        } else {
          setState(() {
            _errorMessage = 'No se pudieron obtener los datos nutricionales';
            _isProcessing = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al procesar la imagen: $e';
        _isLoading = false;
        _isProcessing = false;
      });
    }
  }

  // Navegar a la pantalla de cámara
  void _navigateToCamera() async {
    final File? imageFile = await Navigator.push<File?>(
      context,
      MaterialPageRoute(builder: (context) => const CameraScreen()),
    );

    if (imageFile != null) {
      setState(() {
        _currentImagePath = imageFile.path;
        _isProcessing = true;
      });

      // Analizar imagen con OpenRouter API
      final NutritionData? nutritionData = await _openRouterService
          .analyzeImage(imageFile);

      if (nutritionData != null) {
        // Subir imagen a Firebase Storage
        final String? imageUrl = await _cameraService.uploadImageToStorage(
          imageFile,
        );

        if (imageUrl != null) {
          // Guardar datos en Firestore
          await _databaseService.saveNutritionRecord(nutritionData, imageUrl);
        }

        setState(() {
          _currentNutritionData = nutritionData;
          _isProcessing = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No se pudieron obtener los datos nutricionales';
          _isProcessing = false;
        });
      }
    }
  }

  // Navegar a la pantalla de historial
  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador de Calorías'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _navigateToHistory,
          ),
          IconButton(icon: const Icon(Icons.exit_to_app), onPressed: _logout),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Analiza tus alimentos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Imagen seleccionada
              if (_currentImagePath != null)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(File(_currentImagePath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Botones para seleccionar imagen
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading || _isProcessing ? null : _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                  ),
                  ElevatedButton.icon(
                    onPressed:
                        _isLoading || _isProcessing ? null : _navigateToCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cámara'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Estado de carga
              if (_isLoading) const Center(child: CircularProgressIndicator()),

              if (_isProcessing)
                Column(
                  children: const [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(height: 10),
                    Text('Analizando imagen...', textAlign: TextAlign.center),
                  ],
                ),

              // Mensaje de error
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 20),

              // Datos nutricionales
              if (_currentNutritionData != null)
                NutritionCard(nutritionData: _currentNutritionData!),
            ],
          ),
        ),
      ),
    );
  }
}
