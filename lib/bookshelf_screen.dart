import 'package:flutter/material.dart';

class BookshelfScreen extends StatelessWidget {
  final List<String> books = ['หนังสือ A', 'หนังสือ B', 'หนังสือ C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ชั้นหนังสือ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF5e35b1), Color(0xFF9c27b0)],
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
