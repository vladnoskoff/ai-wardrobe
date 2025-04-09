import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String login = 'Ivan123';
  String name = 'Иван Иванов';
  String email = 'ivan@example.com';
  String phone = '+7 900 000 0000';
  String password = '******';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Аккаунт'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildAccountOption(Icons.login, 'Логин', login, (value) {
              setState(() => login = value);
            }),
            const SizedBox(height: 16),
            buildAccountOption(Icons.person, 'ФИО', name, (value) {
              setState(() => name = value);
            }),
            const SizedBox(height: 16),
            buildAccountOption(Icons.phone, 'Телефон', phone, (value) {
              setState(() => phone = value);
            }),
            const SizedBox(height: 16),
            buildAccountOption(Icons.email, 'Почта', email, (value) {
              setState(() => email = value);
            }),
            const SizedBox(height: 16),
            buildAccountOption(Icons.lock, 'Пароль', password, (value) {
              setState(() => password = value);
            }),
            const Spacer(),
            buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget buildAccountOption(IconData icon, String title, String value, Function(String) onEdit) {
    return Container(
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
              size: 24,
              color: Colors.black,
            ),
          ),
          Positioned(
            left: 60,
            top: 10,
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
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

  Widget buildDeleteButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Аккаунт удалён')),
        );
      },
      child: Container(
        width: 170,
        height: 59,
        decoration: BoxDecoration(
          color: const Color(0xFFFF0C0C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Удалить',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
