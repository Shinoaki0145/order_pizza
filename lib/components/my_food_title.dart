import 'package:flutter/material.dart';
import 'package:order_pizza/models/food.dart';

class FoodTitle extends StatelessWidget {
  final Food food;
  final void Function()? onTap;

  const FoodTitle({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${food.price.toString()}\$',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        food.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      food.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )),
              ],
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.tertiary,
          endIndent: 20,
          indent: 20,
        ),
      ],
    );
  }
}
