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
          Uri.parse("http://192.168.105.101:3000/novel"));

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
                ? "http://192.168.105.101:3000/uploads/${novel['novel_img']}"
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
      Uri.parse('http://192.168.105.101:3000/novel'),
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
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
        centerTitle: false,
      ),
      body: Container(
        width: double.infinity, // เพิ่มการกำหนดความกว้าง
        height: MediaQuery.of(context).size.height, // เพิ่มการกำหนดความสูง
        color: Color(0xFFE0E0E0), // พื้นหลังสี
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // โซนสร้างนิยาย
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: Colors.deepPurple.withOpacity(0.3),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'สร้างนิยายใหม่',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildTextField('ชื่อนิยาย', _nameController, _nameError),
                      SizedBox(height: 16),
                      _buildTextField(
                          'นามปากกา', _authorController, _authorError),
                      SizedBox(height: 16),
                      _buildDropdown(),
                      SizedBox(height: 16),
                      _buildImagePicker(),
                      SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // โซนรายการนิยาย
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: Colors.deepPurple.withOpacity(0.3),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'รายการนิยายของฉัน',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildNovelGrid(),
                    ],
                  ),
                ),
              ),
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
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepPurple, fontSize: 16),
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGenre,
      decoration: InputDecoration(
        labelText: 'เลือกแนวนิยาย',
        labelStyle: TextStyle(color: Colors.deepPurple, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: genres.map((genre) =>
          DropdownMenuItem(value: genre, child: Text(genre))).toList(),
      onChanged: (value) => setState(() => _selectedGenre = value),
    );
  }

  Widget _buildImagePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 3),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: _image != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(_image!, fit: BoxFit.cover),
          )
              : Icon(Icons.image, size: 60, color: Colors.deepPurple),
        ),
        SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.upload_file, color: Colors.white),
          label: Text('อัปโหลดปก', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    double buttonWidth = 150;
    double buttonHeight = 40;
    double positionValue = 0.26;

    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment(positionValue, 0),
            child: ElevatedButton(
              onPressed: addNovelToServer,
              child: Text(
                'สร้างนิยาย',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size(buttonWidth, buttonHeight),
                maximumSize: Size(300, 80),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNovelGrid() {
    return novels.isEmpty
        ? Center(
      child: Text(
        'ไม่มีข้อมูลนิยาย',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    )
        : GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
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
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Colors.deepPurple.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      novels[index]['novel_img'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                            Icons.broken_image, size: 50, color: Colors.grey);
                      },
                    ),
                  ),
                ),
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

