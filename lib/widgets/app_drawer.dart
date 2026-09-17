import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.code,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Práctica 02',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text('Dart, Widgets y Estado'),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Ejemplo guiado'),
              subtitle: const Text('Calculadora de propina'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/propina');
              },
            ),

            ListTile(
              leading: const Icon(Icons.local_gas_station),
              title: const Text('Práctica evaluable'),
              subtitle: const Text('Consumo de combustible'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  '/combustible',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}