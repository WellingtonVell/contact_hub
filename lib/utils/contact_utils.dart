// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';


class ContactUtils {
  static Future<void> showDeleteConfirmationDialog(
    BuildContext context, 
    String contactName, 
    VoidCallback onConfirm,
  ) async {
      try {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Excluir Contato'),
            content: Text('Tem certeza de que deseja excluir o contato "$contactName"?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    onConfirm();
                    Navigator.of(context).pop();
                  } catch (error) {
                    print('Erro ao excluir o contato: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao excluir o contato.'),
                      ),
                    );
                  }
                },
                child: Text('Excluir'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Erro ao exibir o diálogo de exclusão: $error');
    }
  }
}