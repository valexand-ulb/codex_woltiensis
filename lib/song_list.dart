import 'dart:async';
import 'dart:io';

import 'package:codex_woltiensis/components/banner_image.dart';
import 'package:codex_woltiensis/components/default_app_bar.dart';
import 'package:codex_woltiensis/components/song_tile.dart';
import 'package:codex_woltiensis/models/song.dart';
import 'package:codex_woltiensis/searchpage.dart';
import 'package:codex_woltiensis/song_detail.dart';
import 'package:codex_woltiensis/style.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const ListItemHeight = 245.0;

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> with WidgetsBindingObserver {
  List<Song> songs = <Song>[];
  final _scrollController = ScrollController();
  bool loading = false;
  bool onTop = true;


  @override
  void initState() {
    super.initState();
    _loadSongs();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _deleteCachedJsonfiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: GestureDetector(
          onTap: () => _handleTitleTap(),
          child: const Text("CODEX WOLTIENSIS", style: Styles.navBarTitle),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _navigateToSearchPage(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await _loadSongs();
          },
          child: Column(children: [
            _renderProgressBar(context),
            Expanded(
              child: _renderListView(context),
            )
          ])),
    );
  }

  void _handleTitleTap() {
    if (!onTop) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      onTop = true;
    } else {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      onTop = false;
    }
  }

  Future<void> _loadSongs() async {
    if (mounted) {
      setState(() => loading = true);
      Timer(const Duration(seconds: 1), () async {
        final List<Song> songs = await Song.fetchAllFromDatabase();
        setState(() {
          this.songs = songs;
          loading = false;
        });
      });
    }
  }

  Widget _renderProgressBar(BuildContext context) {
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
      controller: _scrollController,
      itemCount: songs.length,
      itemBuilder: _listViewItemBuilder,
    );
  }

  GridView _renderGridView(BuildContext context) {
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

  void _navigateToSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(),
      ),
    );
  }

  void _navigateToSongDetails(BuildContext context, int songID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongDetail(songID),
      ),
    );
  }

  Column _tileFooter(Song song) {
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

  Future<void> _deleteCachedJsonfiles() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      for (var file in tempDir.listSync()) {
        if (file.path.endsWith('.json')) {
          file.delete();
        }
      }
    } catch (e) {
      print('Error while cleaning cache: $e');
    }
  }
}
