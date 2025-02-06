import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  String? _selectedGenre;

  final Map<String, int> genreMap = {
    'แฟนตาซี': 1,
    'โรแมนติก': 2,
    'สืบสวน': 3,
    'วิทยาศาสตร์': 4,
    'ผจญภัย': 5,
    'สยองขวัญ': 6,
  };

  final List<String> genres = [
    'แฟนตาซี', 'โรแมนติก', 'สืบสวน', 'วิทยาศาสตร์', 'ผจญภัย', 'สยองขวัญ'
  ];

  @override
  void initState() {
    super.initState();
    fetchNovels();
  }

  Future<void> fetchNovels() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.40:3000/novel'));
    if (response.statusCode == 200) {
      setState(() {
        novels = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }

  Future<void> addNovelToServer() async {
    final selectedGenreId = genreMap[_selectedGenre ?? ''] ?? 0;
    final response = await http.post(
      Uri.parse('http://192.168.1.40:3000/novel'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'novel_name': _nameController.text,
        'novel_penname': _authorController.text,
        'novel_type_id': selectedGenreId,
        "novel_img": _imageBase64
      }),
    );
    if (response.statusCode == 201) {
      fetchNovels();
      _nameController.clear();
      _authorController.clear();
      _selectedGenre = null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
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
        title: Text('นิยายของฉัน',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
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
                          borderSide: BorderSide(color: Colors
                              .deepPurpleAccent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(
                            Icons.book, color: Colors.deepPurpleAccent),
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
                          borderSide: BorderSide(color: Colors
                              .deepPurpleAccent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(
                            Icons.person, color: Colors.deepPurpleAccent),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedGenre,
                      decoration: InputDecoration(
                        labelText: 'เลือกแนวนิยาย',
                        labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(
                            Icons.category, color: Colors.deepPurpleAccent),
                      ),
                      items: genres.map((genre) {
                        return DropdownMenuItem<String>(
                          value: genre,
                          child: Text(genre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGenre = value;
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                          ),
                          child: _image != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Image.file(
                                _image!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover, // Full frame image
                              ),
                            ),
                          )
                              : Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.upload_file, size: 20),
                          label: Text(
                            'อัปโหลดปก',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Color(0xFF9c4dcc), // Light purple
                            foregroundColor: Colors.white,
                            elevation: 5,
                            side: BorderSide(color: Color(0xff9000ea), width: 2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0),
                    Align(
                      alignment: Alignment(0.28, 0),
                      child: ElevatedButton(
                        onPressed: addNovelToServer,
                        child: Text(
                          'สร้างนิยาย',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 11, horizontal: 30),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 8,
                          shadowColor: Colors.greenAccent.withOpacity(0.5),
                          backgroundColor: Color(0xff3bc82a), // Light green
                          side: BorderSide(color: Color(0xe200b103), width: 2),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'นิยายที่คุณสร้าง',
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: novels.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _image != null
                            ? Image.memory(
                          base64Decode(novels[index]['novel_img']),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/placeholder.png',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            novels[index]['novel_name'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'โดย: ${novels[index]['novel_penname']}',
                            style: TextStyle(color: Colors.grey[600]),
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
