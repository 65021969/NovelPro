import 'package:flutter/material.dart';
import 'bookshelf_screen.dart';
import 'home_screen.dart';
import 'my_novels_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    BookshelfScreen(),
    HomeScreen(),
    MyNovelsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF396afc), Color(0xFF2948ff)], // ไล่สีม่วงเหมือนกับ AppBar
          ),
          border: Border(
            top: BorderSide(
              color: Colors.deepPurpleAccent, // สีเส้นขอบด้านบน
              width: 1.0, // ความหนาของเส้นขอบ
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'ชั้นหนังสือ'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าหลัก'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'นิยายของฉัน'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'ตั้งค่า'),
          ],
        ),
      ),
    );
  }
}
