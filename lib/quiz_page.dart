import 'package:flutter/material.dart';
import 'waste_info.dart'; // 데이터 클래스를 import
import 'home_page.dart'; // HomePage로 돌아가기 위한 import

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _questionIndex = 0;
  bool _answered = false;
  bool _isCorrect = false;
  String _explanation = '';
  int _score = 0;
  bool _quizCompleted = false;

  List<Map<String, Object>> _questions = [
    {
      'question': '음식물 쓰레기가 매립지에서 분해될 때 발생하는 메탄가스는 이산화탄소보다 온실효과를 더 많이 일으킨다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '메탄가스는 이산화탄소보다 약 25배 더 강력한 온실가스로, 음식물 쓰레기를 줄이면 지구온난화 속도를 늦출 수 있습니다.',
    },
    {
      'question': '모든 플라스틱 쓰레기는 재활용이 가능하다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '일부 플라스틱은 재활용이 어렵거나 불가능하므로, 올바르게 분리 배출하는 것이 중요합니다.',
    },
    {
      'question': '재활용이 잘 이루어지지 않으면, 그만큼 탄소 배출량이 증가할 가능성이 높다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '재활용이 부족하면 쓰레기 처리 시 더 많은 에너지가 소모되고 탄소가 배출됩니다.',
    },
    {
      'question': '비닐봉투는 재활용이 가능하지만, 음식물이나 이물질이 묻으면 재활용이 어렵다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '깨끗한 상태로 분리 배출해야 재활용할 수 있으므로 음식물은 제거하고 배출해야 합니다.',
    },
    {
      'question': '플라스틱 제품은 썩는 데 수십 년에서 수백 년이 걸린다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '플라스틱은 자연 분해가 거의 되지 않아 환경에 장기적인 부담을 줍니다.',
    },
    {
      'question': '알루미늄 캔을 재활용하지 않고 버리면 매립지에서 분해되는데 수십 년이 걸릴 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '알루미늄은 재활용이 용이하고, 에너지를 절약할 수 있어 적극적으로 재활용해야 합니다.',
    },
    {
      'question': '음식물 쓰레기를 줄이면 매립지에서 발생하는 메탄가스를 줄일 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '음식물 쓰레기 줄이기는 메탄가스 배출을 감소시키는 효과적인 방법입니다.',
    },
    {
      'question': '생수병을 재활용하지 않고 버릴 경우 탄소 배출이 증가할 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '재활용할 수 있는 자원을 버리면 새로운 자원 생산 시 더 많은 에너지가 필요해 탄소 배출이 증가합니다.',
    },
    {
      'question': '전자제품을 버릴 때도 탄소 배출량에 영향을 미칠 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '전자제품 폐기 시 유해물질과 탄소가 발생할 수 있어, 분리 배출이 필수입니다.',
    },
    {
      'question': '쓰레기를 매립할 때는 아무런 온실가스가 발생하지 않는다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '매립된 쓰레기에서 메탄 등 온실가스가 발생하며, 이를 줄이기 위해 쓰레기 감량이 중요합니다.',
    },
    {
      'question': '쓰레기를 줄이는 것은 탄소 배출을 줄이는 것과 직접적인 관련이 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '쓰레기가 줄어들면 처리 과정에 사용되는 에너지가 줄어 탄소 배출량도 감소합니다.',
    },
    {
      'question': '유리병은 재활용해도 탄소 배출량에 큰 차이가 없다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '유리병을 재활용하면 새로운 유리를 만들 때보다 에너지가 적게 들고, 탄소 배출도 줄어듭니다.',
    },
    {
      'question': '전기차는 배터리 생산과 폐기 과정에서 오히려 탄소 발자국을 늘릴 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '전기차는 운행 중 탄소 배출이 적지만, 배터리 제조와 폐기 과정에서 환경 부담이 생길 수 있습니다.',
    },
    {
      'question': '재활용품을 제대로 분리하지 않으면 전체 재활용 품목이 오염되어 재활용률이 크게 떨어질 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '오염된 재활용품은 전체 재활용 공정을 방해하므로, 정확한 분리 배출이 중요합니다.',
    },
    {
      'question': '종이컵보다 텀블러를 사용하는 것이 탄소 배출량을 줄이는 데 더 효과적이다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '텀블러는 반복 사용이 가능해 종이컵보다 환경에 미치는 영향이 적습니다.',
    },
    {
      'question': '플라스틱 병은 재활용이 가능하다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '깨끗하게 분리 배출하면 플라스틱 병은 재활용이 가능하며, 자원 절약에 기여할 수 있습니다.',
    },
    {
      'question': '음식물 쓰레기는 일반 쓰레기와 함께 버려도 된다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '음식물 쓰레기는 따로 배출해야 제대로 처리할 수 있으며, 환경 오염을 막을 수 있습니다.',
    },
    {
      'question': '종이는 자연에서 쉽게 분해된다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '종이는 생분해성이 높아 쉽게 분해되지만, 재활용하면 더 효과적으로 자원을 절약할 수 있습니다.',
    },
    {
      'question': '비닐봉투는 자연에서 500년 이상 걸려야 분해된다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '비닐봉투는 자연에서 거의 분해되지 않으므로, 재사용 가방을 사용해 비닐 사용을 줄이는 것이 좋습니다.',
    },
    {
      'question': '다 쓴 배터리는 일반 쓰레기로 버려야 한다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '배터리는 유해물질이 포함되어 있어 분리 배출해야 환경 오염을 줄일 수 있습니다.',
    },
    {
      'question': '쓰레기 매립 시 발생하는 메탄가스는 지구온난화에 영향을 준다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '메탄가스는 강력한 온실가스로, 매립 쓰레기에서 발생해 기후 변화에 영향을 미칩니다.',
    },
    {
      'question': '일회용품 사용을 줄이는 것은 쓰레기를 줄이는 방법 중 하나이다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '일회용품 사용을 줄이면 쓰레기 발생이 줄어 환경 보호에 도움이 됩니다.',
    },
    {
      'question': '해양 생태계에 미치는 플라스틱 쓰레기의 영향은 미미하다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '플라스틱 쓰레기는 해양 생물에게 심각한 위협을 주며, 먹이사슬에까지 영향을 미칠 수 있습니다.',
    },
    {
      'question': '모든 종류의 유리병은 재활용이 가능하다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '유리병은 재활용이 가능하므로 깨끗하게 배출해 자원 절약에 기여할 수 있습니다.',
    },
    {
      'question': '종이컵은 플라스틱 코팅이 되어 있어 재활용이 어려울 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '종이컵의 플라스틱 코팅은 재활용을 어렵게 하므로, 텀블러 사용이 권장됩니다.',
    },
    {
      'question': '음식물 쓰레기에서 발생하는 침출수는 토양 오염의 원인이 될 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '침출수는 토양과 지하수를 오염시키므로, 음식물 쓰레기는 적절히 처리해야 합니다.',
    },
    {
      'question': '컴퓨터나 스마트폰 같은 전자제품은 자원을 절약하기 위해 업사이클링이 가능하다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '전자제품을 업사이클링하면 자원을 절약하고 전자폐기물을 줄이는 효과가 있습니다.',
    },
    {
      'question': '배터리와 같은 유해 폐기물은 분리배출 하지 않아도 안전하다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '배터리에는 환경에 해로운 중금속이 포함되어 있어, 반드시 분리 배출해야 안전하게 처리할 수 있습니다.',
    },
    {
      'question': '산업 폐기물은 일반 가정 쓰레기보다 환경에 더 큰 영향을 미칠 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '산업 폐기물은 유해물질을 포함한 경우가 많아, 관리하지 않으면 심각한 환경 오염을 초래할 수 있습니다.',
    },
    {
      'question': '재생에너지가 아닌 화석연료를 사용하는 것은 지속 가능한 에너지 개발에 부정적인 영향을 미친다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '화석연료는 많은 탄소를 배출하므로, 재생에너지를 사용하는 것이 환경에 더 긍정적입니다.',
    },
    {
      'question': '물티슈는 대부분 플라스틱 섬유로 만들어져 하수 처리 과정에서 완전히 분해되지 않는다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '물티슈는 플라스틱 성분이 있어 자연 분해가 어렵기 때문에 분리 배출이 필요합니다.',
    },
    {
      'question': '종이팩은 100% 천연펄프를 사용해 고급화장지로 재활용이 가능하다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '종이팩은 천연펄프가 포함되어 있어 고급 화장지로 재활용할 수 있습니다.',
    },
    {
      'question': '폐건전지는 철·아연·니켈 등 유용한 금속자원을 회수해 재활용할 수 있으며, 수은 등 유해 중금속으로 인한 환경오염도 예방할 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '폐건전지에서 유용한 금속을 회수할 수 있고, 재활용하면 유해물질로 인한 오염을 막을 수 있습니다.',
    },
    {
      'question': '건조한 종이와 기름에 오염된 종이는 동일한 방법으로 재활용될 수 있다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '기름에 오염된 종이는 재활용이 어려우므로, 일반 쓰레기로 배출해야 합니다.',
    },
    {
      'question': '옷걸이와 같은 플라스틱 제품은 모양이 복잡해 일반적인 플라스틱 재활용 과정에서 재활용이 어렵다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '복잡한 모양의 플라스틱은 분리 및 재활용이 어려워, 환경 부담을 줄이려면 대체 소재를 사용하는 것이 좋습니다.',
    },
    {
      'question': '음식물 쓰레기를 일반 쓰레기와 분리 배출하는 것이 환경 보호에 도움이 된다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '음식물 쓰레기는 분리 배출하여 처리하면 매립지에서 메탄가스 발생을 줄일 수 있습니다.',
    },
    {
      'question': '환경을 보호하기 위해서는 플라스틱 사용을 줄이는 것보다 무조건 종이 제품을 사용하는 것이 더 좋다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '종이도 제조 과정에서 많은 에너지를 사용하므로, 불필요한 소비를 줄이는 것이 최선입니다.',
    },
    {
      'question': 'LED 전구는 일반 전구에 비해 에너지를 절약하고 수명이 더 길다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': 'LED 전구는 전력 소비가 적고 수명이 길어 에너지 절약에 효과적입니다.',
    },
    {
      'question': '유리병은 깨져도 재활용이 가능하다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'O',
      'explanation': '깨진 유리병도 재활용할 수 있지만, 안전하게 배출해 다치지 않도록 주의해야 합니다.',
    },
    {
      'question': '사용하지 않는 전자기기를 코드에 꽂아두면 전력이 소비되지 않는다.',
      'answers': ['O', 'X'],
      'correctAnswer': 'X',
      'explanation': '플러그가 연결된 전자기기는 소량의 전력이 계속 소비됩니다.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _questions.shuffle();
    _questions = _questions.sublist(0, 10);
  }

  void _checkAnswer(String answer) {
    setState(() {
      _answered = true;
      String correctAnswer = _questions[_questionIndex]['correctAnswer'] as String;
      _isCorrect = answer == correctAnswer;
      _explanation = _questions[_questionIndex]['explanation'] as String;

      if (_isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_questionIndex + 1 < _questions.length) {
        _questionIndex++;
        _answered = false;
        _isCorrect = false;
        _explanation = '';
      } else {
        _quizCompleted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('환경 퀴즈'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _quizCompleted
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '퀴즈 완료!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '총 점수: $_score/10',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _questionIndex = 0;
                        _score = 0;
                        _quizCompleted = false;
                        _answered = false;
                        _questions.shuffle();
                        _questions = _questions.sublist(0, 10);
                      });
                    },
                    child: Text('다시 시작'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: Text('돌아가기'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
            : (_answered
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isCorrect ? 'O' : 'X',
              style: TextStyle(
                fontSize: 100,
                color: _isCorrect ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _isCorrect ? '정답입니다!' : '오답입니다.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isCorrect ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _explanation,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: Text('다음 질문'),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '문제 ${_questionIndex + 1}/${_questions.length}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _questions[_questionIndex]['question'] as String,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer('O'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // 모서리를 각지게 설정
                      ),
                    ),
                    child: Text(
                      'O',
                      style: TextStyle(fontSize: 48, color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer('X'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      backgroundColor: Colors.grey[200], // 버튼 배경 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // 모서리를 각지게 설정
                      ),
                    ),
                    child: Text(
                      'X',
                      style: TextStyle(fontSize: 48, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
