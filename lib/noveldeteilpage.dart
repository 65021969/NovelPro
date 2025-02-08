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
  List<Map<String, dynamic>> comments = []; // รายการคอมเม้นต์
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
    fetchVolumes();
    fetchComments();
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
          volumes = result.cast<Map<String, dynamic>>(); // เลือกข้อมูลจาก server
        });
      }
    } catch (e) {
      print("Error fetching volumes: $e");
    }
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/comment/${widget.novelId}"));
      if (response.statusCode == 200) {
        final List<dynamic> result = json.decode(response.body);
        setState(() {
          comments = result.cast<Map<String, dynamic>>(); // เลือกข้อมูลจาก server
        });
      }
    } catch (e) {
      print("Error fetching comments: $e");
    }
  }

  Future<void> postComment() async {
    if (commentController.text.isEmpty) return;
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/comment"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "novel_id": widget.novelId,
          "com_text": commentController.text,
        }),
      );
      if (response.statusCode == 201) {
        setState(() {
          comments.add({
            'com_text': commentController.text,
            // 'author': 'User', // You can replace this with the actual username
          });
        });
        commentController.clear();
      }
    } catch (e) {
      print("Error posting comment: $e");
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
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle additional options
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imageUrl,
                  height: 500,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Text("ชื่อนิยาย: ${widget.title}", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.category, color: Colors.deepPurpleAccent),
                  SizedBox(width: 5),
                  Text(
                    "แนว : ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // ตัวหนา
                  ),
                  Text(
                    "${widget.type}",
                    style: TextStyle(fontSize: 18), // ไม่ต้องทำตัวหนา
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.deepPurpleAccent),
                  SizedBox(width: 5),
                  Text(
                    "ผู้เขียน : ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // ตัวหนา
                  ),
                  Text(
                    "${widget.penname}",
                    style: TextStyle(fontSize: 18, ), // ไม่ต้องทำตัวหนา
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text("รายการเล่ม", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
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
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.menu_book, color: Colors.deepPurpleAccent),
                      title: Text("เล่มที่ ${volume['chap_num']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllChapterDetailPage(novelVolumes: volumes[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text("ความคิดเห็น", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              SizedBox(height: 10),
              comments.isEmpty
                  ? Center(child: Text("ยังไม่มีความคิดเห็น", style: TextStyle(fontSize: 18, color: Colors.grey)))
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(comment['user_name'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(comment['com_text'].toString()),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "พิมพ์ความคิดเห็นของคุณ...",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: postComment,
                child: Text("โพสต์ความคิดเห็น"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleFavorite,
        backgroundColor: isFavorite ? Colors.red : Colors.deepPurple,
        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
      ),
    );
  }
}
