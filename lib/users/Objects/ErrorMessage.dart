class ErrorText {
  final String message;

  const ErrorText({required this.message});

  factory ErrorText.fromJson(Map<String, dynamic> json) {
    return ErrorText(message: json['message']);
  }
}
