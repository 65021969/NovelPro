import 'dart:convert'; // ต้องใช้ jsonDecode
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class MyChapterDetailPage extends StatelessWidget {
  final Map<String, dynamic> novelVolumes;

  MyChapterDetailPage({required this.novelVolumes});

  // ฟังก์ชันแปลง JSON เป็น Quill Document
  quill.Document? getQuillDocument(dynamic chapWrite) {
    if (chapWrite == null) return null;

    try {
      // ถ้าเป็น String ที่เก็บ JSON → แปลงเป็น List ก่อน
      if (chapWrite is String) {
        chapWrite = jsonDecode(chapWrite);  // แปลง String เป็น List
      }

      // ตรวจสอบว่าเป็น List แล้วแปลงเป็น Document
      if (chapWrite is List) {
        return quill.Document.fromJson(chapWrite);  // สร้าง Document จาก List
      }
    } catch (e) {
      print("❌ Error parsing chap_write: $e");
    }
    return null;  // ถ้าไม่สามารถแปลงได้ ให้ return null
  }

  @override
  Widget build(BuildContext context) {
    // เรียกใช้ getQuillDocument เพื่อแปลง chap_write เป็น Quill Document
    final quillDocument = getQuillDocument(novelVolumes['chap_write']);

    if (quillDocument == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("เล่มที่ ${novelVolumes['chap_num'] ?? 'ไม่มีข้อมูล'} ", style: TextStyle(color: Colors.white),),
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
        body: Center(child: Text("ไม่มีเนื้อหา")),
      );
    }

    // สร้าง QuillController จาก Document ที่แปลงแล้ว
    final quillController = quill.QuillController(
      document: quillDocument,
      selection: TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("เล่มที่ ${novelVolumes['chap_num'] ?? 'ไม่มีข้อมูล'}"),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              // ใช้ QuillEditor ในโหมด readOnly เพื่อแสดงข้อความที่จัดรูปแบบ
              quill.QuillEditor(
                controller: quillController,
                // readOnly: true,  // อ่านอย่างเดียว ห้ามแก้ไข
                scrollController: ScrollController(),
                focusNode: FocusNode(),
                // padding: EdgeInsets.zero,
                // scrollable: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
