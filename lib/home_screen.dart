import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'noveldeteilpage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _novels = [];

  @override
  void initState() {
    super.initState();
    fetchNovels();
  }

  // ดึงข้อมูลนิยายจาก API
  Future<void> fetchNovels() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.1.40:3000/novels"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _novels = data.map((novel) => {
            'novel_id': novel['novel_id'],
            'title': novel['novel_name'].toString(),
            'type': novel['novel_type_name'],
            'penname': novel['novel_penname'],
            'description': novel['description'] ?? 'ไม่มีคำอธิบาย',
            'image': novel['novel_img'] != null && novel['novel_img'].toString().isNotEmpty
                ? "http://192.168.1.40:3000/uploads/${novel['novel_img']}"
                : 'https://via.placeholder.com/150',
          }).toList();
        });
      } else {
        throw Exception("Failed to load novels");
      }
    } catch (e) {
      print("Error fetching novels: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการนิยาย', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      body: _novels.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 0.5,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.5,
          ),
          itemCount: _novels.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovelDetailPage(
                      novelId: _novels[index]['novel_id'],
                      title: _novels[index]['title'],
                      description: _novels[index]['description'],
                      type: _novels[index]['type'],
                      penname:_novels[index]['penname'],
                      imageUrl: _novels[index]['image'],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.purple, width: 1.1),
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: _novels[index]['image'],
                        height: MediaQuery.of(context).size.height * 0.19,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error, size: 50, color: Colors.red),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _novels[index]['title'],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4), // เพิ่มระยะห่าง
                          Text(
                            _novels[index]['type'],  // แสดงประเภทของนิยาย
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _novels[index]['penname'],  // แสดงประเภทของนิยาย
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
