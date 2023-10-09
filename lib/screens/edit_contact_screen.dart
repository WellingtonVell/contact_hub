// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:contact_hub/database/database_helper.dart';
import 'package:contact_hub/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  EditContactScreen({required this.contact});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _emailController = TextEditingController(text: widget.contact.email);
    _phoneController = TextEditingController(text: widget.contact.phone);
    _imagePath = widget.contact.imagePath;
    print('Image Path (initState): $_imagePath');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
        title: Text('Editar Contato'),
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
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 80.0,
                          backgroundImage: _imagePath != null && _imagePath!.isNotEmpty
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
                              Icons.edit,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                        if (_imagePath != null &&
                            _imagePath!.isNotEmpty)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _imagePath = null;
                                });
                              },
                              child: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Telefone'),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Contact updatedContact = Contact(
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                          );
                          updatedContact.id = widget.contact.id;

                          updatedContact.imagePath = _imagePath;
                          await DatabaseHelper().updateContact(updatedContact);

                          Navigator.of(context).pop(updatedContact);
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
