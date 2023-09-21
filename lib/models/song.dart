import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:codex_woltiensis/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'song.g.dart';

@JsonSerializable()
class Song {
  static const String filename = 'codex_woltiensis.json';
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

  static Future<List<Song>> fetchAll() async {
    Uri uri = Endpoint.uri(filename);

    final http.Response resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Failed to load songs : \n ${resp.body}');
    }

    List<Song> songs = <Song>[];
    for (var jsonItem in json.decode(resp.body)) {
      var item = jsonItem;
      songs.add(Song.fromJson(item));
    }
    saveGeneralJsonToFile(resp.body);
    return songs;
  }

  static Future<List<Song>> fetchAllByFile() async {
    Directory tempDirectory = await getTemporaryDirectory();
    File file = File('${tempDirectory.path}/$filename');
    String fileContent = await file.readAsString();

    List<Song> songs = <Song>[];
    for (var jsonItem in json.decode(fileContent)) {
      var item = jsonItem;
      songs.add(Song.fromJson(item));
    }

    return songs;
  }

  static Future<Song> fetchByID(int id) async {
    Uri uri = Endpoint.uri('songs/$id.json');

    final http.Response resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Failed to load song $id : \n ${resp.body}');
    }

    final Map<String, dynamic> itemMap = json.decode(resp.body);
    saveJsonToFile(itemMap);
    return Song.fromJson(itemMap);
  }

  static void saveJsonToFile(Map<String, dynamic> itemMap) async {
    final int id = itemMap['id'];
    final jsonString = json.encode(itemMap);

    final Directory tempDirectory = await getTemporaryDirectory();
    final File file = File('${tempDirectory.path}/$id.json');

    file.writeAsString(jsonString);
  }

  static void saveGeneralJsonToFile(String jsonString) async {
    final Directory tempDirectory = await getTemporaryDirectory();
    final File file = File('${tempDirectory.path}/$filename');
    file.writeAsString(jsonString);
  }

  static Future<Song> fetchByFile(int songID) async {
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/$songID.json');

    String fileContent = await file.readAsString();
    Map<String, dynamic> itemMap = json.decode(fileContent);

    return Song.fromJson(itemMap);
  }

  static Future<bool> isFileCached(String filename) async {
    final Directory tempDirectory = await getTemporaryDirectory();
    final File file = File('${tempDirectory.path}/$filename');
    bool fileExists = await file.exists();
    return fileExists;
  }
}
