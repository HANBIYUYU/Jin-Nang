import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_safe_area.dart';

// ===================== 关卡数据模型 =====================

class _Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const _Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class _LevelData {
  final int levelId;
  final String title;
  final String subtitle;
  final List<_Question> questions;
  final int passThreshold; // 正确率百分比

  const _LevelData({
    required this.levelId,
    required this.title,
    required this.subtitle,
    required this.questions,
    this.passThreshold = 80,
  });
}

// ===================== 4关题目数据 =====================

const _level1Questions = [
  _Question(
    question: '"吃" 是什么意思？',
    options: ['to drink', 'to eat', 'to cook', 'to buy'],
    correctIndex: 1,
    explanation: '吃 (chī) = to eat',
  ),
  _Question(
    question: '"水" 是什么意思？',
    options: ['tea', 'water', 'rice', 'fruit'],
    correctIndex: 1,
    explanation: '水 (shuǐ) = water',
  ),
  _Question(
    question: '"饭店" 是什么意思？',
    options: ['hotel', 'restaurant', 'supermarket', 'kitchen'],
    correctIndex: 1,
    explanation: '饭店 (fàndiàn) = restaurant',
  ),
  _Question(
    question: '"米饭" 是什么意思？',
    options: ['noodles', 'bread', 'cooked rice', 'soup'],
    correctIndex: 2,
    explanation: '米饭 (mǐfàn) = cooked rice',
  ),
  _Question(
    question: '"多少钱" 是什么意思？',
    options: ['how many', 'how much', 'what time', 'where'],
    correctIndex: 1,
    explanation: '多少钱 (duōshao qián) = how much (money)',
  ),
];

const _level2Questions = [
  _Question(
    question: '听音选择："hē"',
    options: ['吃', '喝', '水', '茶'],
    correctIndex: 1,
    explanation: '喝 (hē) = to drink',
  ),
  _Question(
    question: '听音选择："chá"',
    options: ['茶', '菜', '吃', '查'],
    correctIndex: 0,
    explanation: '茶 (chá) = tea',
  ),
  _Question(
    question: '听音选择："mǎi"',
    options: ['卖', '买', '麦', '埋'],
    correctIndex: 1,
    explanation: '买 (mǎi) = to buy',
  ),
  _Question(
    question: '听音选择："piányi"',
    options: ['便宜', '片一', '偏宜', '便宜'],
    correctIndex: 0,
    explanation: '便宜 (piányi) = cheap',
  ),
];

const _level3Questions = [
  _Question(
    question: '服务员：您好，您想____什么？\n顾客：我____一碗米饭。',
    options: ['吃/要', '喝/买', '看/请', '说/想'],
    correctIndex: 0,
    explanation: '正确答案是 "吃/要"',
  ),
  _Question(
    question: '请给我一____水。',
    options: ['个', '杯', '张', '本'],
    correctIndex: 1,
    explanation: '一杯水 (yì bēi shuǐ) = a glass of water',
  ),
  _Question(
    question: '这个菜很____，但是很好吃。',
    options: ['便宜', '贵', '大', '小'],
    correctIndex: 1,
    explanation: '贵 (guì) = expensive',
  ),
];

const _level4Questions = [
  _Question(
    question: '将以下句子按点餐流程排序：\na. 请给我菜单。\nb. 我要一份米饭和鱼。\nc. 谢谢，再见。\nd. 请结账。\ne. 您好，请坐。',
    options: ['e→a→b→d→c', 'a→e→b→c→d', 'e→b→a→d→c', 'a→b→e→d→c'],
    correctIndex: 0,
    explanation: '正确顺序：您好请坐 → 给菜单 → 点菜 → 结账 → 再见',
  ),
];

final _allLevels = [
  _LevelData(
    levelId: 1,
    title: 'Level 1: Vocab Match',
    subtitle: 'Match Chinese words to their meanings',
    questions: _level1Questions,
  ),
  _LevelData(
    levelId: 2,
    title: 'Level 2: Listen & Choose',
    subtitle: 'Listen and select the correct word',
    questions: _level2Questions,
  ),
  _LevelData(
    levelId: 3,
    title: 'Level 3: Fill in Blanks',
    subtitle: 'Complete the dialogue',
    questions: _level3Questions,
  ),
  _LevelData(
    levelId: 4,
    title: 'Challenge: Scenario Sort',
    subtitle: 'Arrange sentences in correct order',
    questions: _level4Questions,
    passThreshold: 100,
  ),
];

// ===================== LevelScreen =====================

class LevelScreen extends StatefulWidget {
  final int levelId;
  const LevelScreen({super.key, required this.levelId});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  late final _LevelData _level;
  int _currentQIndex = 0;
  int? _selectedOption;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  int _correctCount = 0;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _level = _allLevels.firstWhere((l) => l.levelId == widget.levelId);
  }

  _Question get _currentQ => _level.questions[_currentQIndex];
  int get _totalQ => _level.questions.length;
  bool get _isLastQ => _currentQIndex == _totalQ - 1;

  void _selectOption(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedOption = index;
      _hasAnswered = true;
      _isCorrect = index == _currentQ.correctIndex;
      if (_isCorrect) _correctCount++;
    });
  }

  void _nextQuestion() {
    if (_isLastQ) {
      setState(() => _showResult = true);
    } else {
      setState(() {
        _currentQIndex++;
        _selectedOption = null;
        _hasAnswered = false;
        _isCorrect = false;
      });
    }
  }

  double get _accuracy => (_correctCount / _totalQ) * 100;
  bool get _passed => _accuracy >= _level.passThreshold;

  void _retry() {
    setState(() {
      _currentQIndex = 0;
      _selectedOption = null;
      _hasAnswered = false;
      _isCorrect = false;
      _correctCount = 0;
      _showResult = false;
    });
  }

  void _goBack() => context.go('/study/dialogue-practice');

  @override
  Widget build(BuildContext context) {
    if (_showResult) return _buildResultView();
    return _buildQuestionView();
  }

  // ===================== 答题视图 =====================

  Widget _buildQuestionView() {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 48),
              _buildTopBar(),
              const SizedBox(height: 24),
              _buildProgressBar(),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildQuestionCard(),
                      const SizedBox(height: 24),
                      ...List.generate(_currentQ.options.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildOptionButton(i),
                        );
                      }),
                      if (_hasAnswered) ...[
                        const SizedBox(height: 16),
                        _buildFeedbackCard(),
                      ],
                      const SizedBox(height: 24),
                      if (_hasAnswered) _buildNextButton(),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: _goBack,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.morandiText, width: 2.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.morandiText,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.morandiText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _level.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.morandiText,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${_currentQIndex + 1}/$_totalQ',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentQIndex + (_hasAnswered ? 1 : 0)) / _totalQ;
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.whisper15,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.morandiText.withValues(alpha: 0.1)),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.baliHai30,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 2.389),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.morandiText,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Question ${_currentQIndex + 1}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.morandiText,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentQ.question,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(int index) {
    Color bgColor = Colors.white;
    Color borderColor = AppColors.morandiText;
    Color textColor = AppColors.morandiText;

    if (_hasAnswered) {
      if (index == _currentQ.correctIndex) {
        bgColor = AppColors.semanticGreen.withValues(alpha: 0.15);
        borderColor = AppColors.semanticGreen;
        textColor = AppColors.semanticGreen;
      } else if (index == _selectedOption) {
        bgColor = AppColors.semanticRed.withValues(alpha: 0.15);
        borderColor = AppColors.semanticRed;
        textColor = AppColors.semanticRed;
      } else {
        bgColor = AppColors.whisper15;
        borderColor = AppColors.shark40.withValues(alpha: 0.15);
        textColor = AppColors.shark40.withValues(alpha: 0.4);
      }
    }

    return GestureDetector(
      onTap: () => _selectOption(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(14),
          boxShadow: !_hasAnswered || index == _selectedOption || index == _currentQ.correctIndex
              ? const [
                  BoxShadow(
                    color: AppColors.morandiText,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _hasAnswered && index == _currentQ.correctIndex
                    ? AppColors.semanticGreen
                    : _hasAnswered && index == _selectedOption
                        ? AppColors.semanticRed
                        : AppColors.whisper15,
                border: Border.all(
                  color: _hasAnswered && (index == _currentQ.correctIndex || index == _selectedOption)
                      ? Colors.transparent
                      : AppColors.morandiText,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _hasAnswered && (index == _currentQ.correctIndex || index == _selectedOption)
                        ? Colors.white
                        : AppColors.morandiText,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _currentQ.options[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
            if (_hasAnswered && index == _currentQ.correctIndex)
              const Icon(Icons.check_circle, color: AppColors.semanticGreen, size: 22)
            else if (_hasAnswered && index == _selectedOption && !_isCorrect)
              const Icon(Icons.cancel, color: AppColors.semanticRed, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect
            ? AppColors.semanticGreen.withValues(alpha: 0.1)
            : AppColors.semanticRed.withValues(alpha: 0.1),
        border: Border.all(
          color: _isCorrect ? AppColors.semanticGreen : AppColors.semanticRed,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle : Icons.cancel,
                color: _isCorrect ? AppColors.semanticGreen : AppColors.semanticRed,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _isCorrect ? 'Correct!' : 'Not quite...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: _isCorrect ? AppColors.semanticGreen : AppColors.semanticRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _currentQ.explanation,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.morandiText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextQuestion,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.baliHai30,
          border: Border.all(color: AppColors.morandiText, width: 2.5),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            _isLastQ ? 'See Results' : 'Next Question →',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
        ),
      ),
    );
  }

  // ===================== 结果视图 =====================

  Widget _buildResultView() {
    final starCount = _passed ? min(3, (_accuracy / 33).ceil()) : 0;

    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              const Spacer(),
              _buildResultIcon(),
              const SizedBox(height: 24),
              Text(
                _passed ? 'Level Complete!' : 'Try Again!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Score: $_correctCount/$_totalQ (${_accuracy.toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.morandiText.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      i < starCount ? Icons.star : Icons.star_border,
                      size: 36,
                      color: i < starCount ? AppColors.straw14 : AppColors.mercury25,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              if (!_passed)
                Text(
                  'Need ${_level.passThreshold}% to pass',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.semanticRed.withValues(alpha: 0.8),
                  ),
                ),
              const Spacer(),
              if (!_passed)
                _buildRetryButton()
              else ...[
                _buildContinueButton(),
                const SizedBox(height: 12),
                _buildRetryButton(isSecondary: true),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: _passed ? AppColors.semanticGreen.withValues(alpha: 0.15) : AppColors.semanticRed.withValues(alpha: 0.15),
        border: Border.all(
          color: _passed ? AppColors.semanticGreen : AppColors.semanticRed,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Icon(
          _passed ? Icons.emoji_events : Icons.refresh,
          size: 48,
          color: _passed ? AppColors.semanticGreen : AppColors.semanticRed,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: _goBack,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.baliHai30,
          border: Border.all(color: AppColors.morandiText, width: 2.5),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Continue →',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetryButton({bool isSecondary = false}) {
    return GestureDetector(
      onTap: _retry,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isSecondary ? AppColors.whisper15 : Colors.white,
          border: Border.all(
            color: isSecondary
                ? AppColors.shark40.withValues(alpha: 0.2)
                : AppColors.morandiText,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSecondary
              ? null
              : const [
                  BoxShadow(
                    color: AppColors.morandiText,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            'Retry Level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: isSecondary
                  ? AppColors.shark40.withValues(alpha: 0.6)
                  : AppColors.morandiText,
            ),
          ),
        ),
      ),
    );
  }
}
