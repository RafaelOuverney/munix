import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:munix/models/track_model.dart';
import 'dart:ui';

class NowPlayingScreen extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final List<Track> playlist;
  final int initialIndex;

  const NowPlayingScreen({
    Key? key,
    required this.audioPlayer,
    required this.playlist,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late int currentIndex;
  bool _isSeeking = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextTrack();
      }
    });
  }

  void _playNextTrack() {
    if (currentIndex < widget.playlist.length - 1) {
      setState(() => currentIndex++);
      _playTrack(widget.playlist[currentIndex]);
    }
  }

  void _playPreviousTrack() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _playTrack(widget.playlist[currentIndex]);
    }
  }

  Future<void> _playTrack(Track track) async {
    try {
      await widget.audioPlayer.setUrl(track.audio);
      await widget.audioPlayer.play();
    } catch (e) {
      print("Error playing track: $e");
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "--:--";
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final currentTrack = widget.playlist[currentIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(currentTrack.image),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  // Album Art
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          currentTrack.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Track Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Text(
                          currentTrack.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentTrack.artistName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Progress Bar
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        StreamBuilder<Duration>(
                          stream: widget.audioPlayer.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration = widget.audioPlayer.duration ?? Duration.zero;
                            
                            return Column(
                              children: [
                                Slider(
                                  value: position.inSeconds.toDouble(),
                                  max: duration.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    if (!_isSeeking) {
                                      _isSeeking = true;
                                      widget.audioPlayer.seek(Duration(seconds: value.toInt()));
                                      _isSeeking = false;
                                    }
                                  },
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_formatDuration(position),
                                          style: const TextStyle(color: Colors.white)),
                                      Text(_formatDuration(duration),
                                          style: const TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Playback Controls
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shuffle, color: Colors.white, size: 32),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
                          onPressed: _playPreviousTrack,
                        ),
                        StreamBuilder<PlayerState>(
                          stream: widget.audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState = playerState?.processingState;
                            final playing = playerState?.playing;
                            
                            IconData icon;
                            VoidCallback? onPressed;
                            
                            if (processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering) {
                              icon = Icons.hourglass_empty;
                              onPressed = null;
                            } else if (playing != true) {
                              icon = Icons.play_circle_filled;
                              onPressed = widget.audioPlayer.play;
                            } else {
                              icon = Icons.pause_circle_filled;
                              onPressed = widget.audioPlayer.pause;
                            }

                            return IconButton(
                              icon: Icon(icon, color: Colors.white, size: 64),
                              onPressed: onPressed,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
                          onPressed: _playNextTrack,
                        ),
                        IconButton(
                          icon: const Icon(Icons.repeat, color: Colors.white, size: 32),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
