class errorText {
  final String message;

  const errorText({required this.message});

  factory errorText.fromJson(Map<String, dynamic> json) {
    return errorText(message: json['message']);
  }
}
