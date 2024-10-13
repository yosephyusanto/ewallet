import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ewallet/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceWidget extends StatefulWidget {
  const BalanceWidget({super.key});

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  final TextEditingController _balanceAmountController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

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
                //jika amountText adalah huruf maka program akan masuk ke catch(e)
                double amount = double.parse(amountText);
                String amountTemp = amount.toStringAsFixed(2); //memastikan hanya 2 angka dibelakang koma
                amount = double.parse(amountTemp);

                Provider.of<UserProvider>(context, listen: false).topUp(amount);

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
                    labelText: "Username",
                  ),
                  controller: _usernameController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              String amountText = _balanceAmountController.text;
              String recipientUsername = _usernameController.text;

              try {
                double amount = double.parse(amountText);

                String? errorMessage =
                    await Provider.of<UserProvider>(context, listen: false)
                        .pay(amount, recipientUsername);

                if (errorMessage != null) {
                  throw Exception(errorMessage);
                }

                _balanceAmountController.text = '';
                _usernameController.text = '';

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
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      final user = userProvider
          .user!; //! menjamin bahwa user tidak mungkin null, alasan saya berani jamin adalah untuk mengakses homepage maka user pasti sudah login

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
                    TypewriterAnimatedText(user.userName,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                        speed: const Duration(milliseconds: 250)),
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
                        '${user.balance}',
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
    });
  }
}
