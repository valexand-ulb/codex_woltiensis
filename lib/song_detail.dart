import 'package:flutter/material.dart';
import 'package:codex_woltiensis/components/banner_image.dart';
import 'package:codex_woltiensis/components/default_app_bar.dart';
import 'package:codex_woltiensis/models/song.dart';
import 'package:codex_woltiensis/style.dart';

class SongDetail extends StatefulWidget{
  final int songID;

  SongDetail(this.songID);

  @override
  createState() => _SongDetailState(this.songID);
}

class _SongDetailState extends State<SongDetail>{
  final int songID;
  Song song = Song.blank();

  _SongDetailState(this.songID);

  @override
  void initState(){
    super.initState();
    _loadSong();
  }

  void _loadSong() async{
    final Song song = await Song.fetchByID(songID);
    if(mounted){
      setState(() => this.song = song);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: DefaultAppBar(),
      body: SingleChildScrollView(
        child : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _renderBody(context, song),
        ),
      ),
    );
  }

  List<Widget> _renderBody(BuildContext context, Song song){
    List<Widget> widgets = <Widget>[];
    widgets.add(BannerImage(song.url, 170.0));
    widgets.add(_renderTitle(song.name));
    widgets.add(_renderSubTitle(song.comments));
    widgets.add(_renderText(song.text ?? ''));
    return widgets;
  }

  Container _renderTitle(String name){
    return Container(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 5.0),
      child: Text(
        name,
        textAlign: TextAlign.left,
        style: Styles.headerLarge,
      ),
    );
  }

  Container _renderSubTitle(String subtitle){
    return Container(
      padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
      child: Text(
        subtitle,
        textAlign: TextAlign.left,
        style: Styles.locationTitleSubTitle,
      ),
    );
  }

  Container _renderText(String text){
    return Container(
      padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
      child: Text(text, style: Styles.textDefault),
    );
  }
}