import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // ข้อมูลนิยาย (มีรูป)
  final List<Map<String, String>> _novels = [
    {'title': 'Solo', 'image': 'assets/novel1.jpg'},
    {'title': 'รักวัยเรียน', 'image': 'assets/novel2.jpg'},
    {'title': 'สืบสวนลึกลับ', 'image': 'assets/novel3.jpg'},
    {'title': 'แอ็กชันต่อสู้', 'image': 'assets/novel4.jpg'},
    {'title': 'โลกอนาคตไซไฟ', 'image': 'assets/novel5.jpg'},
    {'title': 'ชีวิตดราม่า', 'image': 'assets/novel6.jpg'},
  ];

  // รายการหมวดหมู่
  final List<String> _categories = [
    'ทั้งหมด', 'แฟนตาซี', 'รักโรแมนติก', 'สืบสวน', 'แอ็กชัน', 'ไซไฟ', 'ดราม่า'
  ];

  List<Map<String, String>> _filteredNovels = [];
  String _selectedCategory = 'ทั้งหมด';

  @override
  void initState() {
    super.initState();
    _filteredNovels = List.from(_novels);
  }

  // ฟังก์ชันค้นหานิยาย (รองรับภาษาไทย)
  void _filterNovels(String query) {
    setState(() {
      _filteredNovels = _novels
          .where((novel) =>
          novel['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // ฟังก์ชันเปลี่ยนหมวดหมู่
  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'ทั้งหมด') {
        _filteredNovels = List.from(_novels);
      } else {
        _filteredNovels = _novels
            .where((novel) => novel['title']!.contains(category))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'นิยายทั้งหมด',
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

      body: Column(
        children: [
          // ช่องค้นหานิยาย
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              controller: _searchController,
              onChanged: _filterNovels,
              decoration: InputDecoration(
                hintText: 'ค้นหานิยาย...',
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ปุ่มหมวดหมู่ (แนวนอน)
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                String category = _categories[index];
                bool isSelected = category == _selectedCategory;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Color(0xFF9733ee) : Colors.white,
                      foregroundColor: isSelected ? Colors.white : Color(0xFF9733ee),//สี text
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Color(0XFF9733ff)),
                      ),
                    ),
                    onPressed: () => _filterByCategory(category),
                    child: Text(category, style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),

          // GridView ของนิยาย
          Expanded(
            child: _filteredNovels.isEmpty
                ? Center(child: Text('ไม่มีนิยายที่ตรงกับคำค้นหา', style: TextStyle(fontSize: 16, color: Colors.grey)))
                : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // แสดง ... นิยายในแต่ละแถว
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: _filteredNovels.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // รูปนิยาย
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.asset(
                            _filteredNovels[index]['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      // ชื่อเรื่อง
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          _filteredNovels[index]['title']!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
