class RatingsBreakdown {
  final int count;
  final int percentage;

  RatingsBreakdown({required this.count, required this.percentage});

  factory RatingsBreakdown.fromJson(Map<String, dynamic> json) {
    return RatingsBreakdown(
      count: json['count'],
      percentage: json['percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'count': count, 'percentage': percentage};
  }
}
