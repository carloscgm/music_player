import 'dart:convert';

class PlayList {
  late int? id;
  late String name;
  late List<String> songsTitles;

  PlayList({this.id, required this.name, required this.songsTitles});

  PlayList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    String songs = json['songs'];
    songsTitles =
        songs.substring(1, songs.length - 1).replaceAll('"', '').split(',');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['songs'] = jsonEncode(songsTitles);
    return data;
  }
}
