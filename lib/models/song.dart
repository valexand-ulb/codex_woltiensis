import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:codex_woltiensis/endpoint.dart';

part 'song.g.dart';

@JsonSerializable()
class Song{
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

  factory Song.fromJson(Map<String, dynamic> json) =>
       _$SongFromJson(json);

  static Future<List<Song>> fetchAll() async {
    Uri uri = Endpoint.uri('codex_woltiensis.json');
    print(uri.toString());

    final http.Response resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Failed to load songs : \n ${resp.body}');
    }

    List<Song> songs = <Song>[];
    for (var jsonItem in json.decode(resp.body)) {
      var item = jsonItem;
      songs.add(Song.fromJson(item));
    }
    return songs;
  }

  static Future<Song> fetchByID(int id) async {
    Uri uri = Endpoint.uri('songs/$id.json');
    print(uri.toString());

    final http.Response resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Failed to load song $id : \n ${resp.body}');
    }

    final Map<String, dynamic> itemMap = json.decode(resp.body);
    return Song.fromJson(itemMap);
  }
}