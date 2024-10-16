import 'package:ewallet/models/users_model.dart';
import 'package:ewallet/pages/login_page.dart';
import 'package:ewallet/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileSettingsWidget extends StatefulWidget {
  const ProfileSettingsWidget({super.key});

  @override
  State<ProfileSettingsWidget> createState() => _ProfileSettingsWidgetState();
}

class _ProfileSettingsWidgetState extends State<ProfileSettingsWidget> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      //listen false karena tidak menggunakan method yang didalamnya ada notify listener, atau dengan kata lain hanya pelru atribut saja 
      AppUser? user = Provider.of<UserProvider>(context, listen: false).user!; //memanggil getter untuk mendapat value dari atribute _user di class userProvider
     
      // Update controllers with fetched data
      _fullNameController.text = user.fullName;
      _phoneNumberController.text = user.phoneNumber;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  void onEditButtonClicked(AppUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: double.maxFinite, // Ensures dialog width is not too narrow
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Profile Setting',
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Fullname',
                  ),
                  controller: _fullNameController,
                ),
                const SizedBox(height: 16), // Adds spacing between fields
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                  ),
                  controller: _phoneNumberController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              try {
                if (_fullNameController.text.length < 5) {
                  throw Exception('full name must be at least 5 characters');
                }

                if (_phoneNumberController.text.length < 10 ||
                    _phoneNumberController.text.length > 15) {
                  throw Exception('phone number must be 10-15 digits');
                }

                if (!RegExp(r'^\d{10,15}$').hasMatch(_phoneNumberController.text)) {
                  throw Exception('phone number must be number');
                }

                Provider.of<UserProvider>(context, listen: false).updateProfile(
                    user.uid,
                    _fullNameController.text,
                    _phoneNumberController.text);

                Navigator.of(context).pop();
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pay'),
                    content: Text('Failed to edit profile: ${e.toString()}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      AppUser? user = userProvider.user!;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.rightFromBracket,
                      color: Colors.white,
                    )),
              ],
            ),
            const SizedBox(height: 60.0),
            const Text(
              'Fullname',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              user.fullName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              user.phoneNumber,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () => onEditButtonClicked(user),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBDE864),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Color(0xFF0D1C2C),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
