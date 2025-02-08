import 'package:flutter/material.dart';

class MyChapterDetailPage extends StatelessWidget {
  final Map<String, dynamic> novelVolumes;

  MyChapterDetailPage({required this.novelVolumes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(novelVolumes['novel_name'] ?? "ไม่มีชื่อเล่ม"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "📖 ${novelVolumes['novel_type_id']}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "✍️ โดย: ${novelVolumes['novel_penname']}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Divider(),
              Text(
                novelVolumes['chap_write'] ?? "ไม่มีเนื้อหา",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
