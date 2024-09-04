import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/models/users_model.dart';

class FirestoreService {
  final CollectionReference datas =
      FirebaseFirestore.instance.collection('users');

  //Using user uid as Document ID
  Future<void> addUser(AppUser user) {
    return datas.doc(user.uid).set(user.toMap());
  }

  //Get specific user data by using its unique uid that every users has
  Future<DocumentSnapshot> getUserData(String uid) {
    return datas.doc(uid).get();
  }

  Future<void> updateUserData(String uid, AppUser data) {
    return datas.doc(uid).update(data.toMap());
  }

  Future<bool> checkUsernameExist(String username) async {
    final QuerySnapshot result = await datas.where('userName', isEqualTo: username).limit(1).get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty;
  }


  //Dont forget to use nullable becase the data may not be found
  Future<AppUser?> getUserDataByUsername(String username) async {
    final QuerySnapshot result = await datas.where('userName', isEqualTo: username).limit(1).get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isNotEmpty) {
      return AppUser.fromMap(documents.first.data() as Map<String, dynamic>);
    }
    return null;
  }
}
