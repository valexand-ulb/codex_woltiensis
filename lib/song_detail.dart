import 'dart:async';

import 'package:codex_woltiensis/components/banner_image.dart';
import 'package:codex_woltiensis/components/default_app_bar.dart';
import 'package:codex_woltiensis/models/song.dart';
import 'package:codex_woltiensis/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SongDetail extends StatefulWidget {
  final int songID;

  SongDetail(this.songID);

  @override
  createState() => _SongDetailState(this.songID);
}

class _SongDetailState extends State<SongDetail> {
  final int songID;
  Song song = Song.blank();
  bool loading = false;

  _SongDetailState(this.songID);

  @override
  void initState() {
    super.initState();
    _loadSong();
  }

  void _loadSong([bool serverReload = false]) async {
    if (mounted) {
      setState(() => loading = true);
      Timer(const Duration(milliseconds: 500), () async {
        final Song song;
        bool fileExists = await Song.isFileCached('$songID.json');

        if (fileExists && !serverReload) {
          song = await Song.fetchByFile(songID);
        } else {
          song = await Song.fetchByID(songID);
        }

        setState(() {
          loading = false;
          this.song = song;
        });
      });
    }

    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadSong(true);
        },
        child: Column(
          children: [
            renderProgressBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _renderBody(context, song),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _renderBody(BuildContext context, Song song) {
    List<Widget> widgets = <Widget>[];
    widgets.add(BannerImage(song.url, 170.0));
    widgets.add(_renderTitle(song.name));
    widgets.add(_renderSubTitle(song.comments));
    widgets.add(_renderText(song.text ?? ''));
    return widgets;
  }

  Container _renderTitle(String name) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 5.0),
      child: Text(
        name,
        textAlign: TextAlign.left,
        style: Styles.headerLarge,
      ),
    );
  }

  Container _renderSubTitle(String subtitle) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
      child: Text(
        subtitle,
        textAlign: TextAlign.left,
        style: Styles.songDetailTitleSubTitle,
      ),
    );
  }

  Widget _renderText(String text) {
    return Container(
        padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
        child: MarkdownBody(
            data: text,
            styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                textTheme: const TextTheme(
              bodyMedium: Styles.textDefault,
            )))));
  }

  Widget renderProgressBar(BuildContext context) {
    return (loading
        ? const LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          )
        : Container());
  }
}
