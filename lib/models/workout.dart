class Workout {
  final String id;
  final String title;
  final int calories;
  final int durationMinutes;
  final bool isPro;
  final String imageUrl;
  final String category;

  const Workout({
    required this.id,
    required this.title,
    required this.calories,
    required this.durationMinutes,
    required this.isPro,
    required this.imageUrl,
    required this.category,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      title: json['title'] as String,
      calories: (json['calories'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      isPro: json['isPro'] as bool,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String? ?? 'other',
    );
  }
}