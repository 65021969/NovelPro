import 'package:flutter/material.dart';

class AddnovelPage extends StatefulWidget {
  final int bookNumber;
  AddnovelPage({required this.bookNumber});

  @override
  _AddnovelPageState createState() => _AddnovelPageState();
}

class _AddnovelPageState extends State<AddnovelPage> {
  TextEditingController _controller = TextEditingController();

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
              "ชื่อเล่ม ${widget.bookNumber}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "กรอกข้อความของเล่มนี้",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String newBookTitle = "เล่มที่ ${widget.bookNumber}";
                    if (newBookTitle.isNotEmpty) {
                      Navigator.pop(context, newBookTitle);
                    }
                  },
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