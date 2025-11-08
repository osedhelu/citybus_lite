class WrongCredentials implements Exception {}

class ConnectionTimeout implements Exception {}

class InvalidToken implements Exception {}

class CustomError implements Exception {
  final String message;
  // final String errorCode;

  CustomError({this.message = ""});
}
