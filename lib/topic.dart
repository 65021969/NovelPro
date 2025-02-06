import 'package:flutter/material.dart';
import 'addnovelpage.dart';
import 'noveldeteilpage.dart';

class NavigationUI extends StatefulWidget {
  @override
  _NavigationUIState createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  List<String> books = [];

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
              books[index],
              style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
            onTap: () async {
              // เมื่อกดที่ชื่อเล่มจะไปหน้าแสดงรายละเอียดของเล่มนั้น
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovelDetailPage(bookTitle: books[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? newBook = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddnovelPage(bookNumber: books.length + 1),
            ),
          );
          if (newBook != null && newBook.isNotEmpty) {
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