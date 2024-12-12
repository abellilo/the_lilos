import 'package:flutter/material.dart';
import 'package:thewallsocials/components/my_list_tile.dart';

class MyDrawer extends StatefulWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;

  MyDrawer({super.key, required this.onProfileTap, required this.onSignOut});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 64,
                  )),

              //home
              MyListTile(
                text: "H O M E",
                icon: Icons.home,
                onTap: () => Navigator.pop(context),
              ),

              //profile
              MyListTile(text: "P R O F I L E", icon: Icons.person, onTap: widget.onProfileTap),
            ],
          ),

          //logout
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(text: "L O G O U T", icon: Icons.logout, onTap:widget.onSignOut),
          )
        ],
      ),
    );
  }
}
