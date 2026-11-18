# Biblioteca Personal Móvil

Aplicación Flutter independiente para la Práctica 10 (Notificaciones y Proyecto Móvil Integrador).

## Funcionalidades
- Tres secciones principales: Inicio, Explorar libros y Mi biblioteca.
- Búsqueda de libros mediante API REST/JSON de Open Library.
- Consulta de detalles de libros.
- Persistencia local SQLite para consultar libros guardados sin conexión.
- Formulario validado para registrar libros manualmente.
- Uso de cámara para tomar una fotografía de portada.
- Notificación local después de guardar un libro.
- Estados de carga, error y lista vacía.

## Requisitos
- Flutter SDK compatible con Dart 3.4 o superior.
- Android SDK y un dispositivo/emulador Android.
- Conexión a Internet para la búsqueda en Open Library.

## Instalación
1. Crear el esqueleto de plataforma Flutter:
   ```bash
   flutter create --platforms=android,ios .
   ```
2. Instalar dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecutar:
   ```bash
   flutter run
   ```

## Permisos Android
En `android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>`, agrega:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```
La cámara se solicita al utilizarla. En Android 13 o superior se solicita permiso de notificaciones en tiempo de ejecución mediante el plugin.

## API REST
Open Library Search API:
`https://openlibrary.org/search.json?q=flutter`

La búsqueda requiere conexión a Internet. Los libros guardados se almacenan en SQLite y permanecen disponibles sin conexión.

## Pruebas sugeridas
- Buscar un título conocido y comprobar que se muestran resultados.
- Intentar buscar con el campo vacío.
- Guardar un libro y comprobar la notificación.
- Activar modo avión y abrir Mi biblioteca.
- Agregar un libro manual sin título o autor y verificar las validaciones.
- Agregar un libro válido y tomar una fotografía con la cámara.
- Ejecutar `dart format .`, `flutter analyze` y `flutter test`.

## Evidencias
Guardar capturas en `docs/evidencias/practica-10/`:
- Inicio.
- Resultados de búsqueda desde la API.
- Detalle de un libro.
- Formulario y validación.
- Cámara.
- Notificación recibida.
- Biblioteca disponible sin conexión.
- Salida de análisis y pruebas.

## Participantes
Completar con los nombres del estudiante o integrantes del equipo.
