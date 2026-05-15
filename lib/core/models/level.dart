class Question {
  final int id;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> j) => Question(
        id: j['id'] as int,
        questionText: j['question_text'] as String,
        options: List<String>.from(j['options'] as List),
        correctIndex: j['correct_index'] as int,
        explanation: j['explanation'] as String,
      );
}

class Level {
  final int id;
  final int levelNum;
  final String title;
  final String subtitle;
  final int passThreshold;
  final int stars;
  final int bestScore;
  final bool isUnlocked;
  final List<Question> questions;

  const Level({
    required this.id,
    required this.levelNum,
    required this.title,
    required this.subtitle,
    required this.passThreshold,
    required this.stars,
    required this.bestScore,
    required this.isUnlocked,
    required this.questions,
  });

  factory Level.fromJson(Map<String, dynamic> j) => Level(
        id: j['id'] as int,
        levelNum: j['level_num'] as int,
        title: j['title'] as String,
        subtitle: j['subtitle'] as String,
        passThreshold: j['pass_threshold'] as int,
        stars: j['stars'] as int,
        bestScore: j['best_score'] as int,
        isUnlocked: j['is_unlocked'] as bool,
        questions: (j['questions'] as List).map((e) => Question.fromJson(e as Map<String, dynamic>)).toList(),
      );
}
