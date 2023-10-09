// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:io';

import 'package:contact_hub/database/database_helper.dart';
import 'package:contact_hub/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';
  String? _imagePath;

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Contato'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(16.0),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 80.0,
                            backgroundImage: _imagePath != null
                                ? FileImage(File(_imagePath!))
                                : null,
                            child: _imagePath == null
                                ? Icon(
                                    Icons.person,
                                    size: 80.0,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Wrap(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera),
                                      title: Text('Tirar Foto'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _takePicture();
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.image),
                                      title: Text('Escolher da Galeria'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _pickImage();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              width: 32.0,
                              height: 32.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome.';
                        }
                        return null;
                      },
                      onSaved: (value) => _name = value!,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Telefone'),
                      onSaved: (value) => _phone = value!,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      onSaved: (value) => _email = value!,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Contact newContact = Contact(
                            name: _name,
                            email: _email,
                            phone: _phone,
                            imagePath: _imagePath,
                          );
                          await DatabaseHelper().saveContact(newContact);
                          print(
                              'Contato salvo com sucesso: ${newContact.name} - ${newContact.email} - ${newContact.phone}');
                          Navigator.of(context)
                              .pop(); // Voltar para a tela de lista de contatos
                        }
                      },
                      child: Text('Salvar Contato'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
