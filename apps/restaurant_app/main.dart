import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: RestaurantApp()));
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velox Restaurant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const RestaurantLoginScreen(),
        '/dashboard': (context) => const RestaurantDashboard(),
      },
    );
  }
}

class RestaurantLoginScreen extends StatelessWidget {
  const RestaurantLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Velox Vendor', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 8),
            const Text('Gerencie seu restaurante com facilidade', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 48),
            const TextField(decoration: InputDecoration(labelText: 'Email do Proprietário', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Senha', border: OutlineInputBorder())),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('ENTRAR NO PAINEL'),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantDashboard extends StatelessWidget {
  const RestaurantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Restaurante'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow(),
            const SizedBox(height: 32),
            const Text('PEDIDOS DE MESA (DINE-IN)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            _buildDineInList(),
            const SizedBox(height: 32),
            const Text('DELIVERY RECENTES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildOrderTile('Pedido #1024', 'João Silva', 'R$ 54.00', 'PENDENTE'),
                  _buildOrderTile('Pedido #1023', 'Maria Oliveira', 'R$ 42.50', 'PREPARANDO'),
                  _buildOrderTile('Pedido #1022', 'Carlos Souza', 'R$ 89.90', 'PRONTO'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Cardápio'),
          BottomNavigationBarItem(icon: Icon(Icons.table_bar), label: 'Mesas'),
        ],
      ),
    );
  }

  Widget _buildDineInList() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTableMiniCard('Mesa 01', 'Ocupada', Colors.blue),
          _buildTableMiniCard('Mesa 02', 'Novo Pedido', Colors.orange),
          _buildTableMiniCard('Mesa 03', 'Livre', Colors.green),
          _buildTableMiniCard('Mesa 04', 'Ocupada', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildTableMiniCard(String name, String status, Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          Text(status, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    return Row(
      children: [
        _buildStatCard('Hoje', 'R$ 450,00', Icons.monetization_on, Colors.green),
        const SizedBox(width: 16),
        _buildStatCard('Pedidos', '12', Icons.shopping_bag, Colors.blue),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTile(String id, String customer, String total, String status) {
    Color statusColor = status == 'PENDENTE' ? Colors.orange : (status == 'PREPARANDO' ? Colors.blue : Colors.green);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(customer, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(total, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(status, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
