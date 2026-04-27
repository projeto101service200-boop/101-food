import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/service_providers.dart';
import '../theme/app_theme.dart';
import 'package:shared_core/models/order_model.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isLoading = false;
  String _paymentMethod = 'CASH'; // 'CASH' ou 'PIX'

  @override
  Widget build(BuildContext context) {
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

  Future<void> _handleCheckout(bool isDineIn, CartState cart) async {
    setState(() => _isLoading = true);
    try {
      final user = ref.read(userStateProvider).value;
      if (user == null) throw Exception('Usuário não autenticado');

      final order = OrderModel(
        orderId: '', // Gerado pelo Firestore
        customerId: user.uid,
        restaurantId: 'res_001', // Mock por enquanto
        items: cart.items.map((item) => {
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'size': item.size,
        }).toList(),
        paymentMethod: _paymentMethod,
        orderStatus: OrderStatus.PENDING,
        subTotal: cart.total,
        deliveryFee: isDineIn ? 0.0 : 5.0,
        total: cart.total + (isDineIn ? 0.0 : 5.0),
        type: isDineIn ? 'DINE_IN' : 'DELIVERY',
        tableNumber: isDineIn ? '05' : null,
        createdAt: DateTime.now(),
      );

      await ref.read(databaseServiceProvider).createOrder(order);
      
      if (_paymentMethod == 'PIX') {
        _showPixPayment(cart.total + (isDineIn ? 0.0 : 5.0), isDineIn);
        return;
      }

      // Limpar carrinho
      ref.read(cartProvider.notifier).clear();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/tracking', arguments: {'type': isDineIn ? 'DINE_IN' : 'DELIVERY'});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao finalizar pedido: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showPixPayment(double amount, bool isDineIn) async {
    final database = ref.read(databaseServiceProvider);
    final pixData = await database.generatePix(amount);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pagamento via Pix', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Escaneie o QR Code ou copie a chave abaixo', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Image.network(pixData['qrCodeUrl'], height: 200),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(child: Text(pixData['payload'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'monospace', fontSize: 12))),
                  const SizedBox(width: 8),
                  const Icon(Icons.copy, size: 20, color: AppTheme.primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(cartProvider.notifier).clear();
                Navigator.pushReplacementNamed(context, '/tracking', arguments: {'type': isDineIn ? 'DINE_IN' : 'DELIVERY'});
              },
              child: const Text('JÁ PAGUEI'),
            ),
            const SizedBox(height: 16),
          ],
        ),
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
    return Column(
      children: [
        _paymentOption('PIX', 'Pix (Rápido e Seguro)', Icons.qr_code, Colors.indigo),
        const SizedBox(height: 12),
        _paymentOption('CASH', 'Dinheiro (na entrega)', Icons.payments_outlined, Colors.green),
      ],
    );
  }

  Widget _paymentOption(String id, String label, IconData icon, Color color) {
    bool isSelected = _paymentMethod == id;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))),
            if (isSelected) Icon(Icons.check_circle, color: color, size: 20),
          ],
        ),
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
            onPressed: _isLoading ? null : () => _handleCheckout(isDineIn, cart),
            child: _isLoading 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(isDineIn ? 'ENVIAR PEDIDO PARA COZINHA' : 'FINALIZAR PEDIDO'),
          ),
        ],
      ),
    );
  }
}
