import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'allchapterdetailpage.dart';

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
  final String apiUrl = "http://192.168.105.101:3000"; // URL ของเซิร์ฟเวอร์
  List<Map<String, dynamic>> volumes = []; // รายการเล่มของนิยาย

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
    fetchVolumes();
  }

  Future<void> checkFavoriteStatus() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/favorites/${widget.novelId}"));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        setState(() {
          isFavorite = result['isFavorite'];
        });
      }
    } catch (e) {
      print("Error checking favorite status: $e");
    }
  }

  Future<void> toggleFavorite() async {
    try {
      if (isFavorite) {
        final response = await http.delete(Uri.parse("$apiUrl/favorites/${widget.novelId}"));
        if (response.statusCode == 200) {
          setState(() {
            isFavorite = false;
          });
        }
      } else {
        final response = await http.post(
          Uri.parse("$apiUrl/favorites"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"novel_id": widget.novelId}),
        );
        if (response.statusCode == 201) {
          setState(() {
            isFavorite = true;
          });
        }
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  Future<void> fetchVolumes() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/novels/${widget.novelId}"));
      if (response.statusCode == 200) {
        final List<dynamic> result = json.decode(response.body);
        setState(() {
          volumes = result.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print("Error fetching volumes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF5e35b1), Color(0xFF9c27b0)]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.imageUrl,
                  height: 500,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Text(widget.title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.category, color: Colors.purple),
                  SizedBox(width: 5),
                  Text("แนว : ${widget.type}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.grey[700]),
                  SizedBox(width: 5),
                  Text("ผู้เขียน : ${widget.penname}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                ],
              ),
              SizedBox(height: 10),
              Text(widget.description, style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text("รายการเล่ม", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              volumes.isEmpty
                  ? Center(child: Text("ไม่มีข้อมูลเล่ม", style: TextStyle(fontSize: 18, color: Colors.grey)))
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: volumes.length,
                itemBuilder: (context, index) {
                  final volume = volumes[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text("เล่มที่ ${volume['chap_num']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllChapterDetailPage(
                              novelId: widget.novelId,
                              novelTitle: widget.title,
                              novelDescription: widget.description,
                              novelImageUrl: widget.imageUrl,
                              novelType: widget.type,
                              novelPenname: widget.penname,
                              novelVolumes: volumes, // ส่งข้อมูลทั้งหมดไป
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleFavorite,
        backgroundColor: isFavorite ? Colors.red : Colors.purple,
        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
      ),
    );
  }
}
