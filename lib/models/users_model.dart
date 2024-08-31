class AppUser {
  String uid;
  String fullName;
  String userName;
  String phoneNumber;
  double balance;

  AppUser(
      {required this.uid,
      required this.fullName,
      required this.userName,
      required this.phoneNumber,
      this.balance = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'balance': balance,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      userName: map['userName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      balance: map['balance'] ?? 0.0,
    );
  }
}
