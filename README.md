# Cámara y Sensores - Flutter

## Descripción

Aplicación móvil desarrollada con Flutter y Dart que permite utilizar la cámara del dispositivo y consultar información de los sensores físicos del teléfono.

La aplicación permite tomar fotografías, visualizar la imagen capturada, registrar la fecha y hora de captura y consultar en tiempo real los valores obtenidos mediante el acelerómetro y el giroscopio.

## Características principales

- **Captura de fotografías:** permite tomar fotografías utilizando la cámara del dispositivo.
- **Visualización de imágenes:** muestra la fotografía capturada dentro de la aplicación.
- **Fecha y hora:** registra la fecha y hora en que se toma cada fotografía.
- **Acelerómetro:** obtiene los valores de los ejes X, Y y Z.
- **Giroscopio:** obtiene los valores de los ejes X, Y y Z.
- **Actualización en tiempo real:** muestra los cambios detectados por los sensores del dispositivo.

## Tecnologías utilizadas

- Flutter
- Dart
- Visual Studio Code
- Android

## Dependencias utilizadas

| Paquete | Versión | Funcionalidad |
|---|---|---|
| `image_picker` | ^1.0.8 | Acceso a la cámara y captura de fotografías. |
| `sensors_plus` | ^7.1.1 | Lectura del acelerómetro y giroscopio. |
| `intl` | ^0.20.2 | Formato de fecha y hora. |

## Requisitos

Para ejecutar el proyecto se necesita:

- Flutter SDK instalado.
- Dart SDK.
- Visual Studio Code o un editor compatible.
- Un dispositivo Android físico o emulador compatible.
- Cámara disponible para realizar las capturas.
- Sensores compatibles con el dispositivo.

## Instalación

1. Clonar el repositorio:

   ```bash
   git clone URL_DEL_REPOSITORIO
   ```

2. Entrar en la carpeta del proyecto:

   ```bash
   cd gestion_eventos_staff_movil
   ```

3. Instalar las dependencias:

   ```bash
   flutter pub get
   ```

4. Ejecutar la aplicación:

   ```bash
   flutter run
   ```

## Funcionamiento de la aplicación

### 1. Cámara

La aplicación cuenta con un botón llamado **Tomar fotografía**, que permite abrir la cámara del dispositivo.

Al capturar una imagen:

- Se obtiene la fotografía.
- Se muestra dentro de la pantalla.
- Se registra la fecha y hora de captura.
- Se presentan los valores actuales de los sensores.

### 2. Acelerómetro

El acelerómetro permite obtener información sobre el movimiento y la aceleración del dispositivo en tres ejes:

- X: movimiento en el eje horizontal.
- Y: movimiento en el eje vertical.
- Z: movimiento en el eje de profundidad.

Los valores se actualizan conforme el dispositivo detecta cambios.

### 3. Giroscopio

El giroscopio permite obtener información sobre la velocidad de rotación del dispositivo en tres ejes:

- X: rotación alrededor del eje X.
- Y: rotación alrededor del eje Y.
- Z: rotación alrededor del eje Z.

Los valores se muestran en tiempo real dentro de la aplicación.

### 4. Fecha y hora

Cuando se toma una fotografía, se registra la fecha y hora utilizando el paquete `intl`, con el siguiente formato:

```text
yyyy-MM-dd – HH:mm:ss
```

## Estructura del proyecto

```text
gestion_eventos_staff_movil/
│
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   └── sensores_page.dart
│
├── test/
│   └── widget_test.dart
│
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

## Pruebas y análisis del proyecto

Para comprobar el funcionamiento y la calidad del código se utilizaron los siguientes comandos:

### Analizar el código

```bash
flutter analyze
```

### Ejecutar las pruebas

```bash
flutter test
```

**Resultado de las pruebas realizadas:**

- Análisis estático ejecutado correctamente.
- Prueba de widget aprobada.
- Resultado: `All tests passed!`.

## Autor

Proyecto académico desarrollado como parte de las actividades de la asignatura de Tópicos de Programación Móvil.

**Institución:** Instituto Tecnológico Superior de Calkiní en el Estado de Campeche (ITESCAM).

**Tecnología principal:** Flutter y Dart.