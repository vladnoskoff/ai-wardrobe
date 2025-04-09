import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class AddClothesScreen extends StatefulWidget {
  const AddClothesScreen({super.key});

  @override
  _AddClothesScreenState createState() => _AddClothesScreenState();
}

class _AddClothesScreenState extends State<AddClothesScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String category = '';
  String season = '';
  String color = '';
  String? material;
  String? imageUrl;
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_image != null) {
        imageUrl = await ApiService.uploadImage(_image!);
      }

      await ApiService.addClothes({
        'user_id': 1,
        'name': name,
        'category': category,
        'season': season,
        'color': color,
        'material': material,
        'image_url': imageUrl,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить одежду')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Название'),
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Категория'),
                onSaved: (value) => category = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Сезон'),
                onSaved: (value) => season = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Цвет'),
                onSaved: (value) => color = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Материал (необязательно)'),
                onSaved: (value) => material = value,
              ),
              ElevatedButton(onPressed: _pickImage, child: Text('Сделать фото')),
              ElevatedButton(onPressed: submit, child: Text('Добавить')),
            ],
          ),
        ),
      ),
    );
  }
}
