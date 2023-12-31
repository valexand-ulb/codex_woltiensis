import 'package:cached_network_image/cached_network_image.dart';
import 'package:codex_woltiensis/components/default_app_bar.dart';
import 'package:codex_woltiensis/models/song.dart';
import 'package:codex_woltiensis/song_detail.dart';
import 'package:codex_woltiensis/style.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController controller;
  List<Song> songs = <Song>[];
  List<Song> foundedSongs = <Song>[];

  _SearchPageState();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _loadSongs();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildListView());
  }

  ListView _buildListView() {
    return ListView.builder(
        itemCount: foundedSongs.length,
        itemBuilder: (context, index) {
          return _songListTile(context, index);
        });
  }

  ListTile _songListTile(BuildContext context, int index) {
    return ListTile(
          leading: CachedNetworkImage(
            width: 50.0,
            height: 50.0,
            imageUrl: foundedSongs[index].url,
            placeholder: (context, url) =>
                const CircularProgressIndicator(color: Colors.white),
            errorWidget: (context, url, error) => Container()),
          title: Text(
            foundedSongs[index].name,
            style: Styles.textDefault,
          ),
          onTap: () {
            // Navigate to the detail page
            _navigateToSongDetails(context, foundedSongs[index].id);
          },
        );
  }

  AppBar _buildAppBar() {
    return DefaultAppBar(
      title: Center(
        child: _buildTextField(),
      ),
    );
  }

  TextField _buildTextField() {
    return TextField(
      style: Styles.navBarTitle,
      decoration: _setinputDecoration(),
      controller: controller,
      onChanged:_searchSongs
    );
  }

  InputDecoration _setinputDecoration() {
    return InputDecoration(
      prefixIcon: const Icon(Icons.search, color: Colors.white),
      suffixIcon: IconButton(
          onPressed: () {
            // Clear the text field
            controller.clear();
            _searchSongs('');
          },
          icon: const Icon(Icons.clear, color: Colors.white)),
      hintText: 'Search',
      hintStyle: Styles.navBarTitle,
      fillColor: Colors.white,
      border: InputBorder.none,
    );
  }

  void _loadSongs() async {
    final List<Song> songs = await Song.fetchAllFromDatabase();
    setState(() {
      this.songs = songs;
      foundedSongs = songs;
    });
  }

  void _navigateToSongDetails(BuildContext context, int songID) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongDetail(songID),
      ),
    );
  }

  void _searchSongs(String query) {
    final suggestions = songs.where(
        (song) => song.name.toLowerCase().contains(query.toLowerCase())
    ).toList();

    setState(() => foundedSongs = suggestions);
  }
}
