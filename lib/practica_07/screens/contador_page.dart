import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';

class ContadorPage extends StatelessWidget {
  const ContadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contador = context.watch<ContadorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo guiado: Provider'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Valor del contador',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              '${contador.contador}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: contador.decrementar,
                  child: const Text('Disminuir'),
                ),
                ElevatedButton(
                  onPressed: contador.incrementar,
                  child: const Text('Aumentar'),
                ),
                ElevatedButton(
                  onPressed: contador.reiniciar,
                  child: const Text('Reiniciar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
