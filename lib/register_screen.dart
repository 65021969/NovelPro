import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage("กรุณากรอกข้อมูลให้ครบถ้วน");
      return;
    }

    if (password != confirmPassword) {
      _showMessage("รหัสผ่านไม่ตรงกัน");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse("http://26.210.128.157:3000/register");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_name": name,
          "user_pass": password,
          "user_email": email,
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        _showMessage(data["message"] ?? "เกิดข้อผิดพลาดในการสมัครสมาชิก");
      }
    } catch (e) {
      _showMessage("เชื่อมต่อเซิร์ฟเวอร์ไม่ได้");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF5e35b1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: Color(0xFF5e35b1)),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Color(0xFF5e35b1), width: 2),
          ),
          title: Column(
            children: [
              Image.asset(
                'assets/check.png',
                height: 50,
                width: 50,
              ),
              SizedBox(height: 10),
              Text('สมัครสมาชิกสำเร็จ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Color(0xFF5e35b1), Color(0xFF9c27b0)], // สีไล่จากม่วงไปม่วงอ่อน
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // ทำให้พื้นหลังของปุ่มโปร่งใส
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30), // ปรับขนาดปุ่ม
                    elevation: 0, // ไม่มีเงาในปุ่ม
                  ),
                  child: Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // ปรับขนาดตัวอักษร
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5e35b1), Color(0xFF9c27b0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(  // ✅ ใช้ SingleChildScrollView
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/logo1.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'สมัครสมาชิก',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF5e35b1)),
                    ),
                    SizedBox(height: 30),
                    _buildTextField(_nameController, 'Username', Icons.person),
                    SizedBox(height: 20),
                    _buildTextField(_emailController, 'Email', Icons.email),
                    SizedBox(height: 20),
                    _buildTextField(_passwordController, 'Password', Icons.lock, obscure: true),
                    SizedBox(height: 20),
                    _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock, obscure: true),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 220,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5e35b1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 5,
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('สมัครสมาชิก', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(thickness: 1, color: Colors.grey[400]),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 16, color: Color(0xFF9c27b0))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

}
