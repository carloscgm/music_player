enum AppAction {
  UNKNOWN(-1),
  NONE(0),
  SIGN_IN(1),
  GET_ARTISTS(2);

  final int value;
  const AppAction(this.value);
}
