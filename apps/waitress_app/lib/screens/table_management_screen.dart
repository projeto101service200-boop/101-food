import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/service_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TableManagementScreen extends ConsumerWidget {
  const TableManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsync = ref.watch(tablesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Mesas')),
      body: tablesAsync.when(
        data: (snapshot) {
          // Se não houver mesas no banco, mostra as 12 fixas para demo
          final int count = snapshot.docs.isEmpty ? 12 : snapshot.docs.length;
          
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: count,
            itemBuilder: (context, index) {
              if (snapshot.docs.isNotEmpty) {
                 final doc = snapshot.docs[index];
                 final data = doc.data() as Map<String, dynamic>;
                 return _buildTableCard(
                   context, 
                   int.tryParse(data['number'] ?? '0') ?? index + 1, 
                   data['status'] ?? 'free',
                   doc.id
                 );
              }

              // Demo Fallback
              final int tableNumber = index + 1;
              String status = 'free';
              if (tableNumber % 4 == 0) status = 'new_order';
              else if (tableNumber % 2 == 0) status = 'busy';
              else if (tableNumber == 5) status = 'calling';

              return _buildTableCard(context, tableNumber, status, null);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, int number, String status, String? docId) {
    Color color = Colors.green;
    String statusText = 'Livre';

    switch (status) {
      case 'busy':
        color = Colors.blue;
        statusText = 'Ocupada';
        break;
      case 'new_order':
        color = Colors.orange;
        statusText = 'Novo Pedido';
        break;
      case 'calling':
        color = Colors.red;
        statusText = 'Chamando...';
        break;
      case 'pending_payment':
        color = Colors.purple;
        statusText = 'Pagamento';
        break;
    }

    return GestureDetector(
      onTap: () => _showTableOptions(context, number, status, docId),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('MESA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color.withOpacity(0.6))),
            Text(number.toString().padLeft(2, '0'), 
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
              child: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showTableOptions(BuildContext context, int number, String status, String? docId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_shopping_cart),
              title: const Text('Lançar Pedido Manual'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manual-order', arguments: number);
              },
            ),
            if (status != 'free') ...[
              ListTile(
                leading: const Icon(Icons.call_split, color: Colors.blue),
                title: const Text('Dividir Conta / Receber'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/split-bill', arguments: {
                    'tableNumber': number,
                    'totalAmount': 142.50, // Mock amount for now
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Liberar Mesa (Limpar)'),
                onTap: () async {
                  if (docId != null) {
                    await FirebaseFirestore.instance.collection('tables').doc(docId).update({'status': 'free'});
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Imprimir Pré-Conta'),
              onTap: () async {
                Navigator.pop(context);
                final printer = ref.read(printerServiceProvider);
                await printer.connect('BT-001');
                await printer.printTicket(
                  title: 'Velox Restaurant',
                  subtitle: 'Mesa $number - Conferência',
                  items: [
                    {'name': 'Burger Velox', 'quantity': 2, 'price': 54.00},
                    {'name': 'Coca 350ml', 'quantity': 2, 'price': 14.00},
                  ],
                  total: 68.00,
                  footer: '\nObrigado pela preferência!\nConsumo não é documento fiscal.',
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comprovante enviado para impressora!'))
                  );
                }
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
