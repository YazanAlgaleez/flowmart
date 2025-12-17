import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // دالة إنشاء حساب جديد (موجودة عندك)
  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await user?.updateDisplayName(username);
      await user?.reload();
      return null; // نجاح
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- أضف هذه الدالة الجديدة لتسجيل الدخول ---
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // نجاح
    } on FirebaseAuthException catch (e) {
      return e.message; // فشل (إيميل خطأ أو باسورد خطأ)
    } catch (e) {
      return "An unknown error occurred";
    }
  }
}
