import 'package:flutter/material.dart';

class TableManagementScreen extends StatelessWidget {
  const TableManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Mesas')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final int tableNumber = index + 1;
          // Simular estados diferentes
          Color statusColor = Colors.green;
          String statusText = 'Livre';
          
          if (tableNumber % 4 == 0) {
            statusColor = Colors.orange;
            statusText = 'Novo Pedido';
          } else if (tableNumber % 2 == 0) {
            statusColor = Colors.blue;
            statusText = 'Ocupada';
          } else if (tableNumber == 5) {
            statusColor = Colors.red;
            statusText = 'Aguardando Garçom';
          }

          return _buildTableCard(context, tableNumber, statusText, statusColor);
        },
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, int number, String status, Color color) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/manual-order', arguments: number),
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
              child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
