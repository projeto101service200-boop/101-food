import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/cart_provider.dart';

class RestaurantMenuScreen extends ConsumerWidget {
  final String restaurantName;

  const RestaurantMenuScreen({super.key, required this.restaurantName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurantName, 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black.withOpacity(0.3)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      const Text('4.8 (500+ reviews)', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: const Text('Ver Info')),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text('CATEGORIAS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildMenuCategory('Pizza de Massa Fina', [
                  _MenuItem(
                    name: 'Margherita Clássica',
                    description: 'Molho de tomate, mozarela de búfala e manjericão fresco.',
                    price: 45.0,
                    imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbad80ad38?w=400',
                  ),
                  _MenuItem(
                    name: 'Pepperoni Especial',
                    description: 'Pepperoni artesanal premium com dobro de queijo.',
                    price: 52.0,
                  ),
                ]);
              },
              childCount: 3,
            ),
          ),
        ],
      ),
      floatingActionButton: cart.count > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/checkout', arguments: true); // True para Dine-in simulado aqui
              },
              backgroundColor: const Color(0xFFFF9100),
              label: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Text('${cart.count}', style: const TextStyle(color: Color(0xFFFF9100), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  const Text('VER CARRINHO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text('R\$ ${cart.total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildMenuCategory(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ...items.map((item) => _buildMenuItemTile(context, item)),
      ],
    );
  }

  Widget _buildMenuItemTile(BuildContext context, _MenuItem item) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: {
        'name': item.name,
        'price': item.price,
      }),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFFF9100)),
                  ),
                ],
              ),
            ),
            if (item.imageUrl != null) ...[
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item.imageUrl!, height: 80, width: 80, fit: BoxFit.cover),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  _MenuItem({required this.name, required this.description, required this.price, this.imageUrl});
}
