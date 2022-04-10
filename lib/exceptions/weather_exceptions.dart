class WeatherExceptions implements Exception {
  String message;
  WeatherExceptions([this.message = 'Something went wrong']) {
    message = 'Weather Exception: $message';
  }

  @override
  String toString() {
    return message;
  }
}
