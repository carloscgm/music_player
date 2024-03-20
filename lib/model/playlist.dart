import 'dart:convert';

class PlayList {
  late int? id;
  late String name;
  late List<String> songsTitles;

  PlayList({this.id, required this.name, required this.songsTitles});

  PlayList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    songsTitles = getStringByJsonTable(json['songs']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['songs'] = jsonEncode(songsTitles);
    return data;
  }

  List<String> getStringByJsonTable(String jsonTable) {
    List<String> result = [];
    List<String> splited = jsonTable.split('","');
    for (int i = 0; i < splited.length; i++) {
      String s = splited[i];
      if (i == 0) {
        s = s.substring(2);
      }
      if (i == splited.length - 1) {
        s = s.substring(0, s.length - 2);
      }
      result.add(s);
    }
    return result;
  }
}
