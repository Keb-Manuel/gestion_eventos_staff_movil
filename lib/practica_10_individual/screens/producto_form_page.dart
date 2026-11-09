import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';
import '../providers/inventario_provider.dart';

class ProductoFormPage extends StatefulWidget {
  final Producto? producto;

  const ProductoFormPage({
    super.key,
    this.producto,
  });

  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();
}

class _ProductoFormPageState extends State<ProductoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  final _stockMinimoController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? _imagen;
  bool _guardando = false;

  bool get _editando => widget.producto != null;

  @override
  void initState() {
    super.initState();

    final producto = widget.producto;

    if (producto != null) {
      _nombreController.text = producto.nombre;
      _descripcionController.text = producto.descripcion;
      _categoriaController.text = producto.categoria;
      _precioController.text = producto.precio.toString();
      _stockController.text = producto.stock.toString();
      _stockMinimoController.text = producto.stockMinimo.toString();
      _imagen = producto.imagen;
    } else {
      _stockController.text = '0';
      _stockMinimoController.text = '5';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _categoriaController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    _stockMinimoController.dispose();
    super.dispose();
  }

  Future<void> _tomarFotografia() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        maxWidth: 1200,
      );

      if (foto == null) return;

      final directorio = await getApplicationDocumentsDirectory();
      final carpetaFotos = Directory(
        path.join(directorio.path, 'fotografias_productos'),
      );

      if (!await carpetaFotos.exists()) {
        await carpetaFotos.create(recursive: true);
      }

      final extension = path.extension(foto.path);
      final nombreArchivo =
          'producto_${DateTime.now().millisecondsSinceEpoch}$extension';

      final destino = path.join(carpetaFotos.path, nombreArchivo);

      final archivoGuardado = await File(foto.path).copy(destino);

      if (!mounted) return;

      setState(() {
        _imagen = archivoGuardado.path;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo tomar la fotografía: $e'),
        ),
      );
    }
  }

  Widget _construirImagen() {
    if (_imagen == null || _imagen!.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, size: 45, color: Colors.grey),
          SizedBox(height: 8),
          Text('Sin fotografía'),
        ],
      );
    }

    if (_imagen!.startsWith('http')) {
      return Image.network(
        _imagen!,
        fit: BoxFit.cover,
       errorBuilder: (context, error, stackTrace) =>
    const Icon(Icons.broken_image, size: 45),
      );
    }

    return Image.file(
      File(_imagen!),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
    const Icon(Icons.broken_image, size: 45),
    );
  }

  String? _validarTexto(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Ingresa $campo.';
    }

    if (valor.trim().length < 2) {
      return '$campo debe tener al menos 2 caracteres.';
    }

    return null;
  }

  String? _validarPrecio(String? valor) {
    final precio = double.tryParse(valor ?? '');

    if (precio == null || !precio.isFinite || precio <= 0) {
      return 'Ingresa un precio válido mayor a cero.';
    }

    return null;
  }

  String? _validarEntero(String? valor, String campo) {
    final numero = int.tryParse(valor ?? '');

    if (numero == null || numero < 0) {
      return 'Ingresa un número válido para $campo.';
    }

    return null;
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final productoOriginal = widget.producto;

    final producto = Producto(
      id: productoOriginal?.id,
      apiId: productoOriginal?.apiId,
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      categoria: _categoriaController.text.trim(),
      precio: double.parse(_precioController.text),
      stock: int.parse(_stockController.text),
      stockMinimo: int.parse(_stockMinimoController.text),
      imagen: _imagen,
      fechaRegistro:
          productoOriginal?.fechaRegistro ?? DateTime.now(),
    );

    final provider = context.read<InventarioProvider>();
    final resultado = await provider.guardarProducto(producto);

    if (!mounted) return;

    setState(() => _guardando = false);

    if (resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editando
                ? 'Producto actualizado correctamente.'
                : 'Producto registrado correctamente.',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ?? 'No se pudo guardar el producto.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: Text(
          _editando ? 'Editar producto' : 'Registrar producto',
        ),
        backgroundColor: const Color(0xFF172554),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Información del producto',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: _tomarFotografia,
                child: Container(
                  width: 180,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _construirImagen(),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: TextButton.icon(
                onPressed: _tomarFotografia,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar fotografía'),
              ),
            ),

            const SizedBox(height: 20),

            _campo(
              controller: _nombreController,
              etiqueta: 'Nombre del producto',
              icono: Icons.inventory_2,
              validator: (valor) =>
                  _validarTexto(valor, 'el nombre'),
            ),

            _campo(
              controller: _descripcionController,
              etiqueta: 'Descripción',
              icono: Icons.description,
              maxLines: 3,
              validator: (valor) =>
                  _validarTexto(valor, 'la descripción'),
            ),

            _campo(
              controller: _categoriaController,
              etiqueta: 'Categoría',
              icono: Icons.category,
              validator: (valor) =>
                  _validarTexto(valor, 'la categoría'),
            ),

            _campo(
              controller: _precioController,
              etiqueta: 'Precio',
              icono: Icons.attach_money,
              teclado: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validarPrecio,
            ),

            Row(
              children: [
                Expanded(
                  child: _campo(
                    controller: _stockController,
                    etiqueta: 'Existencias',
                    icono: Icons.widgets,
                    teclado: TextInputType.number,
                    validator: (valor) =>
                        _validarEntero(valor, 'las existencias'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _campo(
                    controller: _stockMinimoController,
                    etiqueta: 'Stock mínimo',
                    icono: Icons.warning_amber,
                    teclado: TextInputType.number,
                    validator: (valor) =>
                        _validarEntero(valor, 'el stock mínimo'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _guardando ? null : _guardarProducto,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF172554),
                ),
                icon: _guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _guardando
                      ? 'Guardando...'
                      : 'Guardar producto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String etiqueta,
    required IconData icono,
    required String? Function(String?) validator,
    TextInputType teclado = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: teclado,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: etiqueta,
          prefixIcon: Icon(icono),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}