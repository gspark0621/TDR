import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(FirstPage());
}

class FirstPage extends StatelessWidget {
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
  @override
  void initState() {
    super.initState();
    // 초기값 설정
    for (int i = 0; i < _inputValues.length; i++) {
      _inputValues[i] = (i == 0|| i==1 || i == 10) ? '' : '1'; // 나이, 성별과 여행경비 제외하고 기본값을 1로 설정
    }
  }
  final List<String> _hintTexts = [
    '나이',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '여행경비'
  ];

  final List<String> _descriptions = [
    '나이를 입력해 주세요',
    '남/여로 입력해 주세요',
    '선호하는 여행 유형을 선택해주세요\n             (1: 자연 ~ 8: 도시)',
    '선호하는 여행 유형을 선택해주세요\n             (1: 숙박 ~ 8: 당일)',
    '선호하는 여행 유형을 선택해주세요\n (1: 새로운 지역 ~ 8: 익숙한 지역)',
    '선호하는 여행 유형을 선택해주세요\n  (1: 가심비 숙소 ~ 8: 가성비 숙소)',
    '선호하는 여행 유형을 선택해주세요\n     (1: 휴양/휴식 ~ 8: 액티비티)',
    '        선호하는 여행 유형을 선택해주세요\n(1: 유명하지 않은 관광지 ~ 8: 유명한 관광지)',
    '       선호하는 여행 유형을 선택해주세요\n (1: 계획에 따른 여행 ~ 8: 상황에 따른 여행)',
    '       선호하는 여행 유형을 선택해주세요\n    (1: 사진촬영 중요 X ~ 8: 사진촬영 중요)',
    '여행경비를 선택해주세요(ex.35만원 → 350000)'
  ];

  @override
  void _updateInputValue(int index) {
    setState(() {
      _inputValues[index] = _controllers[index].text;
    });
  }

  void _onConfirm() async {
    for (int i = 0; i < _inputValues.length; i++) {
      _inputValues[i] = _controllers[i].text.isNotEmpty ? _controllers[i].text : _inputValues[i];
    }

    // API 호출
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/recommend'), // 서버 주소와 포트
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'age': _inputValues[0],
        'gender': _inputValues[1],
        'travel_styles': _inputValues.sublist(2, 10), // 여행 스타일 1~8
        'budget': _inputValues[10],
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받음
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('추천 결과: $responseData');
    } else {
      // 오류 처리
      print('추천 요청 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: Size(100, 50),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.deepPurple,
              width: 1,
              style: BorderStyle.solid
          ),
          borderRadius: BorderRadius.circular(25)
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('여행지 추천 시스템')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < _descriptions.length; i++)
                if (i == 1)
                  _buildRadio(i)
                else if (i < 1 || 9 < i)
                  _buildTextField(i)
                else
                  _buildSlider(i),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onConfirm,
                child: Text('확인'),
                style: style,
              ),
              SizedBox(height: 30),
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
              hintStyle: TextStyle(
                color: Colors.grey,
              )
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
            value: _inputValues[index].isEmpty ? 1.0 : double.tryParse(_inputValues[index])?.toDouble() ?? 1.0,
            min: 1,
            max: 7,
            divisions: 6,
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

  Widget _buildRadio(int index) {
    return Column(
      children: [
        Text(_descriptions[index]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _inputValues[index] = "Man"; // "남" 버튼 선택 시
                });
              },
              child: Text('남'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _inputValues[index] == "Man" ? Colors.deepPurple.shade100 : Colors.grey.shade200,
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _inputValues[index] = "Woman"; // "여" 버튼 선택 시
                });
              },
              child: Text('여'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _inputValues[index] == "Woman" ? Colors.deepPurple.shade100 : Colors.grey.shade200,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
