import 'package:flutter/material.dart';
import 'package:codex_woltiensis/models/song.dart';
import 'package:codex_woltiensis/style.dart';

const SongTileHeight = 100.0;

class SongTile extends StatelessWidget{
  final Song song;
  final bool darkTheme;

  SongTile(this.song, this.darkTheme);

  @override
  Widget build(BuildContext context){
    final String title = song.name.toUpperCase();
    final String subtitle = song.comments.toUpperCase();

    return Container(
      height: SongTileHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: darkTheme
              ? Styles.locationTitleDark
              : Styles.locationTitleLight),
          Text(subtitle, style: Styles.locationTitleSubTitle),
        ],
      ),
    );
  }
}