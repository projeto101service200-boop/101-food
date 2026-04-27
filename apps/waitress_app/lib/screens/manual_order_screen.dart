import 'package:flutter/material.dart';

class ManualOrderScreen extends StatefulWidget {
  final int tableNumber;
  const ManualOrderScreen({super.key, required this.tableNumber});

  @override
  State<ManualOrderScreen> createState() => _ManualOrderScreenState();
}

class _ManualOrderScreenState extends State<ManualOrderScreen> {
  final List<Map<String, dynamic>> _selectedItems = [];

  void _addItem(String name, double price) {
    setState(() {
      _selectedItems.add({'name': name, 'price': price});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mesa ${widget.tableNumber.toString().padLeft(2, '0')} - Lançar Pedido')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCategoryHeader('BURGUERS'),
                _buildProductItem('Cheese Burger', 25.0),
                _buildProductItem('Classic Burger', 28.0),
                _buildProductItem('Veggie Burger', 30.0),
                const SizedBox(height: 16),
                _buildCategoryHeader('BEBIDAS'),
                _buildProductItem('Coca-Cola 350ml', 6.0),
                _buildProductItem('Suco Natural', 10.0),
                _buildProductItem('Cerveja Artesanal', 18.0),
              ],
            ),
          ),
          _buildCartSummary(),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildProductItem(String name, double price) {
    return ListTile(
      title: Text(name),
      trailing: Text('R\$ ${price.toStringAsFixed(2)}'),
      onTap: () => _addItem(name, price),
    );
  }

  Widget _buildCartSummary() {
    double total = _selectedItems.fold(0, (sum, item) => sum + item['price']);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_selectedItems.length} itens selecionados', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Total: R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _selectedItems.isEmpty ? null : () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pedido lançado com sucesso!'))
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('CONFIRMAR PEDIDO'),
          ),
        ],
      ),
    );
  }
}
