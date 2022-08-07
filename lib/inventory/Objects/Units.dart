class Units {
  final List units;
  const Units({
    required this.units,
  });

  factory Units.fromJson(Map<String, dynamic> json) {
    return Units(
      units: json['units'],
    );
  }

  Map<String, dynamic> toJson() => {
        'units': units,
      };
}
