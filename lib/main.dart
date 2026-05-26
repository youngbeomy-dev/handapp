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

enum InputMode { none, sign, finger, gesture }

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  InputMode _selectedMode = InputMode.none;
  // [추가] 화면에 표시될 텍스트 변수
  String _displayText = "수화를 시작하세요";

  void _selectMode(InputMode mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  // [추가] 센서 값에 따라 텍스트를 업데이트하는 함수
  void _updateTranslation(List<int> leftFingers) {
    setState(() {
      if (leftFingers[1] == 50) {
        _displayText = "1";
      } else if (leftFingers[2] == 50) {
        _displayText = "2";
      } else {
        _displayText = "수화를 시작하세요";
      }
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
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    // [추가] 설정 페이지를 거쳐 센서 페이지로 함수 전달
                    onSensorChanged: _updateTranslation,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
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
              child: Center(
                child: Text(
                  _displayText, // [수정] 변수 적용
                  style: const TextStyle(
                    fontSize: 80, // 숫자가 잘 보이도록 크기 키움
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
            const Spacer(),
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
                  side: const BorderSide(color: Colors.indigo, width: 2),
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
          color: isSelected ? activeColor.withOpacity(0.15) : Colors.grey[200],
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
  }
}

class SettingsPage extends StatelessWidget {
  // [수정] 콜백 함수를 받도록 생성자 수정
  final Function(List<int>) onSensorChanged;
  const SettingsPage({super.key, required this.onSensorChanged});

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
          ListTile(
            leading: const Icon(Icons.touch_app, color: Colors.indigo),
            title: const Text('손가락 센서 값 확인',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            subtitle: const Text('SZH-SEN01 플렉스 센서 동작 테스트'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SensorTestPage(
                    // [추가] 센서 페이지로 콜백 전달
                    onSensorChanged: onSensorChanged,
                  ),
                ),
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

class SensorTestPage extends StatefulWidget {
  // [수정] 콜백 함수를 받도록 수정
  final Function(List<int>) onSensorChanged;
  const SensorTestPage({super.key, required this.onSensorChanged});

  @override
  State<SensorTestPage> createState() => _SensorTestPageState();
}

class _SensorTestPageState extends State<SensorTestPage> {
  List<int> leftFingers = [0, 0, 0, 0, 0];
  List<int> rightFingers = [0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('센서 구부림 상태 확인'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "장갑을 착용하고 손가락을 구부려보세요.\n(0: 펴짐 / 50: 중간 / 100: 굽힘)",
              style: TextStyle(color: Colors.grey, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: _buildHandDisplay("왼손", leftFingers)),
                const SizedBox(width: 15),
                Expanded(child: _buildHandDisplay("오른손", rightFingers)),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),

            // [수정] 왼손 검지 테스트 슬라이더 추가
            _buildManualSlider("왼손 검지 테스트", 1, (val) {
              setState(() {
                leftFingers[1] = val;
                widget.onSensorChanged(leftFingers); // 메인으로 값 전달
              });
            }, leftFingers[1]),

            // [수정] 왼손 중지 테스트 슬라이더 추가
            _buildManualSlider("왼손 중지 테스트", 2, (val) {
              setState(() {
                leftFingers[2] = val;
                widget.onSensorChanged(leftFingers); // 메인으로 값 전달
              });
            }, leftFingers[2]),
          ],
        ),
      ),
    );
  }

  Widget _buildHandDisplay(String label, List<int> values) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

    if (value >= 67) {
      height = 30.0;
      color = Colors.redAccent;
      text = "100";
    } else if (value >= 34) {
      height = 55.0;
      color = Colors.orangeAccent;
      text = "50";
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 12,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(height: 5),
        Text(text,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildManualSlider(
      String name, int index, Function(int) onChanged, int currentVal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child:
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Slider(
          value: currentVal.toDouble(),
          max: 100,
          divisions: 2,
          activeColor: Colors.indigo,
          onChanged: (v) => onChanged(v.toInt()),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

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
        child: Text("여기서 새로운 수화를 등록합니다", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}