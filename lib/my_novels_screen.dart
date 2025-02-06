import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MyNovelsScreen extends StatefulWidget {
  @override
  _MyNovelsScreenState createState() => _MyNovelsScreenState();
}

class _MyNovelsScreenState extends State<MyNovelsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  List<Map<String, dynamic>> novels = [];
  String? _nameError;
  String? _authorError;
  List<String> _selectedGenres = [];

  final List<String> genres = [
    'แฟนตาซี', 'โรแมนติก', 'สืบสวน', 'วิทยาศาสตร์', 'ผจญภัย', 'สยองขวัญ'
  ];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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

  void _addNovel() {
    if (_nameController.text.isNotEmpty &&
        _authorController.text.isNotEmpty &&
        _selectedGenres.isNotEmpty &&
        _nameError == null &&
        _authorError == null) {
      setState(() {
        novels.add({
          'name': _nameController.text,
          'author': _authorController.text,
          'genre': _selectedGenres,
          'image': _image,
        });
        _nameController.clear();
        _authorController.clear();
        _selectedGenres = [];
        _image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'นิยายของฉัน',
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อนิยาย',
                        labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                        errorText: _nameError,
                        errorStyle: TextStyle(color: Colors.redAccent),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.check_circle, color: Colors.green),
                          onPressed: _checkNovelName,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _authorController,
                      decoration: InputDecoration(
                        labelText: 'นามปากกา',
                        labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                        errorText: _authorError,
                        errorStyle: TextStyle(color: Colors.redAccent),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.check_circle, color: Colors.green),
                          onPressed: _checkAuthorName,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    MultiSelectDialogField(
                      items: genres.map((genre) => MultiSelectItem(genre, genre)).toList(),
                      title: Text('เลือกแนวนิยาย', style: TextStyle(color: Colors.deepPurpleAccent)),
                      selectedColor: Colors.deepPurpleAccent,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onConfirm: (values) {
                        setState(() {
                          _selectedGenres = values.cast<String>();
                        });
                      },
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        _image != null
                            ? Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover)
                            : Icon(Icons.image, size: 100, color: Colors.grey),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('อัปโหลดปก'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1),
                    ElevatedButton(
                      onPressed: _addNovel,
                      child: Text('สร้างนิยาย', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'นิยายที่คุณสร้าง',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: novels.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Column(
                      children: [
                        novels[index]['image'] != null
                            ? Image.file(novels[index]['image'], height: 120, width: double.infinity, fit: BoxFit.cover)
                            : Container(height: 120, color: Colors.grey[300], child: Icon(Icons.image, size: 50)),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                novels[index]['name'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text('📖 โดย: ${novels[index]['author']}'),
                              Text('📌 แนว: ${novels[index]['genre'].join(', ')}'),
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
