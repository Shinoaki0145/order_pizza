import 'package:flutter/material.dart';
import 'package:order_pizza/models/food.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  const MyTabBar({
    super.key,
    required this.tabController,
  });

  List<Tab> _buildCategoryTabs() {
    return FoodCategory.values.map((category) {
      return Tab(
        text: category.name,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: tabController,
        tabs: _buildCategoryTabs(),
    );
  }
}
