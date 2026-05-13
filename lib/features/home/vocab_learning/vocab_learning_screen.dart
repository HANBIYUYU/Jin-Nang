import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

// ===================== 词汇数据 =====================

class _VocabItem {
  final String chinese;
  final String pinyin;
  final String english;
  final String audioAsset;

  const _VocabItem({
    required this.chinese,
    required this.pinyin,
    required this.english,
    required this.audioAsset,
  });
}

const _vocabList = [
  _VocabItem(chinese: '米饭', pinyin: 'mǐfàn', english: 'cooked rice', audioAsset: 'assets/audio/rice.mp3'),
  _VocabItem(chinese: '面条', pinyin: 'miàntiáo', english: 'noodles', audioAsset: 'assets/audio/noodle.mp3'),
  _VocabItem(chinese: '水', pinyin: 'shuǐ', english: 'water', audioAsset: 'assets/audio/water.mp3'),
  _VocabItem(chinese: '茶', pinyin: 'chá', english: 'tea', audioAsset: 'assets/audio/tea.mp3'),
  _VocabItem(chinese: '饭店', pinyin: 'fàndiàn', english: 'restaurant', audioAsset: 'assets/audio/restaurant.mp3'),
  _VocabItem(chinese: '吃', pinyin: 'chī', english: 'to eat', audioAsset: 'assets/audio/eat.mp3'),
];

// ===================== VocabLearningScreen =====================

class VocabLearningScreen extends StatefulWidget {
  const VocabLearningScreen({super.key});

  @override
  State<VocabLearningScreen> createState() => _VocabLearningScreenState();
}

class _VocabLearningScreenState extends State<VocabLearningScreen> {
  final Set<int> _clickedCards = {};
  int _highlightedIndex = -1;
  bool _isPlaying = false;
  final AudioPlayer _player = AudioPlayer();

  bool get _allClicked => _clickedCards.length >= _vocabList.length;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _onCardTap(int index) async {
    // 防重复点击：同一张卡片在音频播放结束前无效
    if (_highlightedIndex == index || _isPlaying) return;

    setState(() {
      _clickedCards.add(index);
      _highlightedIndex = index;
      _isPlaying = true;
    });

    Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _highlightedIndex = -1);
    });

    final asset = _vocabList[index].audioAsset;
    try {
      await _player.stop();
      await _player.play(AssetSource(asset.replaceFirst('assets/', '')));
    } catch (e) {
      debugPrint('[Audio] Error playing $asset: $e');
    } finally {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  void _goToDialoguePractice() => context.go('/study/dialogue-practice');
  void _goBack() => context.go('/study/vocab-scene');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 39),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTitle(),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85,
                  ),
                  itemCount: _vocabList.length,
                  itemBuilder: (context, index) => _buildVocabCard(index),
                ),
              ),
              const SizedBox(height: 16),
              _buildNextButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: _goBack,
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              border: Border.all(color: AppColors.morandiText, width: 2.389),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, size: 20, color: AppColors.morandiText),
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
              boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
            ),
            child: const Text('Vocab Learning', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 2),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)],
      ),
      child: const Text('先来学学这几个词', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
    );
  }

  Widget _buildVocabCard(int index) {
    final vocab = _vocabList[index];
    final isHighlighted = _highlightedIndex == index;
    final hasClicked = _clickedCards.contains(index);

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.straw14 : Colors.white,
          border: Border.all(color: hasClicked ? AppColors.semanticGreen : AppColors.morandiText, width: hasClicked ? 2.5 : 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(vocab.chinese, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.lavenderPurple.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(6)),
              child: Text(vocab.pinyin, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.morandiText)),
            ),
            const SizedBox(height: 8),
            Text(vocab.english, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.morandiText.withValues(alpha: 0.6))),
            const SizedBox(height: 8),
            if (hasClicked)
              const Icon(Icons.check_circle, size: 18, color: AppColors.semanticGreen)
            else
              Icon(Icons.volume_up, size: 18, color: AppColors.morandiText.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _allClicked ? _goToDialoguePractice : null,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: _allClicked ? AppColors.baliHai30 : AppColors.whisper15,
          border: Border.all(
            color: _allClicked ? AppColors.morandiText : AppColors.shark40.withValues(alpha: 0.2),
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: _allClicked ? const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)] : null,
        ),
        child: Center(
          child: Text(
            _allClicked ? '学完了，去练习 →' : '点击卡片学习 (${_clickedCards.length}/${_vocabList.length})',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: _allClicked ? AppColors.morandiText : AppColors.shark40.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}
