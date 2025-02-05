import 'package:flutter/material.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register() {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon, Color color) {
    return SizedBox(
      width: 180,
      child: ElevatedButton.icon(
        onPressed: () {},
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
      body: SingleChildScrollView( // ลบ Card ออก
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50),
              Image.asset('assets/logo1.png', height: 100), // แสดงโลโก้จาก assets
              SizedBox(height: 10),
              Text('สมัครสมาชิก', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
              SizedBox(height: 20),
              _buildTextField(_nameController, 'Username', Icons.person),
              SizedBox(height: 10),
              _buildTextField(_emailController, 'Email', Icons.email),
              SizedBox(height: 10),
              _buildTextField(_passwordController, 'Password', Icons.lock, obscure: true),
              SizedBox(height: 10),
              _buildTextField(_confirmPasswordController, 'Confirm', Icons.lock, obscure: true),
              SizedBox(height: 20),
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                  ),
                  child: Text('สมัครสมาชิก', style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 25),
              Text('หรือสมัครด้วย', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildSocialButton('Google', Icons.g_translate, Colors.red),
                  _buildSocialButton('Facebook', Icons.facebook, Colors.blue),
                  _buildSocialButton('Apple ID', Icons.apple, Colors.black),
                  _buildSocialButton('Line', Icons.chat, Colors.green),
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 16, color: Colors.blue.shade700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
