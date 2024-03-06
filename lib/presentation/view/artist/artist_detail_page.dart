import 'package:flutter/material.dart';
import 'package:music_player/model/artist.dart';

class ArtistDetailPage extends StatefulWidget {
  final Artist artist;

  const ArtistDetailPage({super.key, required this.artist});

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
