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
      title: '수화 번역기',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        useMaterial3: true,
      ),
      home: const TranslationPage(),
    );
  }
}

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
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
            tooltip: '설정',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      // [해결 포인트] 아래 Padding 앞에 const가 있다면 반드시 지워야 합니다.
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. 번역 결과 출력 박스
            Container(
              width: double.infinity,
              // 화면 높이의 40%를 차지하게 설정 (이 부분 때문에 상단에 const가 있으면 안 됨)
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigo.shade100, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "수화를 시작하세요",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Spacer(), // 이거 넣으면 버튼이 맨 아래로 감

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddGesturePage()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("동작 추가"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: const TextStyle(fontSize: 18),
                  side: const BorderSide(
                    color: Colors.indigo, // 테두리 색
                    width: 2,             // 테두리 두께
                  ),
                  foregroundColor: Colors.indigo, // 글자 & 아이콘 색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
// ---------------------------------------------------------
// 여기서부터 설정창 코드
// ---------------------------------------------------------

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            '장치 연결 상태',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildDeviceStatus('왼손 장갑', false),
          _buildDeviceStatus('오른손 장갑',false),
          _buildDeviceStatus('안경', false),
        ],
      ),
    );
  }

  Widget _buildDeviceStatus(String deviceName, bool isConnected) {
    return ListTile(
      leading: Icon(
        isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
        color: isConnected ? Colors.blue : Colors.grey,
      ),
      title: Text(deviceName),
      trailing: Text(
        isConnected ? '연결됨' : '연결 안 됨',
        style: TextStyle(
          color: isConnected ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 여기서부터 동작설정창 코드
// ---------------------------------------------------------
class AddGesturePage extends StatelessWidget {
  const AddGesturePage({super.key});

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
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}