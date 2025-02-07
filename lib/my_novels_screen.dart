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

  final List<String> genres = [
    'แฟนตาซี',
    'โรแมนติก',
    'สืบสวน',
    'วิทยาศาสตร์',
    'ผจญภัย',
    'สยองขวัญ'
  ];

  @override
  void initState() {
    super.initState();
    fetchNovels();
  }

  Future<void> fetchNovels() async {
    try {
      final response = await http.get(
          Uri.parse("http://192.168.1.40:3000/novel"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          novels = data.map((novel) =>
          {
            'novel_name': novel['novel_name'].toString(),
            'novel_penname': novel['novel_penname'].toString(),
            'novel_img': novel['novel_img'] != null && novel['novel_img']
                .toString()
                .isNotEmpty
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
    if (_nameController.text.isEmpty || _authorController.text.isEmpty ||
        _selectedGenre == null || _image == null) {
      setState(() {
        _nameError = _nameController.text.isEmpty ? 'กรุณากรอกชื่อนิยาย' : null;
        _authorError =
        _authorController.text.isEmpty ? 'กรุณากรอกนามปากกา' : null;
      });
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.40:3000/novel'),
    );

    request.fields['novel_name'] = _nameController.text;
    request.fields['novel_penname'] = _authorController.text;
    request.fields['novel_type_id'] =
        (genreMap[_selectedGenre ?? ''] ?? 0).toString();

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
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'นิยายของฉัน',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF5e35b1), Color(0xFF9c27b0)],
            ),
          ),
        ),
        elevation: 6,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('ชื่อนิยาย', _nameController, _nameError),
              SizedBox(height: 16),
              _buildTextField('นามปากกา', _authorController, _authorError),
              SizedBox(height: 16),
              _buildDropdown(),
              SizedBox(height: 16),
              _buildImagePicker(),
              SizedBox(height: 24),
              _buildActionButtons(),
              SizedBox(height: 24),
              _buildNovelGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      String? errorText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepPurple),
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGenre,
      decoration: InputDecoration(
        labelText: 'เลือกแนวนิยาย',
        labelStyle: TextStyle(color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: genres.map((genre) =>
          DropdownMenuItem(value: genre, child: Text(genre))).toList(),
      onChanged: (value) => setState(() => _selectedGenre = value),
    );
  }

  Widget _buildImagePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // จัดให้เริ่มจากซ้าย
      crossAxisAlignment: CrossAxisAlignment.center, // จัดให้อยู่ระดับกลางแนวตั้ง
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _image != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(_image!, fit: BoxFit.cover),
          )
              : Icon(Icons.image, size: 60, color: Colors.deepPurple),
        ),
        SizedBox(width: 16), // เพิ่มช่องว่างระหว่างภาพและปุ่ม
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.upload_file, color: Colors.white),
          label: Text('อัปโหลดปก', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่กลาง
      children: [
        Flexible(
          child: ElevatedButton(
            onPressed: addNovelToServer,
            child: Text(
              'สร้างนิยาย',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(vertical: 14),
              minimumSize: Size(200, 50), // กำหนดขนาดขั้นต่ำ
              maximumSize: Size(300, 60), // กำหนดขนาดสูงสุด
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNovelGrid() {
    return GridView.builder(
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NovelDetailPage(novel: novels[index]),
              ),
            );
          },
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
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
    );
  }
}
