import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

// ===================== 数据模型 =====================

class _Example {
  final String chinese;
  final String pinyin;
  final String english;
  const _Example(this.chinese, this.pinyin, this.english);
}

class _RelatedWord {
  final String type; // synonym | antonym | expand
  final String chinese;
  final String pinyin;
  final String english;
  const _RelatedWord(this.type, this.chinese, this.pinyin, this.english);
}

class _Phrase {
  final String chinese;
  final String english;
  const _Phrase(this.chinese, this.english);
}

class _VocabWord {
  final String chinese;
  final String pinyin;
  final String partOfSpeech;
  final String englishMeaning;
  final String chineseMeaning;
  final String chineseMeaningPinyin;
  final List<_Example> examples;
  final List<_RelatedWord> relatedWords;
  final List<_Phrase> phrases;
  final String audioAsset;

  const _VocabWord({
    required this.chinese,
    required this.pinyin,
    required this.partOfSpeech,
    required this.englishMeaning,
    required this.chineseMeaning,
    required this.chineseMeaningPinyin,
    required this.examples,
    required this.relatedWords,
    required this.phrases,
    required this.audioAsset,
  });
}

// ===================== 示例数据 =====================

const _demoWords = [
  _VocabWord(
    chinese: '米饭',
    pinyin: 'mǐ fàn',
    partOfSpeech: 'n.',
    englishMeaning: 'rice',
    chineseMeaning: '多指用大米煮或蒸成的饭。',
    chineseMeaningPinyin: 'duō zhǐ yòng dà mǐ zhǔ huò zhēng chéng de fàn.',
    examples: [
      _Example('我喜欢吃米饭。', 'wǒ xǐ huān chī mǐ fàn.', 'I like eating rice.'),
      _Example('我要吃米饭。', 'wǒ yào chī mǐ fàn.', 'I want to eat rice.'),
    ],
    relatedWords: [
      _RelatedWord('synonym', '炒饭', 'chǎo fàn', 'fried rice'),
      _RelatedWord('synonym', '稀饭', 'xī fàn', 'gruel'),
      _RelatedWord('synonym', '饭', 'fàn', 'meal'),
    ],
    phrases: [
      _Phrase('一碗米饭', 'a bowl of rice'),
      _Phrase('白米饭', '(cooked) rice'),
      _Phrase('盛饭', 'a bowl with rice'),
      _Phrase('蛋炒饭', 'fried rice with egg'),
      _Phrase('盖浇饭', 'rice served with meat and vegetables on top'),
    ],
    audioAsset: 'assets/audio/rice.mp3',
  ),
  _VocabWord(
    chinese: '饭店',
    pinyin: 'fàn diàn',
    partOfSpeech: 'n.',
    englishMeaning: 'restaurant',
    chineseMeaning: '指为顾客提供饭菜和服务的场所。',
    chineseMeaningPinyin: 'zhǐ wèi gù kè tí gōng fàn cài hé fú wù de chǎng suǒ.',
    examples: [
      _Example('我家附近有一家饭店。', 'wǒ jiā fù jìn yǒu yī jiā fàn diàn.', 'There is a restaurant near my home.'),
      _Example('我们去饭店吃饭吧。', 'wǒ men qù fàn diàn chī fàn ba.', 'Let\'s go to a restaurant to eat.'),
    ],
    relatedWords: [
      _RelatedWord('synonym', '餐馆', 'cān guǎn', 'restaurant'),
      _RelatedWord('synonym', '酒楼', 'jiǔ lóu', 'wine restaurant / tavern'),
      _RelatedWord('synonym', '饭馆', 'fàn guǎn', 'diner / eating house'),
      _RelatedWord('expand', '菜单', 'cài dān', 'menu'),
      _RelatedWord('expand', '厨师', 'chú shī', 'chef / cook'),
      _RelatedWord('expand', '订座', 'dìng zuò', 'reservation / book a table'),
    ],
    phrases: [
      _Phrase('中餐厅', 'Chinese restaurant'),
      _Phrase('快餐店', 'fast food restaurant'),
      _Phrase('饭店服务员', 'restaurant waiter / waitress'),
    ],
    audioAsset: 'assets/audio/restaurant.mp3',
  ),
];

// ===================== 页面 =====================

class ToolboxCard extends StatefulWidget {
  const ToolboxCard({super.key});

  @override
  State<ToolboxCard> createState() => _ToolboxCardState();
}

class _ToolboxCardState extends State<ToolboxCard> {
  int _currentIndex = 0;
  bool _showRelated = true; // true = 关联词, false = 短语
  final AudioPlayer _player = AudioPlayer();

  _VocabWord get _word => _demoWords[_currentIndex];
  int get _total => _demoWords.length;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    try {
      await _player.stop();
      await _player.play(AssetSource(_word.audioAsset.replaceFirst('assets/', '')));
    } catch (e) {
      debugPrint('[Audio] Error: $e');
    }
  }

  void _goNext() {
    if (_currentIndex < _total - 1) {
      setState(() => _currentIndex++);
    } else {
      context.go('/toolbox');
    }
  }

  void _goPrev() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildMainCard(),
                      const SizedBox(height: 20),
                      _buildToggleButtons(),
                      const SizedBox(height: 20),
                      _showRelated ? _buildRelatedSection() : _buildPhraseSection(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _buildNavigationButtons(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/toolbox'),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.morandiText, width: 2.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.morandiText),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              border: Border.all(color: AppColors.morandiText, width: 2.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
              ],
            ),
            child: const Center(
              child: Text(
                'Vocab Battle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.morandiText, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${_currentIndex + 1}/$_total',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.morandiText),
          ),
        ),
      ],
    );
  }

  // ---------- 主卡片 ----------

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 2.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 汉字 + 拼音 + 音量
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _word.chinese,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.morandiText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _word.pinyin,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.lavenderPurple.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _playAudio,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.baliHai30,
                    border: Border.all(color: AppColors.morandiText, width: 2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.volume_up, size: 24, color: AppColors.morandiText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDashedDivider(),
          const SizedBox(height: 16),
          // 词性
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.morandiText,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_word.partOfSpeech} ${_word.englishMeaning}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          // 英文释义
          Text(
            _word.englishMeaning == 'rice'
                ? 'It usually refers to the rice cooked or steamed into a meal.'
                : 'A place where meals are prepared and served to customers.',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.morandiText, height: 1.5),
          ),
          const SizedBox(height: 8),
          // 中文释义
          Text(
            _word.chineseMeaning,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.morandiText),
          ),
          const SizedBox(height: 2),
          Text(
            _word.chineseMeaningPinyin,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lavenderPurple.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 16),
          _buildDashedDivider(),
          const SizedBox(height: 16),
          // 例句
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.oldRose15,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'LiJu',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.morandiText),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '例句 example sentence',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.morandiText),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._word.examples.map((e) => _buildExampleCard(e)),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / 12).floor();
        return Row(
          children: List.generate(dashCount * 2 - 1, (i) {
            if (i.isOdd) return const SizedBox(width: 4);
            return Expanded(child: Container(height: 1, color: AppColors.morandiText.withValues(alpha: 0.15)));
          }),
        );
      },
    );
  }

  Widget _buildExampleCard(_Example e) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whisper15,
        border: Border.all(color: AppColors.shark40.withValues(alpha: 0.15), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(e.chinese, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.morandiText)),
          const SizedBox(height: 4),
          Text(e.pinyin, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lavenderPurple.withValues(alpha: 0.7))),
          const SizedBox(height: 4),
          Text(e.english, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.shark40.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  // ---------- Toggle ----------

  Widget _buildToggleButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _showRelated = true),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: _showRelated ? AppColors.straw14 : Colors.white,
                border: Border.all(color: AppColors.morandiText, width: 2.5),
                borderRadius: BorderRadius.circular(14),
                boxShadow: _showRelated
                    ? const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)]
                    : null,
              ),
              child: Center(
                child: Text(
                  '关联词\n(Associated)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _showRelated ? AppColors.morandiText : AppColors.shark40.withValues(alpha: 0.5),
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _showRelated = false),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: !_showRelated ? AppColors.straw14 : Colors.white,
                border: Border.all(color: AppColors.morandiText, width: 2.5),
                borderRadius: BorderRadius.circular(14),
                boxShadow: !_showRelated
                    ? const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)]
                    : null,
              ),
              child: Center(
                child: Text(
                  '短语\n(Phrases)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: !_showRelated ? AppColors.morandiText : AppColors.shark40.withValues(alpha: 0.5),
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- 关联词 ----------

  Widget _buildRelatedSection() {
    final synonyms = _word.relatedWords.where((r) => r.type == 'synonym').toList();
    final antonyms = _word.relatedWords.where((r) => r.type == 'antonym').toList();
    final expands = _word.relatedWords.where((r) => r.type == 'expand').toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 2.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (synonyms.isNotEmpty) ...[
            _buildCategoryTag('近义词 synonym', AppColors.baliHai30),
            const SizedBox(height: 12),
            ...synonyms.map((r) => _buildRelatedRow(r)),
          ],
          if (antonyms.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildCategoryTag('反义词 antonym', AppColors.oldRose15),
            const SizedBox(height: 12),
            ...antonyms.map((r) => _buildRelatedRow(r)),
          ],
          if (expands.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildCategoryTag('拓展词 expand word', AppColors.lavenderPurple.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            ...expands.map((r) => _buildRelatedRow(r)),
          ],
          if (synonyms.isEmpty && antonyms.isEmpty && expands.isEmpty)
            const Text('无', style: TextStyle(fontSize: 14, color: AppColors.shark40)),
        ],
      ),
    );
  }

  Widget _buildCategoryTag(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.morandiText),
      ),
    );
  }

  Widget _buildRelatedRow(_RelatedWord r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(r.chinese, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
          ),
          SizedBox(
            width: 70,
            child: Text(r.pinyin, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lavenderPurple.withValues(alpha: 0.7))),
          ),
          Expanded(
            child: Text(r.english, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.shark40.withValues(alpha: 0.7))),
          ),
        ],
      ),
    );
  }

  // ---------- 短语 ----------

  Widget _buildPhraseSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 2.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryTag('短语 (Phrases)', AppColors.straw14),
          const SizedBox(height: 12),
          ..._word.phrases.map((p) => _buildPhraseRow(p)),
        ],
      ),
    );
  }

  Widget _buildPhraseRow(_Phrase p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(p.chinese, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
          ),
          Expanded(
            flex: 3,
            child: Text(p.english, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.shark40.withValues(alpha: 0.7))),
          ),
        ],
      ),
    );
  }

  // ---------- 底部导航 ----------

  Widget _buildNavigationButtons() {
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == _total - 1;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isFirst ? null : _goPrev,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: isFirst ? AppColors.whisper15 : Colors.white,
                border: Border.all(
                  color: isFirst ? AppColors.shark40.withValues(alpha: 0.2) : AppColors.morandiText,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isFirst ? null : const [
                  BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: Center(
                child: Text(
                  '← Prev',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: isFirst ? AppColors.shark40.withValues(alpha: 0.4) : AppColors.morandiText,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: _goNext,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: isLast ? AppColors.baliHai30 : AppColors.straw14,
                border: Border.all(
                  color: isLast ? AppColors.morandiText : AppColors.morandiText,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: Center(
                child: Text(
                  isLast ? 'Finish' : 'Next →',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.morandiText),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
