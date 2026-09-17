import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CombustiblePage extends StatefulWidget {
  const CombustiblePage({super.key});

  @override
  State<CombustiblePage> createState() => _CombustiblePageState();
}

class _CombustiblePageState extends State<CombustiblePage> {
  final kilometrosController = TextEditingController();
  final litrosController = TextEditingController();

  double? rendimiento;
  String clasificacion = '';
  String? error;

  void calcular() {
    FocusScope.of(context).unfocus();

    final kilometrosTexto = kilometrosController.text.trim();
    final litrosTexto = litrosController.text.trim();

    if (kilometrosTexto.isEmpty || litrosTexto.isEmpty) {
      setState(() {
        error = 'Debes completar ambos campos.';
        rendimiento = null;
        clasificacion = '';
      });
      return;
    }

    final kilometros = double.tryParse(kilometrosTexto);
    final litros = double.tryParse(litrosTexto);

    if (kilometros == null || litros == null) {
      setState(() {
        error = 'Ingresa solamente valores numéricos.';
        rendimiento = null;
        clasificacion = '';
      });
      return;
    }

    if (kilometros <= 0) {
      setState(() {
        error = 'Los kilómetros deben ser mayores que cero.';
        rendimiento = null;
        clasificacion = '';
      });
      return;
    }

    if (litros <= 0) {
      setState(() {
        error = 'Los litros deben ser mayores que cero.';
        rendimiento = null;
        clasificacion = '';
      });
      return;
    }

    final resultado = kilometros / litros;

    setState(() {
      rendimiento = resultado;
      clasificacion = clasificarRendimiento(resultado);
      error = null;
    });
  }

  String clasificarRendimiento(double valor) {
    if (valor < 8) {
      return 'BAJO';
    }

    if (valor <= 12) {
      return 'MEDIO';
    }

    return 'ALTO';
  }

  void limpiar() {
    kilometrosController.clear();
    litrosController.clear();

    setState(() {
      rendimiento = null;
      clasificacion = '';
      error = null;
    });
  }

  @override
  void dispose() {
    kilometrosController.dispose();
    litrosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumo de combustible'),
      ),

      drawer: const AppDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Calculadora de rendimiento',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              'Calcula cuántos kilómetros recorres por cada litro de combustible.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 25),

            TextField(
              controller: kilometrosController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Kilómetros recorridos',
                prefixIcon: Icon(Icons.route),
                suffixText: 'km',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: litrosController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Litros utilizados',
                prefixIcon: Icon(Icons.local_gas_station),
                suffixText: 'L',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(error!),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 10),

            FilledButton.icon(
              onPressed: calcular,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular rendimiento'),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: limpiar,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Limpiar'),
            ),

            const SizedBox(height: 30),

            if (rendimiento != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.speed,
                        size: 50,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Rendimiento',
                        style: TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        '${rendimiento!.toStringAsFixed(2)} km/L',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Clasificación: $clasificacion',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}