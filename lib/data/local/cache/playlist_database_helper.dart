import 'package:music_player/data/local/cache/base/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'database_tables.dart';

class PlayListDatabaseHelper extends DatabaseHelper {
  PlayListDatabaseHelper() : super('playlist_database.db');

  @override
  void onCreate(Database db, int version) async {
    // Create db tables
    final batch = db.batch();

    _createPlaylistTable(batch);

    await batch.commit();
  }

  _createPlaylistTable(Batch batch) {
    batch.execute(
        '''CREATE TABLE IF NOT EXISTS ${DatabaseTables.playlist} (id INTEGER PRIMARY KEY, name TEXT, songs TEXT)''');
  }
}
