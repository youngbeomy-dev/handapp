import 'package:flutter/material.dart';

void main() {
  runApp(const SignLanguageApp());
}

class SignLanguageApp extends StatelessWidget {
  const SignLanguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '수화 번역 장갑',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TranslationPage(),
    );
  }
}

enum InputMode { none, sign, finger }

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  InputMode _selectedMode = InputMode.none;

  void _selectMode(InputMode mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  void _goToAddMotion() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMotionPage()),
    );
  }

  Widget _buildModeBox({
    required String label,
    required InputMode mode,
    required Color color,
  }) {
    final selected = _selectedMode == mode;

    return GestureDetector(
      onTap: () => _selectMode(mode),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: selected ? color : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("수화 번역 장갑"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigo.shade100),
                ),
                child: const Center(
                  child: Text(
                    "수화를 시작하세요",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: _buildModeBox(
                      label: "수화",
                      mode: InputMode.sign,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModeBox(
                      label: "지화",
                      mode: InputMode.finger,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 240),

            GestureDetector(
              onDoubleTap: _goToAddMotion,
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "+ 동작 추가",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddMotionPage extends StatelessWidget {
  const AddMotionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("동작 추가"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "여기서 새로운 수화를 등록합니다",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget deviceTile(String name) {
    return ListTile(
      leading: const Icon(Icons.bluetooth_disabled, color: Colors.grey),
      title: Text(name),
      trailing: const Text(
        "연결 안 됨",
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "장치 연결 상태",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          deviceTile("왼손 장갑"),
          deviceTile("오른손 장갑"),
          deviceTile("안경"),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.touch_app, color: Colors.indigo),
            title: const Text("손가락 센서 값 확인"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SensorTestPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SensorTestPage extends StatefulWidget {
  const SensorTestPage({super.key});

  @override
  State<SensorTestPage> createState() => _SensorTestPageState();
}

class _SensorTestPageState extends State<SensorTestPage> {
  List<int> leftRaw = [2870, 1540, 3300, 2100, 900];
  List<int> rightRaw = [3010, 1800, 2900, 1200, 400];

  final List<String> fingerNames = ["엄지", "검지", "중지", "약지", "소지"];

  int normalize(int raw) {
    return ((raw / 4095) * 100).round().clamp(0, 100);
  }

  Widget buildFingerBar(int raw) {
    final norm = normalize(raw);

    return Column(
      children: [
        Container(
          width: 20,
          height: norm.toDouble() + 25,
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(height: 5),

        Text(
          "$norm",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),

        Text(
          "$raw",
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildHand(String title, List<int> rawValues) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: rawValues.map(buildFingerBar).toList(),
        ),
      ],
    );
  }

  Widget buildDetailSection(String hand, List<int> rawValues) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$hand 상세 데이터",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            ...List.generate(5, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "${fingerNames[i]}   실제값: ${rawValues[i]} / 4095   |   보정값: ${normalize(rawValues[i])} / 100",
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("손가락 센서 값 확인"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildHand("왼손", leftRaw),
            const SizedBox(height: 35),

            buildHand("오른손", rightRaw),
            const SizedBox(height: 35),

            buildDetailSection("왼손", leftRaw),
            const SizedBox(height: 15),

            buildDetailSection("오른손", rightRaw),
          ],
        ),
      ),
    );
  }
}