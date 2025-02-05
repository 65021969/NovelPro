import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MyNovelsScreen extends StatefulWidget {
  @override
  _MyNovelsScreenState createState() => _MyNovelsScreenState();
}

class _MyNovelsScreenState extends State<MyNovelsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  List<Map<String, dynamic>> novels = [];
  String? _nameError;
  String? _authorError;

  // 📌 ฟังก์ชันอัปโหลดรูป
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 📌 ฟังก์ชันตรวจสอบชื่อนิยายซ้ำ
  void _checkNovelName() {
    if (novels.any((novel) => novel['name'] == _nameController.text)) {
      setState(() {
        _nameError = 'ชื่อนิยายนี้มีอยู่แล้ว!';
      });
    } else {
      setState(() {
        _nameError = null;
      });
    }
  }

  // 📌 ฟังก์ชันตรวจสอบนามปากกาซ้ำ
  void _checkAuthorName() {
    if (novels.any((novel) => novel['author'] == _authorController.text)) {
      setState(() {
        _authorError = 'นามปากกานี้มีอยู่แล้ว!';
      });
    } else {
      setState(() {
        _authorError = null;
      });
    }
  }

  // 📌 ฟังก์ชันเพิ่มนิยายใหม่
  void _addNovel() {
    if (_nameController.text.isNotEmpty &&
        _authorController.text.isNotEmpty &&
        _nameError == null &&
        _authorError == null) {
      setState(() {
        novels.add({
          'name': _nameController.text,
          'author': _authorController.text,
          'genre': _genreController.text,
          'image': _image
        });
        _nameController.clear();
        _authorController.clear();
        _genreController.clear();
        _image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('นิยายของฉัน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 📌 ฟอร์มกรอกข้อมูลนิยาย
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'ชื่อนิยาย',
                errorText: _nameError,
                suffixIcon: IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed: _checkNovelName,
                ),
              ),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'นามปากกา',
                errorText: _authorError,
                suffixIcon: IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed: _checkAuthorName,
                ),
              ),
            ),
            TextField(
              controller: _genreController,
              decoration: InputDecoration(labelText: 'แนวนิยาย'),
            ),
            SizedBox(height: 10),

            // 📌 ปุ่มอัปโหลดรูป
            Row(
              children: [
                _image != null
                    ? Image.file(_image!, width: 80, height: 80, fit: BoxFit.cover)
                    : Icon(Icons.image, size: 80, color: Colors.grey),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('อัปโหลดปก'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // 📌 ปุ่มสร้างนิยาย
            ElevatedButton(
              onPressed: _addNovel,
              child: Text('สร้างนิยาย', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            // 📌 แสดง Grid View นิยายที่สร้าง
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 คอลัมน์
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: novels.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        novels[index]['image'] != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.file(novels[index]['image'], height: 120, width: double.infinity, fit: BoxFit.cover),
                        )
                            : Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          child: Center(child: Icon(Icons.image, size: 50, color: Colors.grey[600])),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(novels[index]['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('📖 โดย: ${novels[index]['author']}'),
                              Text('📌 แนว: ${novels[index]['genre']}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
