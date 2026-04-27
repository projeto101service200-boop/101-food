import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: WaitressApp()));
}

import 'lib/screens/table_management_screen.dart';
import 'lib/screens/manual_order_screen.dart';
import 'lib/screens/split_bill_screen.dart';
import 'lib/providers/service_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        if (settings.name == '/split-bill') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => SplitBillScreen(
              tableNumber: args['tableNumber'],
              totalAmount: args['totalAmount'],
            ),
          );
        }
        return null;
      },
    );
  }
}

class WaitressDashboard extends ConsumerWidget {
  const WaitressDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

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
            child: notificationsAsync.when(
              data: (snapshot) {
                if (snapshot.docs.isEmpty) {
                  return const Center(child: Text('Nenhuma notificação nova.'));
                }
                return ListView(
                  children: snapshot.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final type = data['type'] ?? '';
                    
                    Color statusColor = Colors.deepPurple;
                    IconData icon = Icons.notifications;
                    String message = data['message'] ?? 'Notificação';
                    bool isUrgent = false;

                    if (type == 'CALL_WAITER') {
                      statusColor = Colors.red;
                      icon = Icons.pan_tool;
                      isUrgent = true;
                    } else if (type == 'BILL_REQUEST') {
                      statusColor = Colors.green;
                      icon = Icons.receipt_long;
                      isUrgent = true;
                    } else if (type == 'DINE_IN') {
                      statusColor = Colors.orange;
                      icon = Icons.restaurant_menu;
                    }

                    return _buildNotificationTile(
                      data['tableNumber'] ?? 'Mesa ?',
                      message,
                      'agora',
                      isUrgent,
                      doc.id,
                      ref,
                      statusColor,
                      icon
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erro: $err')),
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

  Widget _buildNotificationTile(String table, String message, String time, bool isUrgent, String docId, WidgetRef ref, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUrgent ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isUrgent ? color.withOpacity(0.3) : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: TextStyle(fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal, color: isUrgent ? color : Colors.black)),
                Text('Mesa ${table.contains(' ') ? table.split(' ')[1] : table} • $time', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Marcar como lida/Concluída deletando ou trocando status
              FirebaseFirestore.instance.collection('notifications').doc(docId).delete();
            }, 
            icon: const Icon(Icons.check_circle_outline, color: Colors.green)
          ),
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
