import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:json_annotation/json_annotation.dart';


part 'song.g.dart';

@JsonSerializable()
class Song {
  static final _database = FirebaseDatabase.instance.ref();
  final int id;
  final String name;
  final String url;
  final String comments;
  final String? text;

  Song(this.id, this.name, this.url, this.comments, [this.text]);

  Song.blank()
      : id = 0,
        name = '',
        url = '',
        comments = '',
        text = '';

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  static Future<List<Song>> fetchAllFromDatabase() async{
    List<Song> songs = <Song>[];
    Completer<List<Song>> completer = Completer<List<Song>>();

    _database.child('songs').onValue.listen((event) {
      final dynamic jsonValue = event.snapshot.value;
      for (var jsonItem in jsonValue) {
        Map<String, dynamic> item = jsonItem.cast<String, dynamic>();
        songs.add(Song.fromJson(item));
      }

      if (!completer.isCompleted) {
        completer.complete(songs);
      }
    });
    await completer.future;
    return songs;
  }

  static Future<Song> fetchByIDFromDatabase(int songID) async {
    Song song = Song.blank();
    Completer<Song> completer = Completer<Song>();

    _database.child(songID.toString()).onValue.listen((event) {
      final dynamic jsonValue = event.snapshot.value;
      Map<String, dynamic> item = jsonValue.cast<String, dynamic>();

      song = Song.fromJson(item);

      if (!completer.isCompleted) {
        completer.complete(song);
      }
    });

    await completer.future;
    return song;
  }
}
