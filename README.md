# Contador de Calorías

Una aplicación Flutter para analizar y contar calorías en alimentos usando la API de OpenRouter y Firebase.

## Características

- Autenticación de usuarios con Firebase Auth
- Captura de imágenes con la cámara del dispositivo
- Análisis de imágenes de alimentos con OpenRouter API (Claude 3.7 Sonnet:thinking)
- Almacenamiento de datos nutricionales en Firebase
- Historial de alimentos analizados
- Información detallada nutricional

## Requisitos previos

- Flutter SDK (última versión estable)
- Cuenta de Firebase
- Cuenta de OpenRouter API
- Git
- Android Studio / VS Code con extensiones Flutter

## Configuración

### 1. Clonar el repositorio

```bash
git clone <URL-del-repositorio>
cd calorie_counter
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar Firebase

1. Crear un nuevo proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Habilitar Authentication, Firestore y Storage
3. Configurar reglas de seguridad para Firestore y Storage
4. Descargar el archivo `google-services.json` para Android o `GoogleService-Info.plist` para iOS
5. Colocar estos archivos en las carpetas correspondientes:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### 4. Configurar OpenRouter API

1. Crear una cuenta en [OpenRouter](https://openrouter.ai/)
2. Obtener una API key
3. Actualizar la constante `apiKey` en `lib/config/openrouter_config.dart`

### 5. Configurar Firebase en la aplicación

Actualizar el archivo `lib/config/firebase_config.dart` con la información de tu proyecto Firebase:

```dart
static const String apiKey = "TU_API_KEY";
static const String authDomain = "TU_AUTH_DOMAIN";
static const String projectId = "TU_PROJECT_ID";
static const String storageBucket = "TU_STORAGE_BUCKET";
static const String messagingSenderId = "TU_MESSAGING_SENDER_ID";
static const String appId = "TU_APP_ID";
```

## Ejecutar la aplicación

```bash
flutter run
```

## Estructura del proyecto

- `lib/config/`: Configuraciones de Firebase y OpenRouter API
- `lib/models/`: Modelos de datos
- `lib/screens/`: Pantallas de la aplicación
- `lib/services/`: Servicios para interactuar con APIs y Firebase
- `lib/utils/`: Utilidades
- `lib/widgets/`: Widgets reutilizables
- `lib/main.dart`: Punto de entrada de la aplicación

## Funcionalidades principales

1. **Autenticación**: Registro e inicio de sesión de usuarios
2. **Captura de imágenes**: Toma fotos de alimentos o selecciona de la galería
3. **Análisis de alimentos**: Envía imágenes a OpenRouter API para análisis
4. **Datos nutricionales**: Visualiza información detallada de calorías y macronutrientes
5. **Historial**: Guarda y visualiza todos los alimentos analizados

## Problemas comunes

- **Error de permisos de cámara**: Asegúrate de aceptar los permisos cuando la aplicación los solicite
- **Problemas con Firebase**: Verifica la configuración y las reglas de seguridad
- **OpenRouter API**: Asegúrate de tener crédito suficiente en tu cuenta

## Contribuir

1. Haz un fork del repositorio
2. Crea una rama para tu característica (`git checkout -b feature/amazing-feature`)
3. Haz commit de tus cambios (`git commit -m 'Add some amazing feature'`)
4. Haz push a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## Contacto

Tu Nombre - [tu_email@example.com](mailto:tu_email@example.com)

Enlace del proyecto: [https://github.com/tunombre/contador-calorias](https://github.com/tunombre/contador-calorias)
