import 'package:flutter/material.dart';
import 'package:order_pizza/components/my_quantity_selector.dart';
import 'package:order_pizza/models/cart_item.dart';
import 'package:order_pizza/models/restaurant.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;
  const MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // food image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      cartItem.food.image,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // name, price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.food.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "\$${cartItem.food.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      // Increment, decrement Quantity
                    ],
                  ),
                  const Spacer(),

                  MyQuantitySelector(
                    quantity: cartItem.quantity,
                    food: cartItem.food,
                    onDecrement: () {
                      restaurant.removeFromCart(cartItem);
                    },
                    onIncrement: () {
                      restaurant.addToCart(
                          cartItem.food, cartItem.selectedAddons);
                    },
                  )
                ],
              ),
            ),

            // Addons
            SizedBox(
                height: cartItem.selectedAddons.isEmpty ? 0 : 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  children: cartItem.selectedAddons
                      .map((addon) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Row(
                                  children: [
                                    Text(
                                      addon.name,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "\$${addon.price.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                shape: StadiumBorder(
                                    side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                                onSelected: (value) {},
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ))
          ],
        ),
      ),
    );
  }
}
