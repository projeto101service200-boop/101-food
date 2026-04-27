import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productName;
  final double basePrice;

  const ProductDetailScreen({
    super.key,
    required this.productName,
    required this.basePrice,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;
  String _selectedSize = 'Média';
  final Set<String> _selectedAddons = {};

  final Map<String, double> _sizes = {
    'Broto': -5.0,
    'Média': 0.0,
    'Grande': 10.0,
    'Família': 18.0,
  };

  final Map<String, double> _addons = {
    'Queijo Extra': 5.0,
    'Bacon': 4.5,
    'Borda Recheada': 8.0,
    'Azeitonas Pretas': 3.0,
  };

  double get _totalPrice {
    double price = widget.basePrice + _sizes[_selectedSize]!;
    for (var addon in _selectedAddons) {
      price += _addons[addon]!;
    }
    return price * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1574071318508-1cdbad80ad38?w=800',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.productName,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'Sua pizza favorita feita com ingredientes frescos e selecionados. Escolha o tamanho e adicione o que quiser.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        
                        // Sizes
                        const Text('ESCOLHA O TAMANHO', 
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        const SizedBox(height: 12),
                        ..._sizes.keys.map((size) => RadioListTile<String>(
                              title: Text(size),
                              value: size,
                              groupValue: _selectedSize,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (val) => setState(() => _selectedSize = val!),
                              secondary: Text(
                                _sizes[size]! >= 0 
                                  ? '+ R\$ ${_sizes[size]!.toStringAsFixed(2)}' 
                                  : '- R\$ ${(_sizes[size]!.abs()).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            )),

                        const SizedBox(height: 24),
                        
                        // Addons
                        const Text('ADICIONAIS', 
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        const SizedBox(height: 12),
                        ..._addons.keys.map((addon) => CheckboxListTile(
                              title: Text(addon),
                              value: _selectedAddons.contains(addon),
                              activeColor: AppTheme.primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  if (val!) {
                                    _selectedAddons.add(addon);
                                  } else {
                                    _selectedAddons.remove(addon);
                                  }
                                });
                              },
                              secondary: Text('+ R\$ ${_addons[addon]!.toStringAsFixed(2)}'),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))
              ],
            ),
            child: Row(
              children: [
                // Quantity Selector
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1),
                        icon: const Icon(Icons.remove, size: 20),
                      ),
                      Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final item = CartItem(
                        id: widget.productName, // Usando nome como ID por enquanto
                        name: widget.productName,
                        price: _totalPrice / _quantity,
                        quantity: _quantity,
                        size: _selectedSize,
                        addons: _selectedAddons.toList(),
                      );
                      ref.read(cartProvider.notifier).addItem(item, 'mock_restaurant_id');
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item adicionado ao carrinho!')),
                      );
                    },
                    child: Text('ADICIONAR • R\$ ${_totalPrice.toStringAsFixed(2)}'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
