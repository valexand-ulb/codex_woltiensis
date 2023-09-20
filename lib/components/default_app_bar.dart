import 'package:codex_woltiensis/style.dart';
import 'package:flutter/material.dart';


class DefaultAppBar extends AppBar {
  @override
  final Widget title = Text("Codex woltiensis".toUpperCase(),
    style: Styles.navBarTitle,);

  @override
  final IconThemeData iconTheme = const IconThemeData(color: Colors.black);

  @override
  final Color backgroundColor = Color(0xFFEC2143);

  @override
  final bool centerTitle = true;

  @override
  final double elevation = 0.5;
}