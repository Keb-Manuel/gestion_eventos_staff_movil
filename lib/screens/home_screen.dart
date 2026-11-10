import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import '../widgets/contador_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/app_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arquitectura Flutter'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppHeader(),
                const SizedBox(height: 32),
                Consumer<ContadorProvider>(
                  builder: (context, contador, child) {
                    return ContadorCard(
                      valor: contador.valor,
                    );
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  texto: 'Incrementar',
                  icono: Icons.add,
                  onPressed: () {
                    context.read<ContadorProvider>().incrementar();
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  texto: 'Disminuir',
                  icono: Icons.remove,
                  onPressed: () {
                    context.read<ContadorProvider>().disminuir();
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  texto: 'Reiniciar',
                  icono: Icons.refresh,
                  onPressed: () {
                    context.read<ContadorProvider>().reiniciar();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
