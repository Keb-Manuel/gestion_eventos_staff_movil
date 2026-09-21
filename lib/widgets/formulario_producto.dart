import 'package:flutter/material.dart';
import '../models/producto.dart';

class FormularioProducto extends StatefulWidget {
  final void Function(Producto producto) onAgregar;

  const FormularioProducto({
    super.key,
    required this.onAgregar,
  });

  @override
  State<FormularioProducto> createState() => _FormularioProductoState();
}

class _FormularioProductoState extends State<FormularioProducto> {
  final formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final existenciaController = TextEditingController();

  String? categoriaSeleccionada;

  final List<String> categorias = [
    'Electrónica',
    'Papelería',
    'Mobiliario',
    'Software',
    'Otros',
  ];

  @override
  void dispose() {
    nombreController.dispose();
    precioController.dispose();
    existenciaController.dispose();
    super.dispose();
  }

  void agregarProducto() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final nombre = nombreController.text.trim();
    final categoria = categoriaSeleccionada!;
    final precio = double.parse(precioController.text.trim());
    final existencia = int.parse(existenciaController.text.trim());

    final producto = Producto(
      nombre: nombre,
      categoria: categoria,
      precio: precio,
      existencia: existencia,
    );

    widget.onAgregar(producto);

    formKey.currentState!.reset();

    nombreController.clear();
    precioController.clear();
    existenciaController.clear();

    setState(() {
      categoriaSeleccionada = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto agregado correctamente'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre del producto',
              prefixIcon: Icon(Icons.inventory_2),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El nombre es obligatorio';
              }

              if (value.trim().length < 3) {
                return 'Debe tener al menos 3 caracteres';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: categoriaSeleccionada,
            decoration: const InputDecoration(
              labelText: 'Categoría',
              prefixIcon: Icon(Icons.category),
            ),
            items: categorias.map((categoria) {
              return DropdownMenuItem(
                value: categoria,
                child: Text(categoria),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                categoriaSeleccionada = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecciona una categoría';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: precioController,
            decoration: const InputDecoration(
              labelText: 'Precio',
              prefixIcon: Icon(Icons.attach_money),
              prefixText: '\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El precio es obligatorio';
              }

              final precio = double.tryParse(value.trim());

              if (precio == null) {
                return 'Ingresa un precio válido';
              }

              if (precio <= 0) {
                return 'El precio debe ser mayor que 0';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: existenciaController,
            decoration: const InputDecoration(
              labelText: 'Existencia',
              prefixIcon: Icon(Icons.numbers),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La existencia es obligatoria';
              }

              final existencia = int.tryParse(value.trim());

              if (existencia == null) {
                return 'Ingresa un número entero';
              }

              if (existencia < 0) {
                return 'La existencia no puede ser negativa';
              }

              return null;
            },
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: agregarProducto,
            icon: const Icon(Icons.add),
            label: const Text('Agregar producto'),
          ),
        ],
      ),
    );
  }
}