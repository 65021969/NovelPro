import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกอีเมลและรหัสผ่าน')),
      );
    }
  }

  Widget _buildSocialLoginButton(String text, IconData icon, Color color) {
    return SizedBox(
      width: 180,
      child: ElevatedButton.icon(
        onPressed: () {}, // เพิ่มการเข้าสู่ระบบภายหลัง
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: TextStyle(fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // เพิ่มระยะห่างก่อนเนื้อหาหลัก
                SizedBox(height: 80), // ระยะห่างจากด้านบน

                Image.asset('assets/logo1.png', height: 100), // โลโก้
                SizedBox(height: 10),
                Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 5),
                // ปุ่มลืมรหัสผ่านใต้ช่องรหัสผ่าน
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // ใส่ลอจิกสำหรับลืมรหัสผ่าน
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('กรุณาติดต่อผู้ดูแลระบบเพื่อรีเซ็ตรหัสผ่าน')),
                      );
                    },
                    child: Text('ลืมรหัสผ่าน?', style: TextStyle(fontSize: 14, color: Colors.blue.shade700)),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 220,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                    ),
                    child: Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 25),
                Text('หรือเข้าสู่ระบบด้วย', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                SizedBox(height: 15),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildSocialLoginButton('Google', Icons.g_mobiledata, Colors.red),
                    _buildSocialLoginButton('Facebook', Icons.facebook, Colors.blue),
                    _buildSocialLoginButton('Apple ID', Icons.apple, Colors.black),
                    _buildSocialLoginButton('Line', Icons.message, Colors.green),
                  ],
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text('สมัครสมาชิก', style: TextStyle(fontSize: 16, color: Colors.blue.shade700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
