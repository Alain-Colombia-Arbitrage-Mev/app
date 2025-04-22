import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CameraService {
  late List<CameraDescription> cameras;
  CameraController? controller;
  bool _isCameraInitialized = false;

  // Inicializar cámaras disponibles
  Future<void> initCameras() async {
    if (_isCameraInitialized) {
      return;
    }

    // Solicitar permisos
    final PermissionStatus cameraPermission = await Permission.camera.request();

    if (cameraPermission.isGranted) {
      try {
        cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          await initCameraController(cameras[0]);
        }
        _isCameraInitialized = true;
      } catch (e) {
        print('Error al inicializar cámaras: $e');
      }
    } else {
      print('Permiso de cámara denegado');
    }
  }

  // Inicializar controlador de cámara
  Future<void> initCameraController(CameraDescription cameraDescription) async {
    try {
      controller = CameraController(
        cameraDescription,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller?.initialize();
    } catch (e) {
      print('Error al inicializar controlador de cámara: $e');
    }
  }

  // Tomar foto con la cámara
  Future<File?> takePhoto() async {
    if (controller == null || !controller!.value.isInitialized) {
      print('La cámara no está inicializada');
      return null;
    }

    try {
      final XFile photo = await controller!.takePicture();
      return File(photo.path);
    } catch (e) {
      print('Error al tomar foto: $e');
      return null;
    }
  }

  // Seleccionar imagen de la galería
  Future<File?> pickImageFromGallery() async {
    try {
      final PermissionStatus storagePermission =
          await Permission.photos.request();

      if (storagePermission.isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 85,
        );

        if (image != null) {
          return File(image.path);
        }
      } else {
        print('Permiso de almacenamiento denegado');
      }

      return null;
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      return null;
    }
  }

  // Subir imagen a Firebase Storage
  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      final String fileName = '${const Uuid().v4()}.jpg';
      final String storagePath = 'food_images/$fileName';

      final Reference ref = FirebaseStorage.instance.ref().child(storagePath);
      final UploadTask uploadTask = ref.putFile(imageFile);

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error al subir imagen: $e');
      return null;
    }
  }

  // Liberar recursos de la cámara
  void dispose() {
    controller?.dispose();
  }
}
