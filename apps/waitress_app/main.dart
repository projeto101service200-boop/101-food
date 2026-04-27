import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: WaitressApp()));
}

import 'lib/screens/table_management_screen.dart';
import 'lib/screens/manual_order_screen.dart';

class WaitressApp extends StatelessWidget {
  const WaitressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velox Waitress',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => const WaitressDashboard(),
        '/tables': (context) => const TableManagementScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/manual-order') {
          final int tableNumber = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => ManualOrderScreen(tableNumber: tableNumber),
          );
        }
        return null;
      },
    );
  }
}

class WaitressDashboard extends StatelessWidget {
  const WaitressDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Garçom'),
        backgroundColor: Colors.deepPurple.shade50,
      ),
      body: Column(
        children: [
          _buildActiveTablesSummary(context),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.orange),
                SizedBox(width: 8),
                Text('CHAMADOS E PEDIDOS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildNotificationTile('Mesa 05', 'Novo Pedido: 2x Burger, 1x Coca', 'há 2 min', true),
                _buildNotificationTile('Mesa 12', 'Cliente Chamando Garçom', 'há 5 min', false),
                _buildNotificationTile('Mesa 03', 'Pedido de Conta', 'há 10 min', false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
      ),
    );
  }

  Widget _buildActiveTablesSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/tables'),
            child: const _StatItem(label: 'Mesas Ativas', value: '8'),
          ),
          const _StatItem(label: 'Pedidos Pendentes', value: '3'),
          const _StatItem(label: 'Total em Aberto', value: 'R$ 420'),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(String table, String message, String time, bool isUrgent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isUrgent ? Colors.orange.shade200 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isUrgent ? Colors.orange : Colors.deepPurple,
            child: Text(table.split(' ')[1], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: TextStyle(fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal)),
                Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.check_circle_outline, color: Colors.green)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
