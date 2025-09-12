//
class Food {
  final String name;
  final String description;
  final double price;
  final String image;
  final FoodCategory category;
  List<Addon> availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.availableAddons,
  });
}

// food category
enum FoodCategory {
  burgers,
  pizzas,
  salads,
  drinks,
}

// food addons
class Addon {
  String name;
  double price;

  Addon({
    required this.name,
    required this.price,
  });
}
