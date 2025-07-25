import 'package:flutter/material.dart';
import 'package:munix/models/track_model.dart';
import 'package:munix/services/jamendo_service.dart';

class SpotifyStylePlayer extends StatefulWidget {
  final Function(Track, int, List<Track>) onTrackSelected;

  const SpotifyStylePlayer({
    Key? key,
    required this.onTrackSelected,
  }) : super(key: key);

  @override
  State<SpotifyStylePlayer> createState() => _SpotifyStylePlayerState();
}

class _SpotifyStylePlayerState extends State<SpotifyStylePlayer> {
  List<Track> _tracks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  Future<void> _fetchTracks() async {
    setState(() => _isLoading = true);
    try {
      final tracks = await JamendoService().fetchPopularTracks();
      setState(() {
        _tracks = tracks;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching tracks: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final track = _tracks[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          widget.onTrackSelected(track, index, _tracks);
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                track.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    track.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    track.artistName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _tracks.length,
                ),
              ),
            ],
          );
  }
}
