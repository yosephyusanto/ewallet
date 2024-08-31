import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/models/users_model.dart';
import 'package:ewallet/services/firestore_service.dart';
import 'package:flutter/material.dart';

class BalanceWidget extends StatefulWidget {
  final AppUser data;

  const BalanceWidget({super.key, required this.data});

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  final TextEditingController _balanceAmountController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  void topUpClicked() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Top Up',
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nominal amount',
                  ),
                  controller: _balanceAmountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ), // Adds spacing between fields
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              String amountText = _balanceAmountController.text;

              try {
                double amount = double.parse(amountText);

                //update object
                widget.data.balance += amount;

                //update firestore
                FirestoreService firestoreService = FirestoreService();
                firestoreService.updateUserData(widget.data.uid, widget.data);

                setState(() {
                  //rebuild widget
                });

                _balanceAmountController.text = '';

                Navigator.pop(context);
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                        'Invalid amount. Please enter a valid number.'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBDE864),
              elevation: 0,
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(color: Color(0xFF0D1C2C)),
            ),
          ),
        ],
      ),
    );
  }

  void payClicked() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Transfer',
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nominal amount',
                  ),
                  controller: _balanceAmountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "User's ID",
                  ),
                  controller: _userIdController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              String amountText = _balanceAmountController.text;
              String recepientUID = _userIdController.text.trim();

              try {
                double amount = double.parse(amountText);

                if (amount > widget.data.balance) {
                  throw Exception('unsufficient balance');
                }

                FirestoreService firestoreService = FirestoreService();
                //Get recipient document using UID
                DocumentSnapshot recipientDoc =
                    await firestoreService.getUserData(recepientUID);

                if (!recipientDoc.exists || recipientDoc.data() == null) {
                  throw Exception('Recipient UID not found');
                }

                //save recipient data to object
                AppUser recipient = AppUser.fromMap(
                    recipientDoc.data() as Map<String, dynamic>);

                widget.data.balance -= amount;
                recipient.balance += amount;

                //update firestore for sender and recipient
                firestoreService.updateUserData(widget.data.uid, widget.data);
                firestoreService.updateUserData(recipient.uid, recipient);

                setState(() {
                  //rebuild widget
                });

                _balanceAmountController.text = '';
                _userIdController.text = '';

                Navigator.pop(context);
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pay'),
                    content: Text('Failed to transfer: ${e.toString()}'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBDE864),
              elevation: 0,
            ),
            child: const Text(
              'Pay',
              style: TextStyle(color: Color(0xFF0D1C2C)),
            ),
          ),
        ],
      ),
    );
  }

  late Timer _timer;
  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();

    // Start the timer to toggle animation
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        _isAnimating = !_isAnimating;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40.0),
          Row(
            children: [
              const Text(
                'Hi, ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    widget.data.userName,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                    speed: const Duration(milliseconds: 250)
                  ),
                ],
                repeatForever: true,
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          Center(
            child: Column(
              children: [
                const Text(
                  'Your Balance',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${widget.data.balance}',
                      style: const TextStyle(
                        fontSize: 36.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40.0),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: topUpClicked,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFFBDE864), // Makes button background transparent
                    elevation: 0, // Removes button shadow
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/top-up-icon.png',
                        width: 50, // Adjust the size as needed
                        height: 50, // Adjust the size as needed
                      ),
                      const Text(
                        'Top Up',
                        style: TextStyle(color: Color(0xFF0D1C2C)),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20), // Adds spacing between buttons
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: payClicked,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBDE864),
                    // primary: Colors.transparent, // Makes button background transparent
                    elevation: 0, // Removes button shadow
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/pay-icon.png',
                        width: 50, // Adjust the size as needed
                        height: 50, // Adjust the size as needed
                      ),
                      const Text(
                        'Pay',
                        style: TextStyle(color: Color(0xFF0D1C2C)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
