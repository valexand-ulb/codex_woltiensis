import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerImage extends StatelessWidget {
  final String url;
  final double height;

  BannerImage(this.url, this.height);

  @override
  Widget build(BuildContext context) {
    CachedNetworkImage image = CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fitWidth,
      placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white),
      errorWidget: (context, url, error) => Container(),
    );

    return Container(
      constraints: BoxConstraints.expand(height: height),
      child: image,
    );
  }
}