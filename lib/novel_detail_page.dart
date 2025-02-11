import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'addnovelpage.dart';
import 'mychapterdetailpage.dart';

class NovelDetailPage extends StatefulWidget {
  final Map<String, dynamic> novel;

  const NovelDetailPage({Key? key, required this.novel}) : super(key: key);

  @override
  _NovelDetailPageState createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  List<dynamic> _novelVolumes = [];
  bool _isLoading = true; // สถานะโหลดข้อมูล

  @override
  void initState() {
    super.initState();
    _fetchNovelVolumes();
  }

  Future<void> _fetchNovelVolumes() async {
    try {
      final response = await http.get(Uri.parse('http://26.210.128.157:3000/novels/${widget.novel['novel_id']}'));

      if (response.statusCode == 200) {
        setState(() {
          _novelVolumes = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('โหลดข้อมูลไม่สำเร็จ');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // สีพื้นหลังแบบอ่อน
      appBar: AppBar(
        title: Text(
          widget.novel['novel_name'] ?? 'ไม่พบข้อมูล',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF673AB7), Color(0xFFD500F9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 6,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.novel['novel_img'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.novel['novel_img'] ?? 'https://via.placeholder.com/150',
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(Icons.broken_image, size: 100, color: Colors.grey),
            ),
            SizedBox(height: 16),
            _buildInfoTile(Icons.book, 'ชื่อนิยาย', widget.novel['novel_name'] ?? 'ไม่ระบุชื่อ'),
            _buildInfoTile(Icons.person, 'โดย', widget.novel['novel_penname'] ?? 'ไม่ระบุนามปากกา'),
            _buildInfoTile(Icons.category, 'แนวนิยาย', widget.novel['novel_type_name'] ?? 'ไม่ระบุ'),
            SizedBox(height: 20),
            Text(
              "รายการเล่มที่มี",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 8),
            _isLoading
                ? _buildShimmerLoading() // ใช้ shimmer effect ระหว่างโหลดข้อมูล
                : _novelVolumes.isEmpty
                ? Center(
              child: Text("ยังไม่มีเล่มที่บันทึก", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _novelVolumes.length,
              itemBuilder: (context, index) {
                return _buildNovelVolumeCard(_novelVolumes[index]);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddnovelPage(novel: widget.novel),
            ),
          );

          if (result == true) {
            _fetchNovelVolumes(); // โหลดข้อมูลใหม่เมื่อมีการเพิ่มเล่ม
          }
        },
        icon: Icon(Icons.add),
        label: Text("เพิ่มเล่ม"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          SizedBox(width: 10),
          Text(
            "$title: ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNovelVolumeCard(Map<String, dynamic> volume) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MyChapterDetailPage(novelVolumes: volume),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.menu_book, color: Colors.deepPurpleAccent),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "เล่มที่: ${volume['chap_num']}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          height: 50,
          width: double.infinity,
        );
      }),
    );
  }
}
