# Ejercicio evaluable: Bitácora de inspección

**Asignatura:** Tópicos de Programación Móvil  
**Institución:** Instituto Tecnológico Superior de Calkiní en el Estado de Campeche (ITESCAM)  
**Tecnología:** Flutter y Dart  
**Proyecto:** Bitácora de inspección  
**Versión:** 1.0.0

---

## 1. Descripción del ejercicio

Desarrollo de una aplicación móvil que permite generar una bitácora de inspección mediante el uso de la cámara y los sensores físicos del dispositivo.

La aplicación captura una fotografía, registra automáticamente la fecha y hora de la captura, obtiene los valores actuales del acelerómetro y del giroscopio y presenta toda la información en una tarjeta de evidencia.

El propósito es integrar diferentes funcionalidades del dispositivo móvil para generar un registro visual y técnico de una inspección.

## 2. Objetivo general

Desarrollar una aplicación móvil utilizando Flutter que integre el acceso a la cámara, el manejo de permisos y la lectura de sensores físicos, permitiendo almacenar y visualizar evidencias de inspección mediante una tarjeta que concentre la información obtenida.

## 3. Requerimientos funcionales

| ID | Requerimiento | Descripción |
|---|---|---|
| RF-01 | Captura fotográfica | Permitir tomar una fotografía utilizando la cámara del dispositivo. |
| RF-02 | Fecha y hora | Registrar automáticamente la fecha y hora de la captura. |
| RF-03 | Acelerómetro | Obtener los valores actuales de los ejes X, Y y Z. |
| RF-04 | Giroscopio | Obtener los valores actuales de los ejes X, Y y Z. |
| RF-05 | Tarjeta de evidencia | Presentar fotografía, fecha, hora y valores de los sensores en una misma tarjeta. |
| RF-06 | Cancelación de cámara | Permitir cancelar la captura sin provocar errores en la aplicación. |
| RF-07 | Manejo de permisos | Gestionar los permisos necesarios para acceder a la cámara. |
| RF-08 | Visualización | Mostrar la información obtenida de manera organizada y comprensible. |

## 4. Tecnologías y dependencias

### Tecnologías

- Flutter: framework para el desarrollo de aplicaciones móviles.
- Dart: lenguaje de programación.
- Android: plataforma de ejecución y pruebas.
- Visual Studio Code: entorno de desarrollo.

### Paquetes utilizados

| Paquete | Versión | Uso |
|---|---|---|
| `image_picker` | ^1.0.8 | Captura y selección de fotografías. |
| `sensors_plus` | ^7.1.1 | Lectura del acelerómetro y giroscopio. |
| `intl` | ^0.20.2 | Formateo de fecha y hora. |

## 5. Estructura del proyecto

```text
gestion_eventos_staff_movil/
│
├── android/
│
├── ios/
│
├── lib/
│   ├── main.dart
│   │
│   └── sensores_page.dart
│
├── test/
│   └── widget_test.dart
│
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

### Descripción de los archivos principales

**`main.dart`**

Contiene el punto de entrada de la aplicación, inicializa Flutter y configura la pantalla principal.

**`sensores_page.dart`**

Contiene la interfaz de la bitácora de inspección, la captura fotográfica, el registro de fecha y hora y la lectura de los sensores.

**`widget_test.dart`**

Contiene las pruebas automatizadas de la interfaz de la aplicación.

**`pubspec.yaml`**

Define las dependencias, configuración y paquetes necesarios para ejecutar el proyecto.

## 6. Funcionamiento de la aplicación

### 6.1. Captura de fotografía

La aplicación permite acceder a la cámara del dispositivo mediante un botón de captura.

Cuando el usuario toma una fotografía, la aplicación obtiene el archivo de imagen y lo muestra en la tarjeta de evidencia.

Si el usuario cancela la captura, no se debe modificar la evidencia existente ni provocar que la aplicación se cierre.

### 6.2. Registro de fecha y hora

Al realizar una captura correctamente, se obtiene la fecha y hora del dispositivo.

El formato utilizado es:

```text
yyyy-MM-dd – HH:mm:ss
```

La fecha y hora permiten identificar el momento en que se generó cada evidencia.

### 6.3. Lectura del acelerómetro

Se utiliza el paquete `sensors_plus` para consultar los datos proporcionados por el acelerómetro.

Se muestran los tres ejes:

- X: aceleración en el eje X.
- Y: aceleración en el eje Y.
- Z: aceleración en el eje Z.

### 6.4. Lectura del giroscopio

El giroscopio permite consultar la velocidad angular del dispositivo en sus tres ejes:

- X: rotación alrededor del eje X.
- Y: rotación alrededor del eje Y.
- Z: rotación alrededor del eje Z.

Los valores se actualizan conforme el dispositivo proporciona nuevos eventos de los sensores.

### 6.5. Tarjeta de evidencia

La tarjeta de evidencia concentra los datos obtenidos durante la inspección.

**Información que debe contener:**

1. Fotografía capturada.
2. Fecha y hora.
3. Valores del acelerómetro X, Y y Z.
4. Valores del giroscopio X, Y y Z.

Esta presentación permite consultar la información de la inspección desde un solo componente visual.

## 7. Manejo de permisos y cancelaciones

La aplicación debe contemplar situaciones en las que el usuario no autorice el acceso a la cámara o decida cancelar la captura.

| Situación | Comportamiento esperado |
|---|---|
| Permiso concedido | Permitir acceder a la cámara. |
| Permiso denegado | Informar al usuario que necesita conceder el permiso. |
| Captura cancelada | Mantener la pantalla funcionando sin generar una nueva evidencia. |
| Error al abrir la cámara | Mostrar un mensaje informativo. |
| Fotografía capturada | Actualizar la tarjeta con la nueva imagen y sus datos. |

**Nota:** La cancelación debe comprobarse cuando el selector de imágenes devuelve un resultado nulo. También se debe verificar el comportamiento de los permisos en el dispositivo físico.

## 8. Ejemplo guiado funcionando

El ejemplo guiado consiste en demostrar la integración de la cámara y los sensores dentro de una misma pantalla.

### Procedimiento de ejecución

1. Iniciar la aplicación en un dispositivo Android.
2. Verificar que aparezca la pantalla de cámara y sensores.
3. Consultar los valores actuales del acelerómetro.
4. Mover e inclinar el dispositivo para observar los cambios.
5. Consultar los valores del giroscopio.
6. Presionar el botón **Tomar fotografía**.
7. Autorizar el acceso a la cámara cuando sea necesario.
8. Capturar una fotografía.
9. Verificar que aparezca la imagen junto con la fecha, hora y valores de los sensores.
10. Comprobar que la aplicación continúa funcionando al cancelar una captura.

## 9. Avance del proyecto integrador

El proyecto integrador consiste en el desarrollo de una aplicación móvil complementaria para la gestión de eventos académicos.

La aplicación está orientada al personal de apoyo y contempla la integración con el backend del sistema web mediante servicios API.

### Tecnologías del proyecto integrador

- Flutter y Dart para la aplicación móvil.
- Laravel para el backend.
- PostgreSQL para la base de datos.
- ObjectBox para almacenamiento local y funcionamiento sin conexión.

### Avances del proyecto

| Módulo o funcionalidad | Descripción |
|---|---|
| Autenticación | Acceso de usuarios mediante el servicio de autenticación del backend. |
| Gestión de sesiones | Administración del token y persistencia de la sesión. |
| Consulta de eventos | Obtención de información de eventos académicos. |
| Consulta de actividades | Visualización de actividades relacionadas con los eventos. |
| Información de salas | Consulta de espacios y horarios disponibles. |
| Funcionamiento offline | Uso de almacenamiento local para consultar información previamente sincronizada. |
| Interfaz móvil | Desarrollo de pantallas y componentes reutilizables. |

**Importante:** Este apartado describe el alcance y los módulos del proyecto integrador. En la entrega deben identificarse como terminados únicamente los módulos que estén implementados y comprobados en el commit final.

## 10. Evidencias solicitadas

Se deben incorporar capturas de pantalla que permitan comprobar el funcionamiento de la aplicación.

| N.º | Evidencia | Descripción |
|---|---|---|
| 1 | Pantalla principal | Mostrar la interfaz inicial de la aplicación. |
| 2 | Captura fotográfica | Mostrar la fotografía obtenida mediante la cámara. |
| 3 | Fecha y hora | Mostrar el momento de captura de la fotografía. |
| 4 | Acelerómetro | Mostrar los valores X, Y y Z. |
| 5 | Giroscopio | Mostrar los valores X, Y y Z. |
| 6 | Tarjeta de evidencia | Mostrar todos los datos integrados en una misma tarjeta. |
| 7 | Permisos | Mostrar el comportamiento al solicitar o denegar permisos. |
| 8 | Cancelación | Mostrar que cancelar la cámara no provoca errores. |
| 9 | Proyecto integrador | Mostrar evidencias de los módulos móviles implementados. |
| 10 | Pruebas | Mostrar los resultados de `flutter analyze` y `flutter test`. |

### Espacio para evidencias

Las siguientes secciones pueden completarse insertando las capturas correspondientes.

**Evidencia 1. Pantalla principal**

Agregar captura de pantalla.

**Evidencia 2. Fotografía capturada**

Agregar captura de pantalla.

**Evidencia 3. Fecha y hora**

Agregar captura de pantalla.

**Evidencia 4. Valores del acelerómetro y giroscopio**

Agregar captura de pantalla.

**Evidencia 5. Tarjeta de evidencia completa**

Agregar captura de pantalla.

**Evidencia 6. Manejo de permisos y cancelación**

Agregar captura de pantalla.

**Evidencia 7. Avance del proyecto integrador**

Agregar capturas de los módulos implementados.

**Evidencia 8. Pruebas de funcionamiento**

Agregar captura de los resultados de la terminal.

## 11. Instalación y ejecución

### Requisitos previos

- Flutter SDK instalado.
- Dart SDK compatible.
- Visual Studio Code.
- Dispositivo Android físico o emulador compatible.
- Cámara y sensores disponibles para comprobar todas las funcionalidades.

### Clonar el repositorio

```bash
git clone URL_DEL_REPOSITORIO
```

### Acceder al proyecto

```bash
cd gestion_eventos_staff_movil
```

### Instalar dependencias

```bash
flutter pub get
```

### Limpiar archivos temporales

```bash
flutter clean
```

### Ejecutar la aplicación

```bash
flutter run
```

## 12. Pruebas y validación

Se utilizan los siguientes comandos para comprobar el proyecto:

### Análisis estático

```bash
flutter analyze
```

Resultado obtenido durante la revisión inicial:

```text
1 issue found.
```

El resultado correspondió a una sugerencia de estilo relacionada con el uso de parámetros `super`.

### Pruebas automatizadas

```bash
flutter test
```

Resultado obtenido:

```text
00:16 +1: All tests passed!
```

La prueba de widget existente fue ejecutada correctamente.

**Nota:** Estos resultados corresponden a la revisión realizada antes de los cambios adicionales de la bitácora. Se deben volver a ejecutar ambos comandos sobre la versión final antes de entregar.

## 13. Repositorios y enlaces de GitHub

Los siguientes enlaces permiten consultar el código fuente y verificar los avances del proyecto.

| Recurso | Enlace |
|---|---|
| Repositorio del ejercicio evaluable | PEGAR_URL_DEL_REPOSITORIO |
| Repositorio del proyecto integrador | PEGAR_URL_DEL_PROYECTO_INTEGRADOR |
| Commit final evaluado | PEGAR_URL_DEL_COMMIT |
| Rama de trabajo | PEGAR_NOMBRE_DE_LA_RAMA |

Los enlaces deben dirigir a repositorios y commits accesibles para el docente.

## 14. Declaración del commit final

La evaluación se realizará sobre el commit final declarado por el equipo.

**Datos de entrega:**

- **Repositorio:** [Nombre del repositorio]
- **Rama:** [Nombre de la rama]
- **Hash del commit final:** [Hash completo del commit]
- **Fecha del commit:** [Fecha]
- **Integrantes:** [Nombres de los integrantes]

Para consultar el último commit desde la terminal:

```bash
git log -1 --oneline
```

Para obtener el hash completo:

```bash
git rev-parse HEAD
```

Para consultar el estado del repositorio:

```bash
git status
```

Antes de declarar el commit final, se debe comprobar que los cambios estén guardados y enviados al repositorio remoto.

## 15. Conclusión

El desarrollo de la bitácora de inspección permite aplicar conocimientos de programación móvil mediante la integración de funcionalidades nativas del dispositivo, como la cámara, el acelerómetro y el giroscopio.

La aplicación permite reunir información visual, temporal y técnica en una tarjeta de evidencia, facilitando la consulta de los datos generados durante una inspección.

Asimismo, el ejercicio permite fortalecer los conocimientos adquiridos en Flutter y Dart, los cuales pueden aprovecharse en el desarrollo del proyecto integrador de gestión de eventos académicos.

---

**Instituto Tecnológico Superior de Calkiní en el Estado de Campeche (ITESCAM)**

**Asignatura:** Tópicos de Programación Móvil

**Entrega:** Ejercicio evaluable - Bitácora de inspección