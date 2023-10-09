// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:contact_hub/screens/list_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:contact_hub/screens/about_screen.dart';

void main() {
  runApp(ContactApp());
}

class ContactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Contatos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListScreen([]),
      routes: {
        '/about': (context) => AboutScreen(),
      },
    );
  }
}
