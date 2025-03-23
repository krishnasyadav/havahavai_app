import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:havahavai_app/providers/cart_provider.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({super.key});

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    double totalAmount = cart.fold(0, (sum, item) {
      double discountAmount = item["price"] * item["discountPercentage"] / 100;
      double discountedPrice = item["price"] - discountAmount;
      return sum + (discountedPrice * (item["quantity"] ?? 1));
    });

    int totalItems = cart.fold<int>(
      0,
      (sum, item) => sum + (item["quantity"] as int? ?? 1),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        centerTitle: true,
        backgroundColor: Colors.pink[50],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                cart.isEmpty
                    ? Center(child: Text("Your cart is Empty"))
                    : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final product = cart[index];
                        final brand = product["brand"];
                        final discountAmount =
                            product["price"] *
                            product["discountPercentage"] /
                            100;
                        final discountPrice = product["price"] - discountAmount;
                        final finalPrice = discountPrice.toStringAsFixed(2);
                        final quantity = product["quantity"] ?? 1;

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(8),
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 6.5,
                                width: MediaQuery.of(context).size.height / 7.5,
                                color: Colors.white,
                                child: Image.network(product["thumbnail"]),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product["title"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      brand == null ? "" : product["brand"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "\u20B9${product["price"]}",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          "  \u20B9$finalPrice",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${product["discountPercentage"]}% OFF",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.pink,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            color: Colors.grey[100],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (quantity > 1) {
                                                    cartNotifier.updateQuantity(
                                                      product,
                                                      quantity - 1,
                                                    );
                                                  } else {
                                                    cartNotifier.removeFromCart(
                                                      index,
                                                    );
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                ),
                                              ),
                                              Text(
                                                "$quantity",
                                                style: TextStyle(
                                                  color: Colors.pink,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  cartNotifier.updateQuantity(
                                                    product,
                                                    quantity + 1,
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Amount Price"),
                    Text(
                      "\u20B9${totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Check Out  ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 8,
                          child: Text(
                            totalItems.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ],
                    ),
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
