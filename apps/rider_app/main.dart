import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: RiderApp()));
}

class RiderApp extends StatelessWidget {
  const RiderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velox Rider',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const RiderLoginScreen(),
        '/dashboard': (context) => const RiderDashboard(),
      },
    );
  }
}

class RiderLoginScreen extends StatelessWidget {
  const RiderLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Velox Rider', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 8),
            const Text('Entregue e ganhe dinheiro', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 48),
            const TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Senha', border: OutlineInputBorder())),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('COMEÇAR A ENTREGAR'),
            ),
          ],
        ),
      ),
    );
  }
}

class RiderDashboard extends StatefulWidget {
  const RiderDashboard({super.key});

  @override
  State<RiderDashboard> createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregador'),
        actions: [
          Row(
            children: [
              Text(_isOnline ? 'ONLINE' : 'OFFLINE', 
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _isOnline ? Colors.green : Colors.grey)),
              Switch(
                value: _isOnline, 
                activeColor: Colors.green,
                onChanged: (val) => setState(() => _isOnline = val),
              ),
            ],
          ),
        ],
      ),
      body: _isOnline ? _buildOnlineDashboard() : _buildOfflineDashboard(),
    );
  }

  Widget _buildOfflineDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.power_settings_new, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Você está offline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Fique online para receber pedidos', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildOnlineDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PEDIDOS DISPONÍVEIS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 16),
          _buildDeliveryRequest('Pedido #1025', 'Enatega Burgers', 'R$ 12,50', '2.5 km'),
          _buildDeliveryRequest('Pedido #1026', 'Pizza Place', 'R$ 15,00', '4.1 km'),
        ],
      ),
    );
  }

  Widget _buildDeliveryRequest(String id, String restaurant, String fee, String distance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(restaurant, style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(fee, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(distance, style: const TextStyle(color: Colors.grey)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text('ACEITAR'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
