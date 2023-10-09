// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_import, use_build_context_synchronously, prefer_final_fields

import 'dart:io';

import 'package:contact_hub/database/database_helper.dart';
import 'package:contact_hub/models/contact.dart';
import 'package:contact_hub/screens/add_contact_screen.dart';
import 'package:contact_hub/screens/detail_contact_screen.dart';
import 'package:contact_hub/screens/edit_contact_screen.dart';
import 'package:contact_hub/utils/contact_utils.dart';
import 'package:contact_hub/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ContactListScreen extends StatefulWidget {
  ContactListScreen(List list);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];
  List<Contact> _searchResults = [];
  bool _isSearching = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts().then((contacts) {
      print('Lista de contatos carregada com sucesso');
    });
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    setState(() {
      _searchResults = contacts.where((contact) {
        final searchTerm = _searchController.text.toLowerCase();
        return contact.name.toLowerCase().contains(searchTerm) ||
            contact.phone.contains(searchTerm);
      }).toList();
    });
  }

  Future<void> _loadContacts() async {
    List<Contact> loadedContacts = await DatabaseHelper().getContacts();
    loadedContacts.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      contacts = loadedContacts;
    });
  }

  Future<void> _deleteContact(Contact contact) async {
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Contato'),
          content: Text(
              'Tem certeza de que deseja excluir o contato "${contact.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                    false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true);
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
    _loadContacts();
    if (shouldDelete == true) {
      try {
        await DatabaseHelper().deleteContact(contact.id!);
        _loadContacts();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir o contato'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building ContactListScreen');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('Opening drawer');
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar',
                ),
              )
            : Text('Contatos'),
        actions: [
          IconButton(
            icon: _isSearching ? Icon(Icons.close) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching =
                    !_isSearching;
                _searchController.clear();
              });
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        onMenuPressed: () {},
        onSearchPressed: () {},
        onAboutPressed: () {},
      ),

      body: _isSearching
          ? ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final contact = _searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: contact.imagePath != null
                        ? FileImage(File(contact.imagePath!))
                        : null,
                    child: contact.imagePath == null
                        ? Icon(
                            Icons.person,
                            size: 48.0,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.email),
                  trailing: Text(contact.phone),
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ContactDetailScreen(contact: _searchResults[index]),
                      ),
                    )
                        .then((_) {
                      _loadContacts();
                    });
                  },
                );
              },
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection
                      .endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    _deleteContact(contact);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: contact.imagePath != null
                          ? FileImage(File(contact.imagePath!))
                          : null,
                      child: contact.imagePath == null
                          ? Icon(
                              Icons.person,
                              size: 48.0,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.email),
                    trailing: Text(contact.phone),
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ContactDetailScreen(contact: contacts[index]),
                        ),
                      )
                          .then((_) {
                        _loadContacts();
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddContactScreen(),
            ),
          )
              .then((_) {
            _loadContacts();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
