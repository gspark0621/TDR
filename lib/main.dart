import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InputForm(),
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final List<TextEditingController> _controllers = List.generate(11, (index) => TextEditingController());
  final List<String> _inputValues = List.filled(11, '');

  final List<String> _hintTexts = [
    '나이',
    '성별',
    '여행 스타일 1',
    '여행 스타일 2',
    '여행 스타일 3',
    '여행 스타일 4',
    '여행 스타일 5',
    '여행 스타일 6',
    '여행 스타일 7',
    '여행 스타일 8',
    '여행경비'
  ];

  final List<String> _descriptions = [
    '나이를 입력해 주세요',
    '남/여로 입력해 주세요',
    '1~8사이 숫자를 입력해주세요 (1: 자연, 8: 도시)',
    '1~8사이 숫자를 입력해주세요 (1: 숙박, 8: 당일)',
    '1~8사이 숫자를 입력해주세요 (1: 새로운 지역, 8: 익숙한 지역)',
    '1~8사이 숫자를 입력해주세요 (1: 가심비 숙소, 8: 가성비 숙소)',
    '1~8사이 숫자를 입력해주세요 (1: 휴양/휴식, 8: 액티비티)',
    '1~8사이 숫자를 입력해주세요 (1: 유명하지 않은 관광지, 8: 유명한 관광지)',
    '1~8사이 숫자를 입력해주세요 (1: 계획에 따른 여행(MBTI: J), 8: 상황에 따른 여행(MBTI: T))',
    '1~8사이 숫자를 입력해주세요 (1: 사진촬영 중요 X, 8: 사진촬영 중요)',
    '여행경비를 입력해주세요'
  ];

  @override
  void _updateInputValue(int index) {
    setState(() {
      _inputValues[index] = _controllers[index].text;
    });
  }

  void _onConfirm() {
    for (int i = 0; i < _inputValues.length; i++) {
      _inputValues[i] = _controllers[i].text;
    }
    print('입력값: $_inputValues');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('입력칸 예제')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < _descriptions.length; i++)
                i < 2 || 9 < i ? _buildTextField(i) : _buildSlider(i),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _onConfirm,
                child: Text('확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(int index) {
    return Column(
      children: [
        Text(_descriptions[index]),
        Container(
          width: 300,
          child: TextField(
            controller: _controllers[index],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: _hintTexts[index],
            ),
            onChanged: (value) => _updateInputValue(index),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSlider(int index) {
    return Column(
      children: [
        Text(_descriptions[index]),
        Container(
          width: 300,
          child: Slider(
            value: (_inputValues[index].isEmpty ? 1 : int.parse(_inputValues[index])).toDouble(),
            min: 1,
            max: 8,
            divisions: 7,
            label: _inputValues[index],
            onChanged: (value) {
              setState(() {
                _inputValues[index] = value.toInt().toString();
              });
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
