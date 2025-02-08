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
          color: Color(0xFF3A3A98), // สีกรมอ่อนลง
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // เงาจางๆ
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.black54,
          backgroundColor: Colors.grey[200], // สีแถบ nav bar
          elevation: 0, // ปิดเงาจาก BottomNavigationBar เพราะใช้ Container แล้ว
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