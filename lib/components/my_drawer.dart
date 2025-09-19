import 'package:flutter/material.dart';
import 'package:order_pizza/components/my_current_location.dart';
import 'package:order_pizza/components/my_drawer_tile.dart';
import 'package:order_pizza/models/restaurant.dart';
import '../pages/settings_page.dart';
import '../auth/login_or_register.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // app logo
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Icon(
              Icons.lock_open_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // home list tile
          MyDrawerTile(
            icon: Icons.home,
            title: "H O M E",
            onTap: () => Navigator.pop(context),
          ),

          // settings list tile
          MyDrawerTile(
            icon: Icons.settings,
            title: "S E T T I N G S",
            onTap: () {
              Navigator.pop(context); // đóng drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),

          const Spacer(),

          // logout list tile
          MyDrawerTile(
            icon: Icons.logout,
            title: "L O G O U T",
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginOrRegister(),
                ),
                    (route) => false,
              );
              context.read<Restaurant>().clearCart();
              context.read<LocationNotifier>().clearDelivery();
            },
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
