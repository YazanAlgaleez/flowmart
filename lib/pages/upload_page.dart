import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/providers/locale_provider.dart'; // ✅ استيراد ملف اللغة

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  File? _imageFile;
  File? _arModelFile;
  bool _isLoading = false;
  bool _isArMode = false;

  Future<void> _pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _imageFile = File(img.path));
  }

  Future<void> _pickArModel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['glb', 'gltf'],
    );
    if (result != null)
      setState(() => _arModelFile = File(result.files.single.path!));
  }

  // ✅ تمرير loc للترجمة
  Future<void> _upload(AppLocalizations loc) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_imageFile == null ||
        _nameController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(loc.translate('fill_data_error')))); // "يرجى تعبئة البيانات"
      return;
    }

    setState(() => _isLoading = true);
    try {
      final String productId = DateTime.now().millisecondsSinceEpoch.toString();

      TaskSnapshot imageSnap = await FirebaseStorage.instance
          .ref()
          .child('products/$productId.jpg')
          .putFile(_imageFile!);
      String imageUrl = await imageSnap.ref.getDownloadURL();

      String? arModelUrl;
      if (_arModelFile != null) {
        String extension = _arModelFile!.path.split('.').last;
        TaskSnapshot arSnap = await FirebaseStorage.instance
            .ref()
            .child('products_ar/$productId.$extension')
            .putFile(_arModelFile!);
        arModelUrl = await arSnap.ref.getDownloadURL();
      }

      await FirebaseFirestore.instanceFor(
              app: Firebase.app(), databaseId: 'flowmart')
          .collection('products')
          .add({
        'name': _nameController.text,
        'description': _descController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'imageUrl': imageUrl,
        'arModelUrl': arModelUrl,
        'sellerId': user.uid,
        'sellerName': user.displayName ??
            user.email?.split('@')[0] ??
            loc.translate('user'),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context); // إغلاق الصفحة أولاً
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(loc.translate('upload_success')),
            backgroundColor: Colors.green)); // "تم الرفع بنجاح"
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${loc.translate('error')}: $e")));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // ✅ استدعاء الترجمة
    final localeProvider = Provider.of<LocaleProvider>(context);
    final loc = AppLocalizations(localeProvider.locale);

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    final Color mainColor = isDark
        ? Colors.white
        : isGirlie
            ? const Color(0xFF8B008B)
            : AppColors.primaryColor;
    final Color backgroundColor = isDark
        ? const Color(0xFF0D0D0D)
        : isGirlie
            ? const Color(0xFFFFF0F5)
            : Colors.white;
    final Color accentColor = isDark
        ? Colors.redAccent
        : isGirlie
            ? const Color(0xFFFF4081)
            : AppColors.primaryColor;
    final Color subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color containerColor = isDark
        ? const Color(0xFF1E1E1E)
        : isGirlie
            ? Colors.white
            : Colors.grey[100]!;

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(loc.translate('upload_title'), // "إضافة منتج"
            style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: mainColor),
        centerTitle: true,
      ),
      body: user == null
          ? _buildLoginRequestView(
              mainColor, subTextColor, accentColor, loc) // ✅ تمرير loc
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // --- زر التبديل (Switch) ---
                  Center(
                    child: Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey[800]
                            : (isGirlie
                                ? const Color(0xFFFFC1E3)
                                : Colors.grey[300]),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: _isArMode
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2))
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isArMode = true),
                                  child: Container(
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Text(
                                        loc.translate(
                                            'ar_file_tab'), // "ملف AR"
                                        style: TextStyle(
                                            color: _isArMode
                                                ? Colors.white
                                                : (isGirlie
                                                    ? const Color(0xFF8B008B)
                                                        .withOpacity(0.7)
                                                    : Colors.grey[700]),
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _isArMode = false),
                                  child: Container(
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Text(
                                        loc.translate(
                                            'image_tab'), // "صورة المنتج"
                                        style: TextStyle(
                                            color: !_isArMode
                                                ? Colors.white
                                                : (isGirlie
                                                    ? const Color(0xFF8B008B)
                                                        .withOpacity(0.7)
                                                    : Colors.grey[700]),
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _isArMode
                        ? _buildArUploader(containerColor, mainColor,
                            accentColor, isGirlie, loc)
                        : _buildImageUploader(containerColor, mainColor,
                            accentColor, isGirlie, loc),
                  ),
                  const SizedBox(height: 25),

                  _buildTextField(
                      controller: _nameController,
                      label: loc.translate('product_name'), // "اسم المنتج"
                      icon: Icons.shopping_bag_outlined,
                      mainColor: mainColor,
                      subTextColor: subTextColor,
                      borderColor: isDark
                          ? Colors.grey[700]!
                          : (isGirlie ? const Color(0xFFF8BBD0) : Colors.grey),
                      accentColor: accentColor),
                  const SizedBox(height: 15),
                  _buildTextField(
                      controller: _priceController,
                      label: loc.translate('price_label'), // "السعر"
                      icon: Icons.attach_money,
                      isNumber: true,
                      mainColor: mainColor,
                      subTextColor: subTextColor,
                      borderColor: isDark
                          ? Colors.grey[700]!
                          : (isGirlie ? const Color(0xFFF8BBD0) : Colors.grey),
                      accentColor: accentColor),
                  const SizedBox(height: 15),
                  _buildTextField(
                      controller: _descController,
                      label: loc.translate('desc_label'), // "الوصف"
                      icon: Icons.description_outlined,
                      maxLines: 3,
                      mainColor: mainColor,
                      subTextColor: subTextColor,
                      borderColor: isDark
                          ? Colors.grey[700]!
                          : (isGirlie ? const Color(0xFFF8BBD0) : Colors.grey),
                      accentColor: accentColor),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _upload(loc), // ✅
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        shadowColor: accentColor.withOpacity(0.4),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(loc.translate('publish_btn'), // "نشر المنتج"
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ✅ واجهة تظهر فقط لغير المسجلين
  Widget _buildLoginRequestView(Color mainColor, Color subTextColor,
      Color accentColor, AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded,
                size: 80, color: subTextColor.withOpacity(0.5)),
            const SizedBox(height: 20),
            Text(
              loc.translate('login_required'), // "تسجيل الدخول مطلوب"
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: mainColor),
            ),
            const SizedBox(height: 10),
            Text(
              loc.translate('login_msg'), // "يرجى تسجيل الدخول..."
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: subTextColor),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.push(AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                    loc.translate('login_btn'), // "تسجيل الدخول / إنشاء حساب"
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      required Color mainColor,
      required Color subTextColor,
      required Color borderColor,
      required Color accentColor,
      bool isNumber = false,
      int maxLines = 1}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: mainColor, fontWeight: FontWeight.w500),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: subTextColor),
        alignLabelWithHint: true,
        prefixIcon: Icon(icon, color: subTextColor),
        filled: true,
        fillColor: borderColor.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: accentColor, width: 2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildImageUploader(Color bgColor, Color iconColor, Color accentColor,
      bool isGirlie, AppLocalizations loc) {
    return GestureDetector(
      key: const ValueKey('ImageUploader'),
      onTap: _pickImage,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
          boxShadow: isGirlie
              ? [
                  BoxShadow(
                      color: accentColor.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2)
                ]
              : [],
          image: _imageFile != null
              ? DecorationImage(
                  image: FileImage(_imageFile!), fit: BoxFit.cover)
              : null,
        ),
        child: _imageFile == null
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_photo_alternate_rounded,
                    size: 70, color: accentColor),
                const SizedBox(height: 10),
                Text(
                    loc.translate(
                        'upload_cover_hint'), // "اضغط لإضافة صورة الغلاف"
                    style: TextStyle(
                        color: iconColor.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500))
              ])
            : null,
      ),
    );
  }

  Widget _buildArUploader(Color bgColor, Color iconColor, Color accentColor,
      bool isGirlie, AppLocalizations loc) {
    return GestureDetector(
      key: const ValueKey('ArUploader'),
      onTap: _pickArModel,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isGirlie ? Colors.white : bgColor,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 1.5),
          boxShadow: isGirlie
              ? [
                  BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.1), blurRadius: 10)
                ]
              : [],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
              _arModelFile != null
                  ? Icons.check_circle_rounded
                  : Icons.view_in_ar_rounded,
              size: 70,
              color: _arModelFile != null ? Colors.green : Colors.blueAccent),
          const SizedBox(height: 10),
          Text(
              _arModelFile != null
                  ? loc.translate('file_selected') // "تم اختيار الملف"
                  : loc.translate('upload_3d_hint'), // "اضغط لرفع ملف 3D"
              style: TextStyle(
                  color: _arModelFile != null
                      ? Colors.green
                      : (isGirlie ? iconColor : Colors.blueGrey),
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          if (_arModelFile != null)
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(_arModelFile!.path.split('/').last,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.green)))),
        ]),
      ),
    );
  }
}
