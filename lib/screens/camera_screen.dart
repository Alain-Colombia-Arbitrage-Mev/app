import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:calorie_counter/services/camera_service.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();
  bool _isInitialized = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _cameraService.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  // Inicializar cámara
  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasPermission = status.isGranted;
    });

    if (_hasPermission) {
      await _cameraService.initCameras();
      setState(() {
        _isInitialized =
            _cameraService.controller != null &&
            _cameraService.controller!.value.isInitialized;
      });
    }
  }

  // Tomar foto
  Future<void> _takePhoto() async {
    if (!_isInitialized) {
      return;
    }

    try {
      final File? photo = await _cameraService.takePhoto();

      if (photo != null && mounted) {
        Navigator.pop(context, photo);
      }
    } catch (e) {
      print('Error al tomar foto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tomar Foto')),
      body: Builder(
        builder: (context) {
          if (!_hasPermission) {
            return _buildPermissionDenied();
          }

          if (!_isInitialized) {
            return _buildLoading();
          }

          return _buildCameraPreview();
        },
      ),
      floatingActionButton:
          _isInitialized
              ? FloatingActionButton(
                onPressed: _takePhoto,
                child: const Icon(Icons.camera_alt),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Widget para previsualización de cámara
  Widget _buildCameraPreview() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(_cameraService.controller!),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        ),
      ],
    );
  }

  // Widget para mostrar durante la carga
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Inicializando cámara...'),
        ],
      ),
    );
  }

  // Widget para mostrar cuando se deniega el permiso
  Widget _buildPermissionDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_photography, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Se requiere permiso para acceder a la cámara',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final status = await Permission.camera.request();
              setState(() {
                _hasPermission = status.isGranted;
              });

              if (_hasPermission) {
                _initializeCamera();
              }
            },
            child: const Text('Solicitar permiso'),
          ),
        ],
      ),
    );
  }
}
