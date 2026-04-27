import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DineInScannerScreen extends StatefulWidget {
  const DineInScannerScreen({super.key});

  @override
  State<DineInScannerScreen> createState() => _DineInScannerScreenState();
}

class _DineInScannerScreenState extends State<DineInScannerScreen> {
  final TextEditingController _tableController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comanda Digital')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 100, color: AppTheme.primaryColor),
            const SizedBox(height: 24),
            const Text(
              'Escaneie o QR Code na sua mesa',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ou digite o código da mesa abaixo para acessar o cardápio e fazer seu pedido.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _tableController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Código da Mesa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_tableController.text.isNotEmpty) {
                  // Simular amarração com mesa e navegar para o menu
                  Navigator.pushNamed(context, '/menu', arguments: {
                    'name': 'Restaurante Exemplo',
                    'tableId': _tableController.text,
                    'type': 'DINE_IN'
                  });
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 54)),
              child: const Text('ACESSAR CARDÁPIO'),
            ),
          ],
        ),
      ),
    );
  }
}
