import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _upload() async {
    if (_imageFile == null || _nameController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      String name = DateTime.now().millisecondsSinceEpoch.toString();
      TaskSnapshot snap = await FirebaseStorage.instance
          .ref()
          .child('products/$name.jpg')
          .putFile(_imageFile!);
      String url = await snap.ref.getDownloadURL();

      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instanceFor(
              app: Firebase.app(), databaseId: 'flowmart')
          .collection('products')
          .add({
        'name': _nameController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'imageUrl': url,
        'sellerId': user?.uid,
        'sellerName': user?.displayName ?? user?.email?.split('@')[0],
        'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("رفع منتج")),
      body: Column(
        children: [
          if (_imageFile != null) Image.file(_imageFile!, height: 200),
          ElevatedButton(
              onPressed: () async {
                final img =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (img != null) setState(() => _imageFile = File(img.path));
              },
              child: const Text("اختر صورة")),
          TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "اسم المنتج")),
          TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "السعر")),
          ElevatedButton(
              onPressed: _isLoading ? null : _upload,
              child: const Text("رفع المنتج")),
        ],
      ),
    );
  }
}
