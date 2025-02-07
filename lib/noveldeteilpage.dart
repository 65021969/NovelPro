import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NovelDetailPage extends StatefulWidget {
  final int novelId;
  final String title;
  final String description;
  final String imageUrl;
  final String type;
  final String penname;

  NovelDetailPage({
    required this.novelId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.penname,
  });

  @override
  _NovelDetailPageState createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  bool isFavorite = false;
  final String apiUrl = "http://192.168.105.101:3000"; // ✅ URL ของเซิร์ฟเวอร์

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus(); // ✅ ตรวจสอบว่านิยายนี้อยู่ในรายการโปรดหรือไม่
  }

  // ✅ ฟังก์ชันเช็คว่านิยายอยู่ในรายการโปรดหรือไม่
  Future<void> checkFavoriteStatus() async {
    try {
      final response = await http.get(
        Uri.parse("$apiUrl/favorites/${widget.novelId}"),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        setState(() {
          isFavorite = result['isFavorite']; // ✅ ได้ค่าจากเซิร์ฟเวอร์
        });
      }
    } catch (e) {
      print("Error checking favorite status: $e");
    }
  }

  // ✅ ฟังก์ชันเพิ่ม/ลบ "นิยายโปรด"
  Future<void> toggleFavorite() async {
    try {
      if (isFavorite) {
        // 🔴 ลบจากรายการโปรด
        final response = await http.delete(
          Uri.parse("$apiUrl/favorites/${widget.novelId}"),
        );

        if (response.statusCode == 200) {
          setState(() {
            isFavorite = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("ลบ '${widget.title}' ออกจากนิยายโปรด ❌"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // ✅ เพิ่มในรายการโปรด
        final response = await http.post(
          Uri.parse("$apiUrl/favorites"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "novel_id": widget.novelId,
          }),
        );

        if (response.statusCode == 201) {
          setState(() {
            isFavorite = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("เพิ่ม '${widget.title}' ลงในนิยายโปรด ✅"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
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
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: widget.imageUrl.isNotEmpty
                    ? Image.network(
                  widget.imageUrl,
                  height: 500,
                  width: double.infinity,
                  fit: BoxFit.contain, // ใช้ BoxFit.contain แทน BoxFit.cover
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 100, color: Colors.grey),
                )
                    : Icon(
                    Icons.image_not_supported, size: 100, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                widget.title,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.category, color: Colors.purple),
                  SizedBox(width: 5),
                  Text(
                    "แนว : ${widget.type}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.grey[700]),
                  SizedBox(width: 5),
                  Text(
                    "ผู้เขียน : ${widget.penname}",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                widget.description,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleFavorite,
        backgroundColor: isFavorite ? Colors.red : Colors.purple,
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
      ),
    );
  }
}