import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class AddnovelPage extends StatefulWidget {
  final Map<String, dynamic> novel;

  AddnovelPage({required this.novel});

  @override
  _AddnovelPageState createState() => _AddnovelPageState();
}

class _AddnovelPageState extends State<AddnovelPage> {
  TextEditingController _bookNumberController = TextEditingController();
  quill.QuillController _quillController = quill.QuillController.basic();

  Future<void> _submitNovel() async {
    try {
      final jsonDescription = json.encode(_quillController.document.toDelta().toJson());

      final response = await http.post(
        Uri.parse('http://192.168.105.101:3000/addnovel'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'novel_id': widget.novel['novel_id'],
          'chap_write': jsonDescription,
          'novel_num': int.tryParse(_bookNumberController.text) ?? 0,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, 'บันทึกเล่ม ${_bookNumberController.text} สำเร็จ');
      } else {
        throw Exception('ไม่สามารถบันทึกข้อมูลได้');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มเล่มใหม่",style: TextStyle(color: Colors.white), ),
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

            // ✅ แก้ปัญหา QuillToolbar
            quill.QuillToolbar.simple(controller: _quillController),
            SizedBox(height: 10),



            // ✅ แก้ไข QuillEditor ให้ใช้งานได้บน Android
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: quill.QuillEditor(
                  controller: _quillController,
                  // readOnly: false,
                  scrollController: ScrollController(),
                  focusNode: FocusNode(),
                  // autoFocus: true,
                  // expands: true,
                  // padding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _submitNovel,
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
