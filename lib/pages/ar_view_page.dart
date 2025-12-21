import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ArViewPage extends StatelessWidget {
  final String modelUrl; // رابط الملف بصيغة .glb

  const ArViewPage({super.key, required this.modelUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR View")),
      body: ModelViewer(
        src: modelUrl, // رابط المجسم
        alt: "A 3D model",
        ar: true, // ✅ تفعيل وضع الواقع المعزز
        autoRotate: true,
        cameraControls: true,
      ),
    );
  }
}
