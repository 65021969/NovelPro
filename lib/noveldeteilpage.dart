import 'package:flutter/material.dart';

class NovelDetailPage extends StatefulWidget {

  final String title;
  final String description;
  final String imageUrl;

  NovelDetailPage({required this.title, required this.description, required this.imageUrl});

  @override
  _NovelDetailPageState createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
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
        title: Text("รายละเอียดของ ${widget.title}"),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 20),
            Text(
              widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

}
