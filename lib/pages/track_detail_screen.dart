import 'package:flutter/material.dart';
import 'package:munix/models/track_model.dart';

class TrackDetailScreen extends StatelessWidget {
  final Track track;

  const TrackDetailScreen({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(track.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(track.image),
            Text(track.name),
            Text(track.artistName),
          ],
        ),
      ),
    );
  }
}
