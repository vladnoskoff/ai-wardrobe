import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenSettings extends StatefulWidget {
  const HomeScreenSettings({super.key});

  @override
  _HomeScreenSettingsState createState() => _HomeScreenSettingsState();
}

class _HomeScreenSettingsState extends State<HomeScreenSettings> {
  String location = '55.669, 37.481';
  String apiKey = '**********';
  String serialNumber = '0000001';

  void showEditDialog(String title, String currentValue, Function(String) onEdit) {
    final TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Изменить $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: title,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onEdit(controller.text);
              }
              Navigator.pop(context);
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  Widget buildOption(IconData icon, String title, String value, Function(String) onEdit, {bool showApiLabel = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: double.infinity,
      height: 59,
      decoration: BoxDecoration(
        color: const Color(0xFF62DEFA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16,
            top: 12,
            child: Icon(
              icon,
              size: 32,
              color: Colors.black,
            ),
          ),
          if (showApiLabel)
            Positioned(
              left: 50,
              top: 15,
              child: Text(
                'API:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Positioned(
            left: showApiLabel ? 100 : 60,
            top: 14,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 12,
            child: GestureDetector(
              onTap: () => showEditDialog(title, value, onEdit),
              child: Container(
                width: 30,
                height: 30,
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Дом'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildOption(CupertinoIcons.location, 'Координаты', location, (value) {
              setState(() => location = value);
            }),
            buildOption(CupertinoIcons.lock, 'API', apiKey, (value) {
              setState(() => apiKey = value);
            }, showApiLabel: true),
            buildOption(CupertinoIcons.wifi, 'SN', serialNumber, (value) {
              setState(() => serialNumber = value);
            }),
          ],
        ),
      ),
    );
  }
}
