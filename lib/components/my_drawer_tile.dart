import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final void Function()? onTap;

  const MyDrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
