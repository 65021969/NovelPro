import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyNovelsScreen extends StatefulWidget {
  @override
  _MyNovelsScreenState createState() => _MyNovelsScreenState();
}

class _MyNovelsScreenState extends State<MyNovelsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  File? _image;
  String? _imageBase64;

  List<Map<String, dynamic>> novels = [];
  String? _nameError;
  String? _authorError;
  List<String> _selectedGenres = [];

  // เพิ่ม Map ของแนวนิยายกับหมายเลข
  final Map<String, int> genreMap = {
    'แฟนตาซี': 1,
    'โรแมนติก': 2,
    'สืบสวน': 3,
    'วิทยาศาสตร์': 4,
    'ผจญภัย': 5,
    'สยองขวัญ': 6,
  };


  // เปลี่ยน List เป็นตัวเลขตาม Map
  List<int> getSelectedGenreIds() {
    return _selectedGenres.map((genre) => genreMap[genre] ?? 0).toList();
  }

  final List<String> genres = [
    'แฟนตาซี', 'โรแมนติก', 'สืบสวน', 'วิทยาศาสตร์', 'ผจญภัย', 'สยองขวัญ'
  ];
  @override
  void initState() {
    super.initState();
    fetchNovels();
  }

  Future<void> fetchNovels() async {
    final response = await http.get(Uri.parse('http://192.168.1.40:3000/novel'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print("Fetched Novels: $data"); // ✅ ตรวจสอบโครงสร้างข้อมูลที่ดึงมา
      setState(() {
        novels = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }
  //แสดงข้อมูลนิยายจากserver
  Future<void> addNovelToServer() async {
    final selectedGenreIds = getSelectedGenreIds();
    print("Selected Genres: $selectedGenreIds");

    final response = await http.post(
      Uri.parse('http://192.168.1.40:3000/novel'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'novel_name': _nameController.text,
        'novel_penname': _authorController.text,
        'novel_type_id': selectedGenreIds,
        "novel_img": _imageBase64
      }),
    );

    if (response.statusCode == 201) {
      _nameController.clear();
      _authorController.clear();
      _selectedGenres = [];

      await fetchNovels(); // ดึงข้อมูลใหม่หลังจากเพิ่มนิยาย
      setState(() {}); // รีเฟรช UI
    }
  }






  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = File(pickedFile.path);
        _imageBase64 = base64Encode(bytes);
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
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(12),
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
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(12),
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
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: addNovelToServer,
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
              child: novels.isEmpty
                  ? Center(child: Text('ยังไม่มีนิยาย', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                itemCount: novels.length,
                itemBuilder: (context, index) {
                  final novel = novels[index]; // ดึงข้อมูลนิยายแต่ละรายการ
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: novel['novel_img'] != null
                          ? Image.memory(
                        base64Decode(novel['novel_img']),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.book, size: 50, color: Colors.deepPurpleAccent),
                      title: Text(novel['novel_name'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('โดย: ${novel['novel_penname']}'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
