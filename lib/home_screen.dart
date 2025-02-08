import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'noveldeteilpage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _novels = [];
  List<Map<String, dynamic>> _filteredNovels = [];

  @override
  void initState() {
    super.initState();
    fetchNovels(); // โหลดข้อมูลจาก API
  }

  // ดึงข้อมูลนิยายจาก API
  Future<void> fetchNovels() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.1.40:3000/novels"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _novels = data.map((novel) => {
            'novel_id': novel['novel_id'],
            'title': novel['novel_name'].toString(),
            'type': novel['novel_type_name'],
            'penname': novel['novel_penname'],
            'description': novel['description'] ?? 'ไม่มีคำอธิบาย',
            'image': novel['novel_img'] != null && novel['novel_img'].toString().isNotEmpty
                ? "http://192.168.1.40:3000/uploads/${novel['novel_img']}"
                : 'https://via.placeholder.com/150',
          }).toList();

          _filteredNovels = List.from(_novels); // อัปเดตข้อมูลที่กรองหลังจากโหลดสำเร็จ
        });
      } else {
        throw Exception("Failed to load novels");
      }
    } catch (e) {
      print("Error fetching novels: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายการนิยาย',
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
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white), // ปุ่มค้นหาสีขาว
            onPressed: () {
              // เปิดหน้าค้นหา
              showSearch(
                context: context,
                delegate: NovelSearchDelegate(novels: _novels),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _genreButton(context, 'ทั้งหมด'),
                  _genreButton(context, 'แฟนตาซี'),
                  _genreButton(context, 'โรแมนติก'),
                  _genreButton(context, 'สืบสวน'),
                  _genreButton(context, 'วิทยาศาสตร์'),
                  _genreButton(context, 'ผจญภัย'),
                  _genreButton(context, 'สยองขวัญ'),
                ],
              ),
            ),
          ),
          Expanded(
            child: _filteredNovels.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Padding(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                key: ValueKey(_filteredNovels.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.5,
                  mainAxisSpacing: 0.5,
                  childAspectRatio: 0.5, // ปรับค่าให้สูงขึ้น
                ),
                itemCount: _filteredNovels.length,
                itemBuilder: (context, index) {
                  return _novelCard(context, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genreButton(BuildContext context, String genre) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              if (genre == 'ทั้งหมด') {
                _filteredNovels = List.from(_novels);
              } else {
                _filteredNovels = _novels.where((novel) => novel['type'] == genre).toList();
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          ),
          child: Text(
            genre,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _novelCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NovelDetailPage(
              novelId: _filteredNovels[index]['novel_id'],
              title: _filteredNovels[index]['title'],
              description: _filteredNovels[index]['description'],
              type: _filteredNovels[index]['type'],
              penname: _filteredNovels[index]['penname'],
              imageUrl: _filteredNovels[index]['image'],
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey, width: 0.5),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: _filteredNovels[index]['image'],
                height: MediaQuery.of(context).size.height * 0.19,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error, size: 50, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _filteredNovels[index]['title'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    _filteredNovels[index]['type'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _filteredNovels[index]['penname'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NovelSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> novels;

  NovelSearchDelegate({required this.novels});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = novels
        .where((novel) =>
        novel['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    // หากไม่มีผลลัพธ์แสดงข้อความ
    if (results.isEmpty) {
      return Center(
          child: Text('ไม่พบผลลัพธ์', style: TextStyle(color: Colors.grey)));
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
        childAspectRatio: 0.5, // ปรับให้เหมาะสม
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return _novelCard(context, index, results);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // หากยังไม่ได้พิมพ์อะไรเลย (query ว่าง) จะไม่แสดงผลลัพธ์
    if (query.isEmpty) {
      return Center(
        child: Text('กรุณาพิมพ์คำค้นหา', style: TextStyle(color: Colors.grey)),
      );
    }

    final suggestions = novels
        .where((novel) =>
        novel['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
        childAspectRatio: 0.5, // ปรับให้เหมาะสม
      ),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return _novelCard(context, index, suggestions);
      },
    );
  }


  // ฟังก์ชันในการสร้างการ์ดนิยายที่ใช้ทั้งใน `buildResults` และ `buildSuggestions`
  Widget _novelCard(BuildContext context, int index,
      List<Map<String, dynamic>> novelList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NovelDetailPage(
                  novelId: novelList[index]['novel_id'],
                  title: novelList[index]['title'],
                  description: novelList[index]['description'],
                  type: novelList[index]['type'],
                  penname: novelList[index]['penname'],
                  imageUrl: novelList[index]['image'],
                ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey, width: 0.5),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: novelList[index]['image'],
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.19,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, size: 50, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    novelList[index]['title'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    novelList[index]['type'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    novelList[index]['penname'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}