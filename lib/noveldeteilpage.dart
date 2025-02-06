import 'package:flutter/material.dart';

class NovelDetailPage extends StatefulWidget {
  final String bookTitle;
  NovelDetailPage({required this.bookTitle});

  @override
  _NovelDetailPageState createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the book title
    _controller = TextEditingController(text: widget.bookTitle);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียดของ ${widget.bookTitle}"),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bookTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "กรอกเนื้อหาของเล่มนี้",
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // บันทึกเนื้อหาหรือชื่อเล่มใหม่ที่แก้ไข
                    String updatedContent = _controller.text;
                    // คุณสามารถทำการบันทึกข้อมูลใหม่ที่นี่ (เช่น อัปเดตข้อมูลในฐานข้อมูลหรือแสดงผลอื่น ๆ)
                    Navigator.pop(context, updatedContent); // ปิดหน้าและส่งค่ากลับ
                  },
                  child: Text("บันทึก"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // เพิ่มฟังก์ชันการอัปโหลด (เช่น การส่งข้อมูลไปยังเซิร์ฟเวอร์)
                  },
                  child: Text("อัปโหลด"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
