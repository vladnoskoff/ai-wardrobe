import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/clothes.dart';
import 'add_clothes_screen.dart';
import 'clothes_detail_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  _WardrobeScreenState createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  List<Clothes> clothes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClothes();
  }

  Future<void> fetchClothes() async {
    try {
      final response = await ApiService.getClothes();
      setState(() {
        clothes = response.map((json) => Clothes.fromJson(json)).toList().cast<Clothes>();
        isLoading = false;
      });
    } catch (e) {
      print("Ошибка при загрузке одежды: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteClothes(int clothesId) async {
    try {
      await ApiService.deleteClothes(clothesId);
      setState(() {
        clothes.removeWhere((item) => item.id == clothesId);
      });
    } catch (e) {
      print("Ошибка при удалении одежды: $e");
    }
  }

  void navigateToAddClothes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddClothesScreen()),
    ).then((_) => fetchClothes());
  }

  void navigateToDetailScreen(Clothes item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClothesDetailScreen(clothes: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Гардеробус'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: navigateToAddClothes,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: clothes.length,
                      itemBuilder: (context, index) {
                        final item = clothes[index];
                        return GestureDetector(
                          onTap: () => navigateToDetailScreen(item),
                          child: Container( // Заменил Card на Container
                            decoration: BoxDecoration(
                              color: const Color(0xFF62DEFA),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 12,
                                  top: 14,
                                  child: Container(
                                    width: 99,
                                    height: 127,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: item.imageUrl != null
                                          ? DecorationImage(
                                              image: NetworkImage(item.imageUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 160,
                                  top: 14,
                                  child: Container(
                                    width: 26,
                                    height: 31,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCFDDE0),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ),
                                ),                             
                                Positioned(
                                  left: 160,
                                  top: 110,
                                  child: GestureDetector(
                                    onTap: () => deleteClothes(item.id),
                                    child: Container(
                                      width: 26,
                                      height: 31,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF0D0D),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
