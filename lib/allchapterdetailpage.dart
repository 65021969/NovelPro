import 'package:flutter/material.dart';

class AllChapterDetailPage extends StatelessWidget {
  final int novelId;
  final String novelTitle;
  final String novelDescription;
  final String novelImageUrl;
  final String novelType;
  final String novelPenname;
  final List<Map<String, dynamic>> novelVolumes;

  AllChapterDetailPage({
    required this.novelId,
    required this.novelTitle,
    required this.novelDescription,
    required this.novelImageUrl,
    required this.novelType,
    required this.novelPenname,
    required this.novelVolumes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(novelTitle),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // แสดงแนวของนิยาย
              Text(
                "📖 แนว: $novelType",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // แสดงชื่อผู้เขียน
              Text(
                "✍️ โดย: $novelPenname",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),

              Divider(),

              // รายการเล่มที่มีทั้งหมด
              Text(
                "📚 รายการเล่ม",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              novelVolumes.isEmpty
                  ? Text("ไม่มีข้อมูลเล่ม", style: TextStyle(fontSize: 18, color: Colors.grey))
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: novelVolumes.length,
                itemBuilder: (context, index) {
                  final volume = novelVolumes[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        "เล่มที่ ${volume['chap_num']}: ${volume['chap_name'] ?? 'ไม่มีชื่อเล่ม'}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        volume['chap_write'] ?? "ไม่มีเนื้อหา",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        // แสดงรายละเอียดของเล่มที่เลือก
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyChapterDetailPage(novelVolumes: volume),
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
    );
  }
}

// 📌 หน้านี้ใช้สำหรับแสดงรายละเอียดของแต่ละเล่ม
class MyChapterDetailPage extends StatelessWidget {
  final Map<String, dynamic> novelVolumes;

  MyChapterDetailPage({required this.novelVolumes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(novelVolumes['chap_name'] ?? "ไม่มีชื่อเล่ม"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // แสดงแนวของนิยาย
              Text(
                "📖 แนว: ${novelVolumes['novel_type_id']}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // แสดงชื่อผู้เขียน
              Text(
                "✍️ โดย: ${novelVolumes['novel_penname']}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),

              Divider(),

              // แสดงเนื้อหา
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
