import 'package:flutter/material.dart';
import 'package:codex_woltiensis/style.dart';

class DefaultAppBar extends AppBar {
  @override
  final Widget title = Text("Codex woltiensis".toUpperCase(),
    style: Styles.navBarTitle,);

  @override
  final IconThemeData iconTheme = const IconThemeData(color: Colors.black);

  @override
  final Color backgroundColor = Colors.white;

  @override
  final bool centerTitle = true;

  @override
  final double elevation = 0.5;
}