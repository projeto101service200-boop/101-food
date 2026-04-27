import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    final isDineIn = ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(isDineIn ? 'Confirmar Pedido na Mesa' : 'Confirmação do Pedido')),
      body: cart.items.isEmpty 
        ? const Center(child: Text('Seu carrinho está vazio'))
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(isDineIn ? 'RESTAURANTE' : 'ENTREGAR EM'),
                      const SizedBox(height: 12),
                      isDineIn ? _buildRestaurantInfo() : _buildAddressTile(),
                      const SizedBox(height: 32),
                      
                      _buildSectionHeader('ITENS DO PEDIDO'),
                      const SizedBox(height: 12),
                      ...cart.items.map((item) => _buildOrderItemTile(item)),
                      
                      const SizedBox(height: 32),
                      _buildSectionHeader('PAGAMENTO'),
                      const SizedBox(height: 12),
                      _buildPaymentTile(),
                      
                      const SizedBox(height: 32),
                      _buildSummary(cart, isDineIn),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context, cart, isDineIn),
            ],
          ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Row(
        children: [
          Icon(Icons.restaurant, color: AppTheme.primaryColor),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enatega Burgers', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Mesa 05 • Dine-in Ativo', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1));
  }

  Widget _buildAddressTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Row(
        children: [
          Icon(Icons.location_on, color: AppTheme.primaryColor),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Rua das Flores, 123 - Centro', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.keyboard_arrow_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildOrderItemTile(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('${item.quantity}x', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                if (item.size != null) Text(item.size!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text('R\$ ${(item.price * item.quantity).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildPaymentTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Row(
        children: [
          Icon(Icons.payments_outlined, color: Colors.green),
          SizedBox(width: 16),
          Expanded(child: Text('Dinheiro (na entrega)', style: TextStyle(fontWeight: FontWeight.bold))),
          Icon(Icons.keyboard_arrow_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSummary(CartState cart, bool isDineIn) {
    final deliveryFee = isDineIn ? 0.0 : 5.0;
    return Column(
      children: [
        _buildSummaryRow('Subtotal', cart.total),
        if (!isDineIn) _buildSummaryRow('Taxa de Entrega', deliveryFee),
        const Divider(height: 32),
        _buildSummaryRow('Total', cart.total + deliveryFee, isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text('R\$ ${value.toStringAsFixed(2)}', style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartState cart, bool isDineIn) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDineIn) 
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Você está na Mesa 05', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            ),
          ElevatedButton(
            onPressed: () {
              // Finalizar pedido e ir para acompanhamento
              Navigator.pushNamed(context, '/tracking', arguments: {'type': isDineIn ? 'DINE_IN' : 'DELIVERY'});
            },
            child: Text(isDineIn ? 'ENVIAR PEDIDO PARA COZINHA' : 'FINALIZAR PEDIDO'),
          ),
        ],
      ),
    );
  }
}
