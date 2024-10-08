import 'package:ewallet/models/users_model.dart';
import 'package:ewallet/pages/login_page.dart';
import 'package:ewallet/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupFormWidget extends StatefulWidget {
  const SignupFormWidget({super.key});

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final FirestoreService firestoreService = FirestoreService();
        bool usernameAlreadyExist = await firestoreService.checkUsernameExist(_usernameController.text);

        if (usernameAlreadyExist) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Username already exists, please choose another one'),
            ),
          );
          return;
        }

        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String uid = userCredential.user?.uid ?? '';

        AppUser user = AppUser(
          uid: uid,
          fullName: _fullNameController.text,
          userName: _usernameController.text,
          phoneNumber: _phoneNumberController.text,
        );

        firestoreService.addUser(user);

        // Handle successful registration here (e.g., navigate to another page)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );

        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle registration error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed: ${e.message}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              controller: _fullNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your fullname';
                }
                if (value.length < 5) {
                  return 'Your full name must be at least 5 characters long';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: 'Fullname',
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  size: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              controller: _usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username.';
                }
                if (value.length < 3) {
                  return 'Username must be at least 3 characters long.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  size: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              controller: _phoneNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number.';
                }
                // Basic phone number validation
                if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                  return 'Please enter a valid phone number (10-15 digits).';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
                prefixIcon: const Icon(
                  Icons.phone,
                  size: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!value.contains('@')) {
                  return 'Plese enter a valid email address';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
                prefixIcon: const Icon(
                  Icons.email,
                  size: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Your Password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  size: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              controller: _confirmPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter confirmation password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                if (value != _passwordController.text) {
                  return 'Confirmation password is wrong';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  size: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          _isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFBDE864)),
                )
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBDE864),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF0D1C2C),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
