import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/service_providers.dart';

class KdsScreen extends ConsumerWidget {
  const KdsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KDS - Kitchen Display System'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('AUTO-REFRESH ATIVO', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: Row(
        children: [
          _buildColumn('PARA PREPARAR', [
            _buildKdsCard(context, ref, 'Pedido #1024', 'Mesa 05', [
              {'name': 'Burger Velox', 'quantity': 2},
              {'name': 'Batata G', 'quantity': 1},
              {'name': 'Coca 350ml', 'quantity': 1},
            ], '5 min'),
            _buildKdsCard(context, ref, 'Pedido #1025', 'Delivery', [
              {'name': 'Pizza G Frango', 'quantity': 1},
              {'name': 'Guaraná', 'quantity': 2},
            ], '2 min'),
          ], Colors.red.shade100),
          _buildColumn('PREPARANDO', [
            _buildKdsCard(context, ref, 'Pedido #1023', 'Mesa 02', [
              {'name': 'Burger Salad', 'quantity': 1},
              {'name': 'Suco Laranja', 'quantity': 1},
            ], '12 min'),
          ], Colors.blue.shade100),
          _buildColumn('PRONTO / EXPEDIÇÃO', [
            _buildKdsCard(context, ref, 'Pedido #1022', 'Mesa 01', [
              {'name': 'Burger Bacon', 'quantity': 2},
            ], '18 min'),
          ], Colors.green.shade100),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, List<Widget> items, Color bgColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Text(title, style: TextStyle(color: bgColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: items,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKdsCard(BuildContext context, WidgetRef ref, String id, String destination, List<Map<String, dynamic>> items, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(time, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Text(destination, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            const Divider(),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('${item['quantity']}x ${item['name']}', style: const TextStyle(fontSize: 16)),
            )),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Simular avanço de pedido e baixa no estoque
                      try {
                        await ref.read(databaseServiceProvider).updateInventory(items);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Estoque atualizado para $id!'))
                          );
                        }
                      } catch (e) {
                         if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao atualizar estoque: $e'))
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                    child: const Text('AVANÇAR'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(onPressed: () {}, icon: const Icon(Icons.print, size: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
