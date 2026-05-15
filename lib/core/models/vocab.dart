class VocabItem {
  final int id;
  final String chinese;
  final String pinyin;
  final String english;
  final String audioUrl;

  const VocabItem({
    required this.id,
    required this.chinese,
    required this.pinyin,
    required this.english,
    required this.audioUrl,
  });

  factory VocabItem.fromJson(Map<String, dynamic> j) => VocabItem(
        id: j['id'] as int,
        chinese: j['chinese'] as String,
        pinyin: j['pinyin'] as String,
        english: j['english'] as String,
        audioUrl: j['audio_url'] as String,
      );
}

class VocabExample {
  final String chinese;
  final String pinyin;
  final String english;

  const VocabExample({required this.chinese, required this.pinyin, required this.english});

  factory VocabExample.fromJson(Map<String, dynamic> j) => VocabExample(
        chinese: j['chinese'] as String,
        pinyin: j['pinyin'] as String,
        english: j['english'] as String,
      );
}

class RelatedWord {
  final String type; // synonym | antonym | expand
  final String chinese;
  final String pinyin;
  final String english;

  const RelatedWord({required this.type, required this.chinese, required this.pinyin, required this.english});

  factory RelatedWord.fromJson(Map<String, dynamic> j) => RelatedWord(
        type: j['type'] as String,
        chinese: j['chinese'] as String,
        pinyin: j['pinyin'] as String,
        english: j['english'] as String,
      );
}

class VocabPhrase {
  final String chinese;
  final String english;

  const VocabPhrase({required this.chinese, required this.english});

  factory VocabPhrase.fromJson(Map<String, dynamic> j) => VocabPhrase(
        chinese: j['chinese'] as String,
        english: j['english'] as String,
      );
}

class VocabDetail {
  final int id;
  final String chinese;
  final String pinyin;
  final String partOfSpeech;
  final String englishMeaning;
  final String chineseMeaning;
  final String chineseMeaningPinyin;
  final String audioUrl;
  final List<VocabExample> examples;
  final List<RelatedWord> relatedWords;
  final List<VocabPhrase> phrases;

  const VocabDetail({
    required this.id,
    required this.chinese,
    required this.pinyin,
    required this.partOfSpeech,
    required this.englishMeaning,
    required this.chineseMeaning,
    required this.chineseMeaningPinyin,
    required this.audioUrl,
    required this.examples,
    required this.relatedWords,
    required this.phrases,
  });

  factory VocabDetail.fromJson(Map<String, dynamic> j) => VocabDetail(
        id: j['id'] as int,
        chinese: j['chinese'] as String,
        pinyin: j['pinyin'] as String,
        partOfSpeech: j['part_of_speech'] as String,
        englishMeaning: j['english_meaning'] as String,
        chineseMeaning: j['chinese_meaning'] as String,
        chineseMeaningPinyin: j['chinese_meaning_pinyin'] as String,
        audioUrl: j['audio_url'] as String,
        examples: (j['examples'] as List).map((e) => VocabExample.fromJson(e as Map<String, dynamic>)).toList(),
        relatedWords: (j['related_words'] as List).map((e) => RelatedWord.fromJson(e as Map<String, dynamic>)).toList(),
        phrases: (j['phrases'] as List).map((e) => VocabPhrase.fromJson(e as Map<String, dynamic>)).toList(),
      );
}
