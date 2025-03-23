import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart.dart';

import 'package:havahavai_app/providers/cart_provider.dart';

class Categories extends ConsumerStatefulWidget {
  const Categories({super.key});

  @override
  ConsumerState<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse("https://dummyjson.com/products"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["products"];
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error fetching data : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Catalogue"),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cart()),
                  );
                },
                icon: Icon(Icons.shopping_cart_outlined),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  top: 3,
                  right: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.pink,
                    child: Text(
                      cart.length.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
        backgroundColor: Colors.pink[50],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products found!"));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.6,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                final brand = product["brand"];
                final discountAmount =
                    product["price"] * product["discountPercentage"] / 100;
                final discountPrice = product["price"] - discountAmount;
                final finalPrice = discountPrice.toStringAsFixed(2);
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                product["thumbnail"],
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addToCart(product);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[100],
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 30,
                                    ),
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 5,
                          right: 5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product["title"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              brand == null ? "" : product["brand"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "\u20B9${product["price"]}",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "  \u20B9$finalPrice",
                                  style: TextStyle(
                                    fontSize: 15,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
