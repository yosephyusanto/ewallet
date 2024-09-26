import 'package:ewallet/models/users_model.dart';
import 'package:ewallet/services/firestore_service.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final FirestoreService firestoreService = FirestoreService();
  AppUser? _user;

  AppUser? get user => _user;

  void setUser(AppUser data) {
    _user = data;
    notifyListeners();
  }

  //tanda ! menjamin bahwa value dari _user tidak akan null saat method dijalankan
  Future<void> topUp(double amount) async {
    _user!.balance += amount;

    firestoreService.updateUserData(_user!.uid, _user!);

    notifyListeners();
  }

  Future<String?> pay(double amount, String recipientUsername) async {
    AppUser? recepient =
        await firestoreService.getUserDataByUsername(recipientUsername);

    if (recepient == null) {
      return 'Recepient not found, Please make sure to enter the correct Username!';
    }

    if (recepient.userName == _user!.userName) {
      return "Can't transfer to yourself";
    }

    if (amount > _user!.balance) {
      return 'Unsufficient balance!';
    }

    _user!.balance -= amount;
    recepient.balance += amount;

    firestoreService.updateUserData(_user!.uid, _user!);
    firestoreService.updateUserData(recepient.uid, recepient);

    notifyListeners();
    return null;
  }

  Future<void> updateProfile(
      String uid, String fullname, String phonenumber) async {
    _user!.fullName = fullname;
    _user!.phoneNumber = phonenumber;

    firestoreService.updateUserData(uid, _user!);

    notifyListeners();
  }
}
