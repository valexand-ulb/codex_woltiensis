import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:codex_woltiensis/components/banner_image.dart';
import 'package:codex_woltiensis/components/default_app_bar.dart';
import 'package:codex_woltiensis/components/song_tile.dart';
import 'package:codex_woltiensis/models/song.dart';
import 'package:codex_woltiensis/song_detail.dart';
import 'package:codex_woltiensis/style.dart';
import 'package:path_provider/path_provider.dart';

const ListItemHeight = 245.0;

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  List<Song> songs = <Song>[];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: RefreshIndicator(
          onRefresh: _loadSongs,
          child: Column(children: [
            renderProgressBar(context),
            Expanded(
              child: _renderListView(context),
            )
          ])),
    );
  }

  Future<void> _loadSongs() async {
    if (mounted) {
      setState(() => loading = true);
      Timer(const Duration(seconds: 1), () async {
        bool exists = await Song.isFileCached(Song.filename);
        final List<Song> songs;
        if (exists) {
          songs = await Song.fetchAllByFile();
        } else {
          songs = await Song.fetchAll();
        }
        setState(() {
          this.songs = songs;
          loading = false;
        });
      });
    }
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
  
  ListView _renderListView(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: _listViewItemBuilder,
    );
  }
  
  GridView _renderGridView(BuildContext context){
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.0),
      itemBuilder: _listViewItemBuilder,
      itemCount: songs.length,
    );
  }

  GestureDetector _listViewItemBuilder(BuildContext context, int index) {
    final Song song = songs[index];
    return GestureDetector(
      onTap: () => _navigateToSongDetails(context, song.id),
      child: Container(
        height: ListItemHeight,
        child: Stack(
          children: [
            BannerImage(song.url, ListItemHeight),
            _tileFooter(song),
          ],
        ),
      ),
    );
  }

  void _navigateToSongDetails(BuildContext context, int songID){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongDetail(songID),
      ),
    );
  }

  Column _tileFooter(Song song){
    final info = SongTile(song, true);
    final overlay = Container(
      height: 80.0,
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: Styles.horizontalPaddingDefault,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
      ),
      child: info,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        overlay,
      ],
    );
  }
}
