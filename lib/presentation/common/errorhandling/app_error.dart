enum AppError {
  UNKNOWN(-1),
  NONE(0),
  NO_INTERNET(1),
  TIMEOUT(2),
  SERVER(3),
  UNAUTHORIZED(4),
  NOT_FOUND(5);

  final int value;
  const AppError(this.value);
}
