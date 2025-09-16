import 'package:flutter/material.dart';
import 'package:order_pizza/models/restaurant.dart';
import 'package:order_pizza/components/my_current_location.dart';
import 'package:provider/provider.dart';

class MyReceit extends StatelessWidget {
  const MyReceit({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 50, bottom: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Thank you for your order"),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(25),
                child: Consumer<Restaurant>(
                  builder: (context, restaurant, child) =>
                      Text(restaurant.displayCartReceipt()),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<LocationNotifier>(
                builder: (context, locationNoti, child) =>
                  Text("Estimated delivery time: ${locationNoti.deliveryTime} minutes"),
              ),
            ],
          ),
        ));
  }
}
