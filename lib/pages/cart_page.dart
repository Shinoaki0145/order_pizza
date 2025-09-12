import 'package:flutter/material.dart';
import 'package:order_pizza/components/my_button.dart';
import 'package:order_pizza/components/my_cart_tile.dart';
import 'package:order_pizza/models/restaurant.dart';
import 'package:order_pizza/pages/payment_page.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(builder: (context, restaurant, child) {
      final useCart = restaurant.cart;
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // clear cart
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title:
                        const Text("Are you sure you want to clear the cart?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          restaurant.clearCart();
                          Navigator.pop(context);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  useCart.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text("Your cart is empty"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: useCart.length,
                            itemBuilder: (context, index) {
                              final cartItem = useCart[index];
                              return MyCartTile(cartItem: cartItem);
                            },
                          ),
                        ),
                ],
              ),
            ),

            // button to checkout
            MyButton(
              text: "Go to checkout",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
