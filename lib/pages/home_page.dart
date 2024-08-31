import 'package:ewallet/models/users_model.dart';
import 'package:ewallet/widgets/balance_widget.dart';
import 'package:ewallet/widgets/profile_settings_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final AppUser data;

  const HomePage({super.key, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
 
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  int _selectedIdx = 0;

  void _onItemTapped(int newIdx) {
    setState(() {
      _selectedIdx = newIdx;
    });
  }

  final Color _selectedColor = const Color(0xFFBDE864);
  final Color _unSelectedColor = Colors.white;
  final Color _backgroundColor = const Color(0xFF0D1C2C);

  List<Widget> items = [
    const Tab(
      text: 'Home',
      icon: Icon(Icons.home),
    ),
    const Tab(
      text: 'Profile',
      icon: Icon(Icons.person),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xFF0D1C2C),
              Color(0xFF172534),
              Color(0xFF202E3C),
            ],
          ),
        ),
        child: showContent(_selectedIdx),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIdx,
        selectedItemColor: _selectedColor,
        unselectedItemColor: _unSelectedColor,
        backgroundColor: _backgroundColor, // Setel warna latar belakang
        onTap: _onItemTapped,
      ),
    );
  }

  Widget showContent(int idx) {
    switch (idx) {
      case 0:
        return BalanceWidget(data: widget.data);
      case 1:
        return ProfileSettingsWidget(data: widget.data);
      default:
        return const Text('Page Not Found');
    }
  }
}
