import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

// 示例数据模型
class _VocabWord {
  final String chinese;
  final String pinyin;
  final String english;
  final String partOfSpeech;
  final List<_ExampleSentence> examples;
  final List<_RelatedWord> relatedWords;

  const _VocabWord({
    required this.chinese,
    required this.pinyin,
    required this.english,
    required this.partOfSpeech,
    required this.examples,
    required this.relatedWords,
  });
}

class _ExampleSentence {
  final String chinese;
  final String english;
  const _ExampleSentence(this.chinese, this.english);
}

class _RelatedWord {
  final String chinese;
  final String pinyin;
  final String english;
  const _RelatedWord(this.chinese, this.pinyin, this.english);
}

// 示例词汇数据
const _demoWords = [
  _VocabWord(
    chinese: '炒饭',
    pinyin: 'chǎo fàn',
    english: 'fried rice',
    partOfSpeech: 'noun',
    examples: [
      _ExampleSentence('一碗炒饭多少钱？', 'How much is a bowl of fried rice?'),
      _ExampleSentence('我要一份扬州炒饭。', 'I want a Yangzhou fried rice.'),
    ],
    relatedWords: [
      _RelatedWord('炒饭', 'chǎo fàn', 'fried rice'),
      _RelatedWord('稀饭', 'xī fàn', 'porridge'),
      _RelatedWord('饭', 'fàn', 'meal / cooked rice'),
    ],
  ),
  _VocabWord(
    chinese: '菜单',
    pinyin: 'cài dān',
    english: 'menu',
    partOfSpeech: 'noun',
    examples: [
      _ExampleSentence('请给我菜单。', 'Please give me the menu.'),
      _ExampleSentence('这个菜单有英文吗？', 'Is there an English menu?'),
    ],
    relatedWords: [
      _RelatedWord('菜单', 'cài dān', 'menu'),
      _RelatedWord('菜', 'cài', 'dish / vegetable'),
      _RelatedWord('点菜', 'diǎn cài', 'to order food'),
    ],
  ),
];

// 修复：改为 StatefulWidget，支持 toggle 状态和翻页
class VocabCardScreen extends StatefulWidget {
  const VocabCardScreen({super.key});

  @override
  State<VocabCardScreen> createState() => _VocabCardScreenState();
}

class _VocabCardScreenState extends State<VocabCardScreen> {
  int _currentIndex = 0;
  bool _showPhrases = false;
  bool _showRelated = true;

  _VocabWord get _currentWord => _demoWords[_currentIndex];
  int get _total => _demoWords.length;

  void _goNext() {
    if (_currentIndex < _total - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _goPrev() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.springWood14,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 38),
              _buildHeader(context),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildWordCard(),
                      const SizedBox(height: 24),
                      _buildToggleButtons(),
                      if (_showRelated) ...[
                        const SizedBox(height: 24),
                        _buildRelatedWords(),
                      ],
                      const SizedBox(height: 24),
                      _buildPracticeButton(context),
                      const SizedBox(height: 24),
                      _buildNavigationButtons(),
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/toolbox/vocab-learning'),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              border: Border.all(color: AppColors.morandiText, width: 2.389),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: AppColors.morandiText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              border: Border.all(color: AppColors.morandiText, width: 2.389),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.morandiText,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Text(
              'Vocab Learning',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.morandiText,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.morandiText,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${_currentIndex + 1}/$_total',
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

  Widget _buildWordCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          _buildWordHeader(),
          const SizedBox(height: 20),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildWordMeaning(),
          const SizedBox(height: 16),
          _buildDivider(),
          const SizedBox(height: 16),
          _buildExampleSection(),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.5,
      color: AppColors.morandiText.withValues(alpha: 0.15),
    );
  }

  Widget _buildWordHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentWord.chinese,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lavenderPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _currentWord.pinyin,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.morandiText,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.oldRose15,
            border: Border.all(color: AppColors.morandiText, width: 2),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Icon(
            Icons.person,
            size: 32,
            color: AppColors.morandiText,
          ),
        ),
      ],
    );
  }

  Widget _buildWordMeaning() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.baliHai30,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _currentWord.partOfSpeech,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _currentWord.english,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.morandiText,
          ),
        ),
      ],
    );
  }

  Widget _buildExampleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.baliHai30,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '例句',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'example sentences',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.morandiText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._currentWord.examples.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildExampleCard(e.chinese, e.english),
          ),
        ),
      ],
    );
  }

  Widget _buildExampleCard(String chinese, String english) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whisper15,
        border: Border.all(
          color: AppColors.shark40.withValues(alpha: 0.15),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chinese,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.morandiText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            english,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.shark40.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // 修复：改为 StatefulWidget 后，toggle 按钮现在可以真正切换状态
  Widget _buildToggleButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _showPhrases = !_showPhrases),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: _showPhrases ? AppColors.straw14 : AppColors.whisper15,
                border: Border.all(
                  color: _showPhrases
                      ? AppColors.morandiText
                      : AppColors.shark40.withValues(alpha: 0.2),
                  width: 2.389,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: _showPhrases
                    ? const [
                        BoxShadow(
                          color: AppColors.morandiText,
                          offset: Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  _showPhrases ? '短语 on' : '短语 off',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _showPhrases ? AppColors.morandiText : AppColors.shark40,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _showRelated = !_showRelated),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: _showRelated ? AppColors.baliHai30 : AppColors.whisper15,
                border: Border.all(
                  color: _showRelated
                      ? AppColors.morandiText
                      : AppColors.shark40.withValues(alpha: 0.2),
                  width: 2.389,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: _showRelated
                    ? const [
                        BoxShadow(
                          color: AppColors.morandiText,
                          offset: Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  _showRelated ? '关联词 on' : '关联词 off',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _showRelated ? AppColors.morandiText : AppColors.shark40,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedWords() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            '关联词',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
          const SizedBox(height: 16),
          ..._currentWord.relatedWords.map(
            (w) => _buildRelatedWordItem(w.chinese, w.pinyin, w.english),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedWordItem(String chinese, String pinyin, String english) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.whisper15,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                chinese,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.morandiText,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pinyin,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.morandiText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  english,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    // 修复：统一使用 withValues() 替代弃用的 withOpacity()
                    color: AppColors.shark40.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/toolbox/dialogue-practice'),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.straw14,
          border: Border.all(color: AppColors.morandiText, width: 2.5),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '开始对话练习 →',
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

  Widget _buildNavigationButtons() {
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == _total - 1;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isFirst ? null : _goPrev,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: isFirst ? AppColors.whisper15 : Colors.white,
                border: Border.all(
                  color: isFirst
                      ? AppColors.shark40.withValues(alpha: 0.2)
                      : AppColors.morandiText,
                  width: 2.389,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isFirst
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
                  '← Previous',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: isFirst
                        ? AppColors.shark40.withValues(alpha: 0.4)
                        : AppColors.morandiText,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: isLast ? null : _goNext,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: isLast ? AppColors.whisper15 : AppColors.baliHai30,
                border: Border.all(
                  color: isLast
                      ? AppColors.shark40.withValues(alpha: 0.2)
                      : AppColors.morandiText,
                  width: 2.389,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isLast
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
                  isLast ? 'Finished ✓' : 'Next →',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: isLast
                        ? AppColors.shark40.withValues(alpha: 0.4)
                        : AppColors.morandiText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
