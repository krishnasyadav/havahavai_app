import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
      return CartNotifier();
    });

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier() : super([]);

  void addToCart(Map<String, dynamic> product) {
    int index = state.indexWhere((item) => item["id"] == product["id"]);

    if (index != -1) {
      state = List.from(state)..[index]["quantity"] += 1;
    } else {
      state = [
        ...state,
        {...product, "quantity": 1},
      ];
    }
  }

  void updateQuantity(Map<String, dynamic> product, int quantity) {
    int index = state.indexWhere((item) => item["id"] == product["id"]);
    if (index != -1) {
      state = List.from(state)..[index]["quantity"] = quantity;
    }
  }

  void removeFromCart(int index) {
    state = List.from(state)..removeAt(index);
  }

  void clearCart() {
    state = [];
  }
}
