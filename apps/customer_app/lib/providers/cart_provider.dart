import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? size;
  final List<String> addons;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.size,
    this.addons = const [],
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
      size: size,
      addons: addons,
    );
  }
}

class CartState {
  final List<CartItem> items;
  final String? restaurantId;

  CartState({this.items = const [], this.restaurantId});

  double get total => items.fold(0, (total, item) => total + (item.price * item.quantity));
  int get count => items.fold(0, (count, item) => count + item.quantity);

  CartState copyWith({List<CartItem>? items, String? restaurantId}) {
    return CartState(
      items: items ?? this.items,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addItem(CartItem item, String restaurantId) {
    // Se o restaurante for diferente, limpamos o carrinho anterior (comportamento padrão delivery)
    if (state.restaurantId != null && state.restaurantId != restaurantId) {
      state = CartState(items: [item], restaurantId: restaurantId);
      return;
    }

    final index = state.items.indexWhere((i) => i.id == item.id && i.size == item.size && _listEquals(i.addons, item.addons));

    if (index >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[index] = updatedItems[index].copyWith(quantity: updatedItems[index].quantity + item.quantity);
      state = state.copyWith(items: updatedItems, restaurantId: restaurantId);
    } else {
      state = state.copyWith(items: [...state.items, item], restaurantId: restaurantId);
    }
  }

  void removeItem(String id) {
    state = state.copyWith(items: state.items.where((i) => i.id != id).toList());
    if (state.items.isEmpty) {
      state = CartState();
    }
  }

  void clear() {
    state = CartState();
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
