import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'novel_detail_page.dart';

class MyNovelsScreen extends StatefulWidget {
  @override
  _MyNovelsScreenState createState() => _MyNovelsScreenState();
}

class _MyNovelsScreenState extends State<MyNovelsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  File? _image;
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

  final List<String> genres = ['แฟนตาซี', 'โรแมนติก', 'สืบสวน', 'วิทยาศาสตร์', 'ผจญภัย', 'สยองขวัญ'];

  @override
  void initState() {
    super.initState();
    fetchNovels();
  }

  Future<void> fetchNovels() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.1.40:3000/novel"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          novels = data.map((novel) => {
            'novel_name': novel['novel_name'].toString(),
            'novel_penname': novel['novel_penname'].toString(),
            'novel_img': novel['novel_img'] != null && novel['novel_img'].toString().isNotEmpty
                ? "http://192.168.1.40:3000/uploads/${novel['novel_img']}"
                : 'https://via.placeholder.com/150', // รูปสำรอง
            'novel_type_name': novel['novel_type_name'] ?? "ไม่ระบุ",
          }).toList();
        });
      } else {
        throw Exception("Failed to load novels");
      }
    } catch (e) {
      print("Error fetching novels: $e");
    }
  }

  Future<void> addNovelToServer() async {
    // Validate form fields
    if (_nameController.text.isEmpty || _authorController.text.isEmpty || _selectedGenre == null || _image == null) {
      setState(() {
        _nameError = _nameController.text.isEmpty ? 'กรุณากรอกชื่อนิยาย' : null;
        _authorError = _authorController.text.isEmpty ? 'กรุณากรอกนามปากกา' : null;
      });
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.40:3000/novel'),
    );

    request.fields['novel_name'] = _nameController.text;
    request.fields['novel_penname'] = _authorController.text;
    request.fields['novel_type_id'] = (genreMap[_selectedGenre ?? ''] ?? 0).toString();

    request.files.add(
      await http.MultipartFile.fromPath('novel_img', _image!.path),
    );

    final response = await request.send();
    if (response.statusCode == 201) {
      fetchNovels();
      _nameController.clear();
      _authorController.clear();
      _selectedGenre = null;
      setState(() => _image = null);
    } else {
      setState(() {
        _nameError = 'เกิดข้อผิดพลาด: ${response.reasonPhrase}';
      });
      print("เกิดข้อผิดพลาด: ${response.reasonPhrase}");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) {
      return Icon(Icons.broken_image, size: 50);
    } else {
      return Image.network(
        imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('นิยายของฉัน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อนิยาย',
                  labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                  errorText: _nameError,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'นามปากกา',
                  labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                  errorText: _authorError,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGenre,
                decoration: InputDecoration(
                  labelText: 'เลือกแนวนิยาย',
                  labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: genres.map((genre) => DropdownMenuItem(value: genre, child: Text(genre))).toList(),
                onChanged: (value) => setState(() => _selectedGenre = value),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _image != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    )
                        : Icon(Icons.image, size: 50, color: Colors.deepPurpleAccent),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.upload_file),
                    label: Text('อัปโหลดปก'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // ใช้ backgroundColor แทน primary
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: addNovelToServer,
                child: Text('สร้างนิยาย', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // ใช้ backgroundColor แทน primary
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: novels.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the NovelDetailPage and pass the novel data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NovelDetailPage(novel: novels[index]),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImage(novels[index]['novel_img']),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              novels[index]['novel_name'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'โดย: ${novels[index]['novel_penname']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
