import 'package:flutter/material.dart';
import 'addnovelpage.dart';
import 'noveldeteilpage.dart';

class NavigationUI extends StatefulWidget {
  @override
  _NavigationUIState createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  List<Map<String, String>> books = []; // เปลี่ยนจาก List<String> เป็น List<Map>

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เรื่อง นิยาย"),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: books.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              books[index]['title'] ?? "ไม่มีชื่อเรื่อง",
              style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
            onTap: () async {
              // เมื่อกดที่ชื่อเล่มจะไปหน้าแสดงรายละเอียดของเล่มนั้น
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovelDetailPage(
                    // novelId: books[index]['novel_id'] ?? "ไม่มีชื่อเรื่อง",
                    title: books[index]['title'] ?? "ไม่มีชื่อเรื่อง",
                    type: books[index]['type'] ?? "ไม่มีชื่อเรื่อง",
                    penname:books[index]['penname'] ?? "ไม่มีชื่อเรื่อง",
                    description: books[index]['description'] ?? "ไม่มีคำอธิบาย",
                    imageUrl: books[index]['imageUrl'] ?? "https://via.placeholder.com/150", novelId: null,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Map<String, String>? newBook = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddnovelPage(novel: {},),
            ),
          );
          if (newBook != null) {
            setState(() {
              books.add(newBook);
            });
          }
        },
        label: Text("เพิ่มเล่ม"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}
