// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      json['id'] as int,
      json['name'] as String,
      json['url'] as String,
      json['comments'] as String,
      json['text'] as String?,
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'comments': instance.comments,
      'text': instance.text,
    };
