// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function() onMenuPressed;
  final Function() onSearchPressed;
  final Function() onAboutPressed;

  CustomDrawer({
    required this.onMenuPressed,
    required this.onSearchPressed,
    required this.onAboutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: ListTile(
              title: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre'),
            onTap: () {
              Navigator.pushNamed(context,
                  '/about');
            },
          ),
        ],
      ),
    );
  }
}
