import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SettingsScreen extends StatefulWidget {
  @override

  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  String name = "";
  String username = "";
  String email = "";
  String password = "********"; // แสดงรหัสผ่านเป็น ********** เริ่มต้น

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final url = Uri.parse("http://26.210.128.157:3000/user");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data["user_name"] ?? "";
          username = data["user_name"] ?? "";
          email = data["user_email"] ?? "";
        });
        print("Name: $name, Username: $username, Email: $email");
      } else {
        print("Error fetching user info: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Failed to fetch user info: $e");
    }
  }

  Future<void> updateUserName(String newName) async {
    final url = Uri.parse("http://26.210.128.157:3000/updateName");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "name": newName}),
      );

      if (response.statusCode == 200) {
        setState(() {
          name = newName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("อัปเดตชื่อเรียบร้อยแล้ว")),
        );
      } else {
        print("Failed to update name: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("คัดลอกแล้ว: $text")),
    );
  }

  void editName() {
    TextEditingController controller = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 60, color: Colors.deepPurpleAccent),
                  SizedBox(height: 20),
                  Text(
                    "แก้ไขชื่อเล่น",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 32),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("ยกเลิก"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 32),
                        ),
                        onPressed: () {
                          setState(() {
                            name = controller.text;
                          });
                          Navigator.pop(context);
                        },
                        child: Text("บันทึก"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> changePassword(String newPassword) async {
    final url = Uri.parse("http://26.210.128.157:3000/change-password"); // เปลี่ยนเป็น URL ของ API ของคุณ
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_pass": newPassword,  // ส่งข้อมูลรหัสผ่านใหม่
      }),
    );

    if (response.statusCode == 200) {
      print("Success: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("รหัสผ่านถูกเปลี่ยนแล้ว")),
      );
    } else {
      print("Failed: ${response.statusCode} - ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน")),
      );
    }
  }


  void showChangePasswordDialog() {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 60, color: Colors.deepPurpleAccent),
                SizedBox(height: 20),
                Text(
                  "เปลี่ยนรหัสผ่าน",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(hintText: "รหัสผ่านใหม่"),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(hintText: "ยืนยันรหัสผ่าน"),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // ปิด dialog
                      },
                      child: Text("ยกเลิก"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (newPasswordController.text == confirmPasswordController.text) {
                          changePassword(newPasswordController.text); // เรียกใช้ฟังก์ชันเพื่อเปลี่ยนรหัสผ่าน
                          Navigator.pop(context); // ปิด Dialog
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("รหัสผ่านไม่ตรงกัน")),
                          );
                        }
                      },
                      child: Text("บันทึก"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.exit_to_app, size: 60,
                    color: Colors.deepPurpleAccent),
                SizedBox(height: 20),
                Text(
                  "ยืนยันการออกจากระบบ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "คุณต้องการออกจากระบบหรือไม่?",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // ปิด dialog
                      },
                      child: Text("ยกเลิก"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // ปิด dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              LoginScreen()), // เปลี่ยนไปที่หน้า Login
                        );
                      },
                      child: Text("ออกจากระบบ"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    final url = Uri.parse("http://26.210.128.157:3000/delete-account"); // URL สำหรับลบบัญชี
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "de": 1,  // ส่ง user_id ไปยัง server
      }),
    );

    if (response.statusCode == 200) {
      // ถ้าลบบัญชีสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("บัญชีของคุณถูกลบเรียบร้อยแล้ว")),
      );
    } else {
      // ถ้าการลบไม่สำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาดในการลบบัญชี")),
      );
    }
  }



  void showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_forever, size: 60, color: Colors.redAccent),
                SizedBox(height: 20),
                Text(
                  "ยืนยันการลบบัญชี",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "คุณต้องการลบบัญชีของคุณหรือไม่? การกระทำนี้ไม่สามารถย้อนกลับได้",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // ปิด dialog
                      },
                      child: Text("ยกเลิก"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // ปิด dialog
                        deleteAccount();  // เรียกใช้ฟังก์ชันลบบัญชี
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),  // ไปที่หน้า Login
                          );
                      },
                      child: Text("ลบบัญชี"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'บัญชีของฉัน',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.deepPurpleAccent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5e35b1), Color(0xFF9c27b0)],
          ),
        ),
      ),
    ),
    backgroundColor: Colors.grey[100],
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(  // ✅ ใช้ SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  elevation: 6, // เพิ่มเงาให้ดูเด่นขึ้น
  color: Colors.white,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            "Username",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16, // เพิ่มขนาดตัวอักษร
              fontWeight: FontWeight.w600, // ใช้ตัวหนา
            ),
          ),
          subtitle: Text(
            "$username",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18, // ขนาดตัวอักษรใหญ่ขึ้น
              fontWeight: FontWeight.bold, // ตัวหนา
            ),
          ),
        ),
        Divider(color: Colors.grey[300]), // เพิ่มเส้นแบ่งให้ดูสะอาดตา
        ListTile(
          title: Text(
            "Email",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "$email",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.copy, color: Colors.deepPurpleAccent),
            onPressed: () => copyToClipboard(context, email),
          ),
        ),
        Divider(color: Colors.grey[300]),
        ListTile(
          title: Text(
            "Password",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            password,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: Colors.deepPurpleAccent),
            onPressed: showChangePasswordDialog, // เปิด dialog เปลี่ยนรหัสผ่าน
          ),
        ),
      ],
    ),
  ),
),

            SizedBox(height: 20),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40, 
                    backgroundImage: AssetImage('assets/logo1.png'),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: showLogoutDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("ออกจากระบบ"),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: showDeleteAccountDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("ลบบัญชี"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
