import 'package:ewallet/models/users_model.dart';
import 'package:ewallet/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  bool _isloading = false;

  //Getter
  bool get isLoading => _isloading;

  //Setter
  void setLoading(bool value) {
    _isloading = value;
    notifyListeners(); //setiap kali nilai _isloading berubah, maka semua instance dari class AuthProvider akan diberi tahu untuk melakukan perubahan value _isloading dimanapun instance /object itu dipanggil
  }

  //Menggunakan nullable karena jika fungsi register behasil akan mengembalikan null sedangkan jika register gagal akan mengembalikan String berupa text kesalahan
  //parameter fungsi register berupa map = {key: value}
  Future<String?> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
    required String phonenumber,
  }) async {
    setLoading(true);

    try {
      bool usernameAlreadyExist =
          await _firestoreService.checkUsernameExist(username);
      if (usernameAlreadyExist) {
        setLoading(false);
        return 'Username already exist, please choose another one';
      }

      //Register user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Get user unique id
      String uid = userCredential.user?.uid ?? '';

      //Save user data in firestore except for username and password
      AppUser newUser = AppUser(
          uid: uid,
          fullName: fullName,
          userName: username,
          phoneNumber: phonenumber);

      await _firestoreService.addUser(newUser);

      //setelah register berhasil hentikan animasi circular loading
      setLoading(false);
      return null; // indikasi registrasion berhasil
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return e.message;
    }
  }
}
