import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddnovelPage extends StatefulWidget {
  final Map<String, dynamic> novel; // เพิ่มเพื่อรับข้อมูลจากหน้า NovelDetailPage

  AddnovelPage({required this.novel});

  @override
  _AddnovelPageState createState() => _AddnovelPageState();
}

class _AddnovelPageState extends State<AddnovelPage> {
  TextEditingController _bookNumberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _submitNovel() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.40:3000/addnovel'), // URL ของ API ที่จะรับข้อมูล
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'novel_name': widget.novel['novel_name'], // ใช้ข้อมูลจาก novel ที่ส่งมาจาก NovelDetailPage
          'novel_penname': widget.novel['novel_penname'],
          'novel_type_name': widget.novel['novel_type_name'],
          'description': _descriptionController.text,
          'novel_number': int.tryParse(_bookNumberController.text) ?? 0, // หมายเลขเล่มที่กรอก
        }),
      );

      if (response.statusCode == 200) {
        // ถ้าบันทึกสำเร็จ
        Navigator.pop(context, 'บันทึกเล่ม ${_bookNumberController.text} สำเร็จ');
      } else {
        throw Exception('ไม่สามารถบันทึกข้อมูลได้');
      }
    } catch (e) {
      print("Error: $e");
      // จัดการกับข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มเล่มใหม่"),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "หมายเลขเล่ม",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _bookNumberController,
              decoration: InputDecoration(
                hintText: "กรอกหมายเลขเล่ม",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "กรอกคำอธิบาย",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _submitNovel, // เรียกใช้ฟังก์ชันเพื่อส่งข้อมูล
                  child: Text("บันทึก"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
