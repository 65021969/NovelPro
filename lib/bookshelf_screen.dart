import 'package:flutter/material.dart';

class BookshelfScreen extends StatelessWidget {
  final List<String> books = ['หนังสือ A', 'หนังสือ B', 'หนังสือ C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text(
        'ชั้นหนังสือ',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white, // เปลี่ยนสีข้อความใน AppBar เป็นสีขาว
      ),
    ),
        flexibleSpace: Container(
         decoration: BoxDecoration(
           gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF396afc), Color(0xFF2948ff)], // ไล่สีจาก #396afc ไป #2948ff
            ),
        ),
       ),
    ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, size: 50, color: Colors.blue),
                SizedBox(height: 10),
                Text(books[index], style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
