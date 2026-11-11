# Aplicación de Puntos de Interés

## Descripción

Aplicación móvil desarrollada con Flutter y Dart que permite registrar, visualizar y consultar puntos de interés mediante coordenadas geográficas. Utiliza los servicios de ubicación del dispositivo y permite introducir manualmente la latitud y longitud de un lugar.

La aplicación también contempla la integración con Google Maps para consultar ubicaciones y mostrar imágenes relacionadas con los lugares registrados.

## Características principales

- **Listado de puntos de interés:** muestra los lugares registrados en la aplicación.
- **Puntos precargados:** incluye ubicaciones iniciales de Dzitbalché, Campeche.
- **Registro manual de coordenadas:** permite introducir la latitud y longitud de un lugar.
- **Geolocalización GPS:** permite obtener la ubicación actual del dispositivo.
- **Consulta en Google Maps:** permite abrir la ubicación seleccionada en Google Maps.
- **Visualización de imágenes:** permite mostrar fotografías de los lugares mediante la integración con servicios de Google Maps Platform.
- **Cálculo de distancias:** permite consultar la distancia entre los puntos registrados.

## Tecnologías utilizadas

- Flutter
- Dart
- Google Maps Platform
- Geolocator
- URL Launcher

## Requisitos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- Flutter SDK.
- Dart SDK.
- Visual Studio Code u otro editor compatible.
- Un emulador Android o dispositivo físico.
- Conexión a Internet para consultar los servicios de Google Maps.

## Instalación

1. Clonar el repositorio:

   ```bash
   git clone URL_DEL_REPOSITORIO
   ```

2. Entrar en la carpeta del proyecto:

   ```bash
   cd nombre_del_proyecto
   ```

3. Instalar las dependencias:

   ```bash
   flutter pub get
   ```

4. Ejecutar la aplicación:

   ```bash
   flutter run
   ```

## Geolocalización

La aplicación permite obtener las coordenadas actuales del dispositivo mediante el GPS. También cuenta con campos para introducir manualmente la latitud y longitud.

Las coordenadas se utilizan para identificar la ubicación del punto de interés y abrirla en Google Maps.

## Integración con Google Maps

Para mostrar fotografías reales de los lugares registrados se contempla el uso de Google Places API (New).

Esta integración permite buscar lugares a partir de sus coordenadas y obtener fotografías disponibles en Google Maps.

### Configuración de Google Maps Platform

1. Crear un proyecto en [Google Cloud Console](https://console.cloud.google.com/).
2. Habilitar Places API (New).
3. Configurar una clave de API.
4. Habilitar la facturación cuando sea necesario.
5. Configurar las restricciones de seguridad de la clave.
6. Incorporar la clave en la configuración correspondiente del proyecto.

**Importante:** la visualización de fotografías depende de que Google Places encuentre el lugar y disponga de imágenes. También deben respetarse las atribuciones fotográficas indicadas por Google. Para una aplicación publicada, se recomienda realizar las solicitudes de Places API desde un backend y no exponer una clave sin protección en el código de Flutter.

## Estructura del proyecto

```text
lib/
├── main.dart
├── models/
│   └── punto_interes.dart
├── screens/
│   ├── puntos_page.dart
│   ├── registrar_punto_page.dart
│   └── distancia_page.dart
├── services/
│   └── ubicacion_service.dart
└── widgets/
    └── punto_card.dart
```

## Permisos de ubicación

La aplicación necesita permisos de ubicación para obtener las coordenadas GPS del dispositivo.

En Android, se deben configurar los permisos correspondientes en:

```text
android/app/src/main/AndroidManifest.xml
```

Ejemplo:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

El usuario debe conceder los permisos para que la aplicación pueda consultar su ubicación actual.

## Ejecución y pruebas

Para comprobar el funcionamiento:

1. Abrir la aplicación.
2. Revisar los puntos de interés precargados.
3. Registrar un nuevo punto.
4. Introducir manualmente sus coordenadas o utilizar el GPS.
5. Guardar el registro.
6. Consultar la información y la imagen del lugar, cuando esté disponible.
7. Abrir el punto en Google Maps.
8. Consultar las distancias entre los puntos registrados.

## Autor

Proyecto académico desarrollado como parte de las actividades de la asignatura de Tópicos de Programación Móvil.

**Institución:** Instituto Tecnológico Superior de Calkiní en el Estado de Campeche (ITESCAM).

**Tecnología principal:** Flutter y Dart.