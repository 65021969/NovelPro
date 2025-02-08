import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';



class SettingsScreen extends StatefulWidget {
  @override

  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String name = "Pheeraphat Wongchai";
  String username = "pheeraphat_w";
  String email = "peerapat3250@gmail.com";
  String password = "**********"; // แสดงรหัสผ่านเป็น ********** เริ่มต้น

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
                        if (newPasswordController.text ==
                            confirmPasswordController.text) {
                          setState(() {
                            password =
                                newPasswordController.text; // เปลี่ยนรหัสผ่าน
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("รหัสผ่านถูกเปลี่ยนแล้ว")),
                          );
                          Navigator.pop(context); // ปิด dialog
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              "บัญชีของคุณถูกลบเรียบร้อยแล้ว")),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text("ชื่อเล่น",
                          style: TextStyle(color: Colors.grey[700])),
                      subtitle: Text(name,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.deepPurpleAccent),
                        onPressed: editName,
                      ),
                    ),
                    ListTile(
                      title: Text("ชื่อผู้ใช้",
                          style: TextStyle(color: Colors.grey[700])),
                      subtitle: Text(username,
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      title: Text("อีเมล์",
                          style: TextStyle(color: Colors.grey[700])),
                      subtitle: Text(email,
                          style: TextStyle(color: Colors.black)),
                      trailing: IconButton(
                        icon: Icon(Icons.copy, color: Colors.deepPurpleAccent),
                        onPressed: () => copyToClipboard(context, email),
                      ),
                    ),
                    ListTile(
                      title: Text("รหัสผ่าน",
                          style: TextStyle(color: Colors.grey[700])),
                      subtitle: Text(password,
                          style: TextStyle(color: Colors.black)),
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
            // Wrap ส่วนโลโก้และปุ่มใน Center widget เพื่อจัดให้อยู่ตรงกลาง
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // รูปโลโก้ในรูปแบบวงกลม
                  CircleAvatar(
                    radius: 40, // ขนาดของวงกลม (40*2 = 80)
                    backgroundImage: AssetImage('assets/logo1.png'),
                  ),
                  SizedBox(height: 10), // ระยะห่างระหว่างโลโก้กับปุ่ม
                  // ปุ่ม "ออกจากระบบ" ที่มีความกว้างกำหนดเอง
                  SizedBox(
                    width: 250, // กำหนดความกว้างของปุ่มตามที่ต้องการ
                    child: ElevatedButton(
                      onPressed: showLogoutDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("ออกจากระบบ"),
                    ),
                  ),
                  SizedBox(height: 16),
                  // ปุ่ม "ลบบัญชี" ที่มีความกว้างกำหนดเอง
                  SizedBox(
                    width: 250, // กำหนดความกว้างของปุ่ม
                    child: ElevatedButton(
                      onPressed: showDeleteAccountDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 32),
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
    );
  }
}
