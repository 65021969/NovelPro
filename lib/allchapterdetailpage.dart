import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class AllChapterDetailPage extends StatelessWidget {
  final Map<String, dynamic> novelVolumes;

  AllChapterDetailPage({required this.novelVolumes});

  @override
  Widget build(BuildContext context) {
    print(novelVolumes);

    // แปลง JSON เป็น Quill Document
    quill.Document? document = getQuillDocument(novelVolumes['chap_write']);
    quill.QuillController controller = quill.QuillController(
      document: document ?? quill.Document(),
      selection: TextSelection.collapsed(offset: 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("📖 เล่มที่ ${novelVolumes['chap_num'] ?? 'ไม่มีข้อมูล'}"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              quill.QuillEditor(
                controller: controller,
                scrollController: ScrollController(),
                focusNode: FocusNode(),
                // readOnly: true, // อ่านได้เท่านั้น
                // scrollable: true, // ทำให้สามารถเลื่อนข้อความได้
                // padding: EdgeInsets.all(8), // กำหนด padding
              )
            ],
          ),
        ),
      ),
    );
  }

  /// ฟังก์ชันแปลง JSON เป็น Quill Document
  quill.Document? getQuillDocument(dynamic chapWrite) {
    if (chapWrite == null) return null;

    try {
      // ถ้าเป็น String ที่เก็บ JSON → แปลงเป็น List ก่อน
      if (chapWrite is String) {
        chapWrite = jsonDecode(chapWrite);
      }

      // ตรวจสอบว่าเป็น List แล้วแปลงเป็น Document
      if (chapWrite is List) {
        return quill.Document.fromJson(chapWrite);
      }
    } catch (e) {
      print("❌ Error parsing chap_write: $e");
    }
    return null;
  }
}



