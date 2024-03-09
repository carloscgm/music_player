enum AppAction {
  UNKNOWN(-1),
  NONE(0),
  SIGN_IN(1),
  GET_ARTISTS(2),
  GET_SONGS(3),
  GET_PERMISSION(4),
  GET_PLAYLIST(5),
  ADD_PLAYLIST(6),
  REMOVE_PLAYLIST(7);

  final int value;
  const AppAction(this.value);
}
