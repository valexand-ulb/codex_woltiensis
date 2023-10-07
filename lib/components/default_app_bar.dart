import 'package:codex_woltiensis/style.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar({
    Key? key,
    title = const Text("CODEX WOLTIENSIS", style: Styles.navBarTitle),
    List<Widget> actions = const <Widget>[],
    flexibleSpace,
    // Ajoutez d'autres paramètres personnalisés au besoin.
  }) : super(
          key: key,
          title: title,
          flexibleSpace: flexibleSpace,
          actions: actions,
        );


  @override
  final IconThemeData iconTheme = const IconThemeData(color: Colors.black);

  @override
  final Color backgroundColor = const Color(0xFFEC2143);

  @override
  final bool centerTitle = true;

  @override
  final double elevation = 0.5;
}
