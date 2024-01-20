class Weather {
  final String cityName;
  final double temparature;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.mainCondition,
    required this.temparature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      mainCondition: json['main']['temp'].toDoublue(),
      temparature: json['main']['temp'].todouble(),
    );
  }
}
