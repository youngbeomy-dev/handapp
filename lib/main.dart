import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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

enum InputMode { none, sign, finger, gesture }
class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {  InputMode _selectedMode = InputMode.none;

void _selectMode(InputMode mode) {
  setState(() {
    _selectedMode = mode;
  });
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
          Row(
            children: [
              Expanded(
                child: _buildModeBox(
                  label: "수화",
                  mode: InputMode.sign,
                  activeColor: Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildModeBox(
                  label: "지화",
                  mode: InputMode.finger,
                  activeColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Spacer(),   // 이거 넣으면 버튼이 맨 아래로 감

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddGesturePage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("동작 추가"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                side: const BorderSide(
                  color: Colors.indigo,
                  width: 2,
                ),
                foregroundColor: Colors.indigo,
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
Widget _buildModeBox({
  required String label,
  required InputMode mode,
  required Color activeColor,
}) {
  final bool isSelected = _selectedMode == mode;

  return GestureDetector(
    onTap: () => _selectMode(mode),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 120,
      decoration: BoxDecoration(
        color:
        isSelected ? activeColor.withOpacity(0.15) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? activeColor : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: isSelected ? activeColor : Colors.black54,
          ),
        ),
      ),
    ),
  );
}}
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
          _buildDeviceStatus('오른손 장갑', false),
          _buildDeviceStatus('안경', false),

          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),

          // 새로운 메뉴: 센서 테스트 페이지로 이동
          ListTile(
            leading: const Icon(Icons.touch_app, color: Colors.indigo),
            title: const Text('손가락 센서 값 확인',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            subtitle: const Text('SZH-SEN01 플렉스 센서 동작 테스트'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SensorTestPage()),
              );
            },
          ),
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
// 여기서부터 동작설정창 코드, 동작 추가
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
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SensorTestPage extends StatefulWidget {
  const SensorTestPage({super.key});

  @override
  State<SensorTestPage> createState() => _SensorTestPageState();
}

class _SensorTestPageState extends State<SensorTestPage> {
  // 실제 센서 데이터를 저장할 리스트 (0: 엄지 ~ 4: 새끼)
  List<int> leftFingers = [0, 0, 0, 0, 0];
  List<int> rightFingers = [0, 0, 0, 0, 0];

  // 실제 연동 시 연결된 기기의 Characteristic을 담을 변수
  BluetoothCharacteristic? _targetCharacteristic;

  @override
  void initState() {
    super.initState();
    _startListeningToSensor();
  }

  // 블루투스 데이터를 수신하여 실시간으로 리스트를 업데이트하는 로직
  void _startListeningToSensor() {
    // _targetCharacteristic이 설정된 상태에서 데이터를 구독(Subscribe)합니다.
    _targetCharacteristic?.lastValueStream.listen((value) {
      if (value.isNotEmpty) {
        // 1. 바이트 데이터를 문자열로 변환 (UTF-8)
        String rawData = utf8.decode(value).trim();

        // 2. 쉼표로 분리 (예: "0,50,100,0,0")
        List<String> parsed = rawData.split(',');

        if (parsed.length == 5) {
          setState(() {
            // 3. 문자열 리스트를 정수형 리스트로 변환하여 저장
            rightFingers = parsed.map((v) => int.tryParse(v) ?? 0).toList();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('실시간 센서 연동 테스트'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "SZH-SEN01 센서 데이터 스트리밍 중...\n(장갑을 구부리면 화면의 막대가 즉시 반응합니다)",
              style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // 시각화 UI
            Row(
              children: [
                Expanded(child: _buildHandDisplay("왼손 장갑", leftFingers)),
                const SizedBox(width: 15),
                Expanded(child: _buildHandDisplay("오른손 장갑", rightFingers)),
              ],
            ),

            const SizedBox(height: 50),
            const Icon(Icons.bluetooth_connected, size: 40, color: Colors.blue),
            const Text("ESP-32 보드 연결 대기 중", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildHandDisplay(String label, List<int> values) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.indigo.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(5, (i) => _buildFingerBar(values[i])),
          ),
        ),
      ],
    );
  }

  Widget _buildFingerBar(int value) {
    double height = 80.0;
    Color color = Colors.greenAccent[700]!;
    String text = "0";

    // 0, 50, 100 3단계 판별 로직
    if (value >= 67) {
      height = 30.0; color = Colors.redAccent; text = "100";
    } else if (value >= 34) {
      height = 55.0; color = Colors.orangeAccent; text = "50";
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150), // 실시간성을 위해 애니메이션 시간 단축
          width: 12,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(height: 5),
        Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}