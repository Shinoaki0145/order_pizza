import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:order_pizza/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'food.dart';

class Restaurant extends ChangeNotifier {
  final List<Food> _menu = [
    // burgers
    Food(
      name: "Classic burger",
      description: "A classic cheeseburger with lettuce, tomato, and pickles.",
      price: 5.99,
      image: "assets/images/burgers/cheeseburger.png",
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.50),
        Addon(name: "Bacon", price: 1.00),
        Addon(name: "Avocado", price: 1.50),
      ],
    ),
    Food(
      name: "Bacon burger",
      description: "A bacon cheeseburger with lettuce, tomato, and pickles.",
      price: 6.99,
      image: "assets/images/burgers/baconburger.png",
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.50),
        Addon(name: "Bacon", price: 1.00),
        Addon(name: "Avocado", price: 1.50),
      ],
    ),
    Food(
      name: "Avocado burger",
      description: "An avocado cheeseburger with lettuce, tomato, and pickles.",
      price: 7.99,
      image: "assets/images/burgers/avocadoburger.png",
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.50),
        Addon(name: "Bacon", price: 1.00),
        Addon(name: "Avocado", price: 1.50),
      ],
    ),

    // pizzas
    Food(
      name: "Pepperoni pizza",
      description: "A classic pepperoni pizza with mozzarella cheese.",
      price: 9.99,
      image: "assets/images/pizzas/pepperonipizza.png",
      category: FoodCategory.pizzas,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.50),
        Addon(name: "Bacon", price: 1.00),
        Addon(name: "Avocado", price: 1.50),
      ],
    ),
    Food(
      name: "Vegetarian pizza",
      description: "A vegetarian pizza with bell peppers, onions, and olives.",
      price: 10.99,
      image: "assets/images/pizzas/vegetarianpizza.png",
      category: FoodCategory.pizzas,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.50),
        Addon(name: "Bacon", price: 1.00),
        Addon(name: "Avocado", price: 1.50),
      ],
    ),
    Food(
      name: "Hawaiian pizza",
      description:
          "A Hawaiian pizza with ham, pineapple, and mozzarella cheese.",
      price: 11.99,
      image: "assets/images/pizzas/hawaiianpizza.png",
      category: FoodCategory.pizzas,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.50),
        Addon(name: "Bacon", price: 1.00),
        Addon(name: "Avocado", price: 1.50),
      ],
    ),

    // salads
    Food(
      name: "Garden salad",
      description:
          "A garden salad with mixed greens, cherry tomatoes, and cucumbers.",
      price: 4.99,
      image: "assets/images/salads/gardensalad.png",
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Grilled Chicken", price: 2.00),
        Addon(name: "Shrimp", price: 3.00),
        Addon(name: "Salmon", price: 4.00),
      ],
    ),
    Food(
      name: "Vietnamese salad",
      description: "A Vietnamese salad with cabbage, carrots, and peanuts.",
      price: 5.99,
      image: "assets/images/salads/vietnamesesalad.png",
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Grilled Chicken", price: 2.00),
        Addon(name: "Shrimp", price: 3.00),
        Addon(name: "Salmon", price: 4.00),
      ],
    ),
    Food(
      name: "Greek salad",
      description: "A Greek salad with feta cheese, olives, and red onions.",
      price: 6.99,
      image: "assets/images/salads/greeksalad.png",
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Grilled Chicken", price: 2.00),
        Addon(name: "Shrimp", price: 3.00),
        Addon(name: "Salmon", price: 4.00),
      ],
    ),

    // drinks
    Food(
      name: "Coca",
      description: "A can of Coca-Cola.",
      price: 1.99,
      image: "assets/images/drinks/coca.png",
      category: FoodCategory.drinks,
      availableAddons: [],
    ),
    Food(
      name: "Sprite",
      description: "A can of Sprite.",
      price: 1.99,
      image: "assets/images/drinks/sprite.png",
      category: FoodCategory.drinks,
      availableAddons: [],
    ),
    Food(
      name: "Iced tea",
      description: "A bottle of iced tea.",
      price: 2.99,
      image: "assets/images/drinks/icedtea.png",
      category: FoodCategory.drinks,
      availableAddons: [],
    ),
  ];

  /*

  G E T T E R S

  */

  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;

  /*

  O P E R A T I O N S

  */

  //user cart
  final List<CartItem> _cart = [];

  // add to cart
  void addToCart(Food food, List<Addon> selectedAddons) {
    // check if food is already in cart
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      // check if food is the same
      bool isFoodTheSame = item.food == food;

      // check if addons are the same
      bool areAddonsTheSame =
          ListEquality().equals(item.selectedAddons, selectedAddons);

      return isFoodTheSame && areAddonsTheSame;
    });
    // if it is, update the quantity
    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      // if it is not, add it to the cart
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }
    notifyListeners();
    // if it is not, add it to the cart
  }

  // remove from cart

  void removeFromCart(CartItem cartItem) {
    int index = _cart.indexOf(cartItem);
    if (index != -1) {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
      } else {
        _cart.removeAt(index);
      }
    }
    notifyListeners();
  }

  // get total price
  double get totalPrice {
    double total = 0.0;
    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  // get total items in cart
  int getTotalItemsInCart() {
    int total = 0;
    for (CartItem cartItem in _cart) {
      total += cartItem.quantity;
    }
    return total;
  }

  // clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /*

  H E L P E R   F U N C T I O N S

  */

  // generate a receipt
  String displayCartReceipt() {
    final receipt = StringBuffer();
    final receiptData = {};

    receipt.writeln("Order summary");
    receipt.writeln("--------------");

    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    receipt.writeln(formattedDate);
    receiptData['Date'] = formattedDate;
    receipt.writeln("");
    receipt.writeln("--------------");

    final items = [];
    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity}x ${cartItem.food.name} - ${_formatMoney(cartItem.food.price)}");
      final item = {
        'quantity' : cartItem.quantity,
        'food-name' : cartItem.food.name,
        'food-price' : cartItem.food.price,
      };
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln("  Add ons: ${_formatAddons(cartItem.selectedAddons)}");
        final addons = [];
        for (final addon in cartItem.selectedAddons) {
          addons.add({
            'name' : addon.name,
            'price' : addon.price,
          });
        }
        item['add-on'] = addons;
      }
      receipt.writeln("");
      items.add(item);
    }
    receiptData['items'] = items;

    receipt.writeln("--------------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemsInCart()}");
    receipt.writeln("Total Price: ${_formatMoney(totalPrice)}");
    receiptData['Total-Items'] = getTotalItemsInCart();
    receiptData['Total-Price'] = totalPrice;

    if (FirebaseAuth.instance.currentUser != null) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection("receipts").doc(userId).update({
        DateTime.now().millisecondsSinceEpoch.toRadixString(16) : receiptData,
      });
    }

    return receipt.toString();
  }

  // format double value into money
  String _formatMoney(double value) {
    return "\$${value.toStringAsFixed(2)}";
  }

  // format list of addons into a string summary
  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatMoney(addon.price)})")
        .join(", ");
  }
}
