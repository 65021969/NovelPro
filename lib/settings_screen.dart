import 'package:flutter/material.dart';
import 'logout_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตั้งค่า', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // สีข้อความเป็นขาว
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF396afc), Color(0xFF2948ff)], // ไล่สีจาก #396afc ไป #2948ff
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text('บัญชีของฉัน'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.green),
            title: Text('การแจ้งเตือน'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('ออกจากระบบ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogoutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
