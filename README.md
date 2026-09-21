Calculadora de Propinas

Aplicación móvil desarrollada con Flutter que permite calcular de manera rápida y sencilla el monto de una propina a partir del total de una cuenta y un porcentaje seleccionado.

🎯 Objetivo

Desarrollar una aplicación móvil sencilla e intuitiva que permita al usuario:

Introducir el monto total de una cuenta.
Seleccionar o introducir el porcentaje de propina.
Calcular automáticamente el monto correspondiente a la propina.
Obtener el total de la cuenta incluyendo la propina.

El proyecto tiene como propósito aplicar conocimientos de desarrollo de aplicaciones móviles utilizando Flutter y Dart.

📋 Requisitos

Para ejecutar el proyecto se requiere:

Flutter SDK
Dart SDK (incluido con Flutter)
Android Studio o las herramientas de Android SDK.
Android SDK
Android SDK Platform-Tools
Un dispositivo Android físico o un emulador.
Una computadora con Windows, macOS o Linux.

Para comprobar que Flutter está correctamente instalado:

flutter doctor

Se recomienda solucionar cualquier error crítico mostrado por flutter doctor antes de ejecutar la aplicación.

⚙️ Instalación
1. Clonar el repositorio
git clone <URL_DEL_REPOSITORIO>
2. Entrar al proyecto
cd gestion_eventos_staff_movil
3. Obtener las dependencias
flutter pub get
4. Comprobar la configuración
flutter doctor

Si se utilizará un dispositivo Android físico, activar previamente las Opciones de desarrollador y la Depuración USB en el dispositivo.

Para comprobar los dispositivos disponibles:

flutter devices
▶️ Ejecución

Para ejecutar la aplicación en el dispositivo o emulador seleccionado:

flutter run

También se puede especificar directamente un dispositivo:

flutter run -d <device_id>

Por ejemplo:

flutter run -d "SM A566B"
Ejecutar en modo debug
flutter run --debug
Generar APK

Para generar una versión APK de la aplicación:

flutter build apk

El APK generado se encontrará normalmente en:

build/app/outputs/flutter-apk/app-release.apk
🧮 Funcionamiento

La aplicación recibe dos valores principales:

Monto de la cuenta
Porcentaje de propina

El cálculo de la propina se realiza mediante:

Propina = Monto de la cuenta × Porcentaje de propina / 100

Y el total a pagar:

Total = Monto de la cuenta + Propina
Ejemplo

Si la cuenta es de:

$500

y se selecciona una propina del:

10%

Entonces:

Propina = $50
Total = $550 <br>

🛠️ Tecnologías utilizadas
Flutter
Dart
Android SDK
Gradle

👥 Participantes
Nombre	Rol <br>
Jimmy Antonio Chan Canche	Desarrollo de la aplicación <br>
Manuel Orlando Keb Ortiz	Desarrollo de la aplicación <br>
Manuel Alejandro Pech Huicab	Desarrollo de la aplicación <br>
Brayan Miguel Rodriguez Dzab	Desarrollo de la aplicación

📁 Estructura básica del proyecto
gestion_eventos_staff_movil/
├── android/
├── ios/
├── lib/
│   └── main.dart
├── test/
├── pubspec.yaml
├── pubspec.lock
└── README.md
📄 Licencia

Este proyecto fue desarrollado con fines académicos.