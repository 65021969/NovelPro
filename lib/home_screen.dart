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
      final response = await http.get(Uri.parse("http://192.168.1.40:3000/novel"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _novels = data.map((novel) => {
            'title': novel['novel_name'].toString(),
            'description': novel['description'] ?? 'ไม่มีคำอธิบาย',
            'image': novel['novel_img'] != null && novel['novel_img'].toString().isNotEmpty
                ? "http://192.168.1.40:3000/uploads/${novel['novel_img']}" // ใช้ URL ของเซิร์ฟเวอร์
                : 'https://via.placeholder.com/150', // รูปสำรอง
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
      ),
      body: _novels.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.75,
          ),
          itemCount: _novels.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovelDetailPage(
                      title: _novels[index]['title'],
                      description: _novels[index]['description'],
                      imageUrl: _novels[index]['image'],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: _novels[index]['image'],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _novels[index]['title'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
