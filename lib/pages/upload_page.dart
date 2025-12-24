import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final FirebaseService _service = FirebaseService();

  // المتحكمات في النصوص
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // قائمة التصنيفات (عشان نضمن دقة البيانات)
  String _selectedCategory = 'tech';
  final List<String> _categories = ['tech', 'fashion', 'books', 'gaming'];

  void _submitProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

    await _service.uploadProduct({
      'name': _nameController.text,
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'category': _selectedCategory,
      'imageUrl': _imageController.text.isNotEmpty
          ? _imageController.text
          : 'https://via.placeholder.com/300', // صورة افتراضية
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("تم رفع المنتج بنجاح! ✅")));

    // تفريغ الحقول
    _nameController.clear();
    _priceController.clear();
    _imageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Product (Admin)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Product Name")),
              TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: "Image URL")),
              SizedBox(height: 20),

              // قائمة منسدلة لاختيار التصنيف
              DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) =>
                    setState(() => _selectedCategory = newValue!),
              ),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitProduct,
                child: Text("Upload to FlowMart 🚀"),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
