import 'package:flutter/material.dart';
import 'addnovelpage.dart'; // เพิ่มการนำเข้าหน้า AddNovelPage

class NovelDetailPage extends StatelessWidget {
  final Map<String, dynamic> novel;

  const NovelDetailPage({Key? key, required this.novel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(novel['novel_name'] ?? 'ไม่พบข้อมูล', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            novel['novel_img'] != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                novel['novel_img'] ?? 'https://via.placeholder.com/150', // placeholder image
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : Icon(Icons.broken_image, size: 50),
            SizedBox(height: 16),
            Text(
              'ชื่อนิยาย: ${novel['novel_name'] ?? 'ไม่ระบุชื่อ'}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('โดย: ${novel['novel_penname'] ?? 'ไม่ระบุนามปากกา'}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Text(
              'แนวนิยาย: ${novel['novel_type_name'] ?? 'ไม่ระบุ'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ส่งข้อมูลนิยายไปยังหน้า AddnovelPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddnovelPage(novel: novel),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
