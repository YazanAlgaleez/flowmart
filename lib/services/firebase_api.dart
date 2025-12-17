import 'package:firebase_messaging/firebase_messaging.dart';

// ✅ 1. هذه الدالة يجب أن تكون في الأعلى (خارج الكلاس)
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  // تعريف المتغير
  final _firebaseMessaging = FirebaseMessaging.instance;

  // ✅ 2. دالة التهيئة
  Future<void> initNotifications() async {
    // طلب الإذن
    await _firebaseMessaging.requestPermission();

    // جلب التوكن
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    // ربط دالة الخلفية (التي عرفناها في الأعلى)
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // الاستماع للإشعارات والتطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('============================================');
      print('🔔 وصل إشعار وأنت فاتح التطبيق!');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('============================================');
    });
  }
}
