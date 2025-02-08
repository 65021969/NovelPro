import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'addnovelpage.dart';
import 'mychapterdetailpage.dart'; // Import หน้าสำหรับเพิ่มเล่มใหม่

class NovelDetailPage extends StatefulWidget {
  final Map<String, dynamic> novel;

  const NovelDetailPage({Key? key, required this.novel}) : super(key: key);

  @override
  _NovelDetailPageState createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  List<dynamic> _novelVolumes = []; // เก็บข้อมูลเล่มที่ดึงจากฐานข้อมูล

  @override
  void initState() {
    super.initState();
    _fetchNovelVolumes(); // โหลดข้อมูลเมื่อเปิดหน้า
  }

  Future<void> _fetchNovelVolumes() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.40:3000/novels/${widget.novel['novel_id']}'));

      if (response.statusCode == 200) {
        setState(() {
          _novelVolumes = json.decode(response.body);
        });
      } else {
        throw Exception('โหลดข้อมูลไม่สำเร็จ');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.novel);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.novel['novel_name'] ?? 'ไม่พบข้อมูล', style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดงรูปนิยาย
            widget.novel['novel_img'] != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.novel['novel_img'] ?? 'https://via.placeholder.com/150',
                height: 500,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            )
                : Icon(Icons.broken_image, size: 50),
            SizedBox(height: 16),
            Text(
              'ชื่อนิยาย: ${widget.novel['novel_name'] ?? 'ไม่ระบุชื่อ'}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'โดย: ${widget.novel['novel_penname'] ?? 'ไม่ระบุนามปากกา'}',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Text(
              'แนวนิยาย: ${widget.novel['novel_type_name'] }',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "รายการเล่มที่มี",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _novelVolumes.isEmpty
                  ? Center(child: Text("ยังไม่มีเล่มที่บันทึก"))
                  : ListView.builder(
                itemCount: _novelVolumes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("เล่มที่: ${_novelVolumes[index]['chap_num']}"),
                      subtitle: Text(_novelVolumes[index]['chap_write']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyChapterDetailPage(
                              novelVolumes: _novelVolumes[index], // ส่งข้อมูลเล่มที่เลือกไป
                            ),
                          ),
                        );
                      },
                    ),

                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // เปิดหน้า AddnovelPage แล้วรอค่ากลับมา
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddnovelPage(novel: widget.novel),
            ),
          );

          // ถ้ามีการเพิ่มเล่มใหม่ โหลดข้อมูลใหม่
          if (result == true) {
            _fetchNovelVolumes();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
