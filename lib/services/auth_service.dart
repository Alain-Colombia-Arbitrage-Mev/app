import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Estado actual del usuario
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registro con email y contraseña
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Crear perfil de usuario en Firestore
      await _createUserProfile(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      return userCredential;
    } catch (e) {
      print('Error en el registro: $e');
      return null;
    }
  }

  // Inicio de sesión con email y contraseña
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error en el inicio de sesión: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Crear perfil de usuario en Firestore
  Future<void> _createUserProfile({
    required String uid,
    required String email,
    required String name,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
      'calorieRecords': [],
    });
  }

  // Obtener datos del perfil del usuario
  Future<Map<String, dynamic>?> getUserProfile() async {
    final User? user = currentUser;

    if (user == null) {
      return null;
    }

    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('Error al obtener perfil: $e');
      return null;
    }
  }
}
