// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:io';

import 'package:contact_hub/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:contact_hub/models/contact.dart';
import 'package:contact_hub/screens/edit_contact_screen.dart';
import 'package:contact_hub/utils/contact_utils.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;

  ContactDetailScreen({required this.contact});

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  // ignore: unused_field
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.contact.imagePath != null &&
        widget.contact.imagePath!.isNotEmpty) {
      _imagePath = widget.contact.imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Contato'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToEditContact();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Exibir um diálogo de confirmação antes de excluir o contato
              ContactUtils.showDeleteConfirmationDialog(
                context,
                widget.contact.name,
                () {
                  _deleteContact();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            CircleAvatar(
              radius: 80.0,
              backgroundImage: widget.contact.imagePath != null
                  ? FileImage(File(widget.contact.imagePath!))
                  : null,
              child: widget.contact.imagePath == null
                  ? Icon(
                      Icons.person,
                      size: 80.0,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(height: 10),
            _buildContactInfo('Nome', widget.contact.name),
            _buildContactInfo('Telefone', widget.contact.phone),
            _buildContactInfo('E-mail', widget.contact.email),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }

  Future<void> _navigateToEditContact() async {
    final updatedContact = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditContactScreen(contact: widget.contact),
      ),
    );

    if (updatedContact != null) {
      setState(() {
        // Atualize o contato na tela de detalhes
        widget.contact.name = updatedContact.name;
        widget.contact.email = updatedContact.email;
        widget.contact.phone = updatedContact.phone;
        widget.contact.imagePath = updatedContact.imagePath;
      });
    }
  }

  Future<void> _deleteContact() async {
    try {
      final deletedContactId =
          await DatabaseHelper().deleteContact(widget.contact.id!);
      if (deletedContactId > 0) {
        print('Contato excluído com sucesso');
        Navigator.of(context).pop();
      } else {
        print('Falha ao excluir o contato');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir o contato.'),
          ),
        );
      }
    } catch (error) {
      print('Erro ao excluir o contato: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir o contato.'),
        ),
      );
    }
  }
}
