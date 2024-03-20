enum AppAction {
  UNKNOWN(-1),
  NONE(0),
  SIGN_IN(1),
  GET_ARTISTS(2),
  GET_SONGS(3),
  GET_PERMISSION(4),
  GET_PLAYLIST(5),
  ADD_PLAYLIST(6),
  REMOVE_PLAYLIST(7),
  GET_SONGS_BY_PLAYLIST(8);

  final int value;
  const AppAction(this.value);
}
