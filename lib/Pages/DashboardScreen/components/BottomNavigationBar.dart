import 'package:flutter/material.dart';
import 'package:job/Pages/DashboardScreen/DashboardScreen.dart';
import 'package:job/Pages/ListScreen/ListScreen.dart';
import 'package:job/constants.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  late List<Widget> _children;
  @override
  void initState() {
    _currentIndex = 0;

    _children = [
      DashboardScreen(),
      ListScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "List",
          ),
        ],
        selectedItemColor: kPrimaryColor,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
