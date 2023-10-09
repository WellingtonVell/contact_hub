// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Este aplicativo é uma demonstração criada para o Bootcamp da DIO (Digital Innovation One). É destinado ao aprendizado de Flutter e gerenciamento de contatos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
