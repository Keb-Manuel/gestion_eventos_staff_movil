import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class PropinaPage extends StatefulWidget {
  const PropinaPage({super.key});

  @override
  State<PropinaPage> createState() => _PropinaPageState();
}

class _PropinaPageState extends State<PropinaPage> {
  final consumo = TextEditingController();

  double porcentaje = 10;
  double propina = 0;
  double total = 0;

  void calcular() {
    final valor = double.tryParse(consumo.text) ?? 0;

    setState(() {
      propina = valor * porcentaje / 100;
      total = valor + propina;
    });
  }

  void limpiar() {
    consumo.clear();

    setState(() {
      propina = 0;
      total = 0;
      porcentaje = 10;
    });
  }

  @override
  void dispose() {
    consumo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de propina'),
      ),

      drawer: const AppDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: consumo,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Consumo',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Propina: ${porcentaje.toInt()} %',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Slider(
              value: porcentaje,
              min: 0,
              max: 30,
              divisions: 6,
              label: '${porcentaje.toInt()}%',
              onChanged: (valor) {
                setState(() {
                  porcentaje = valor;
                });
              },
            ),

            const SizedBox(height: 10),

            FilledButton.icon(
              onPressed: calcular,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular'),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: limpiar,
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar'),
            ),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Propina',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '\$${propina.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    const Divider(height: 30),

                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
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