import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munix/config/rotas.dart';
import 'package:munix/services/auth_service.dart';
import 'package:munix/models/track_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:munix/pages/spotify_style_player.dart';
import 'package:munix/pages/now_playing_screen.dart';
import 'package:munix/widgets/mini_player.dart';
import 'package:munix/pages/search_page.dart';
import 'package:munix/pages/discover_page.dart';
import 'package:munix/pages/analytics_page.dart';
import 'package:munix/pages/playlist_page.dart';
import 'package:munix/services/storage_service.dart';
import 'package:munix/services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;
  Track? _currentTrack;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Track> _playlist = [];

  @override
  void initState() {
    super.initState();
    _initServices();
    _widgetOptions = <Widget>[
      SpotifyStylePlayer(
        onTrackSelected: (track, index, playlist) async {
          setState(() {
            _currentTrack = track;
            _playlist = playlist;
          });
          try {
            await _audioPlayer.setUrl(track.audio);
            await _audioPlayer.play();
            
            if (mounted) {
              // Abrir NowPlayingScreen automaticamente
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(
                    audioPlayer: _audioPlayer,
                    playlist: playlist,
                    initialIndex: index,
                  ),
                ),
              );
            }
          } catch (e) {
            print("Error playing audio: $e");
          }
        },
      ),
      SearchPage(
        onTrackSelected: (track, index, playlist) async {
          setState(() {
            _currentTrack = track;
            _playlist = playlist;
          });
          try {
            await _audioPlayer.setUrl(track.audio);
            await _audioPlayer.play();
            
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(
                    audioPlayer: _audioPlayer,
                    playlist: playlist,
                    initialIndex: index,
                  ),
                ),
              );
            }
          } catch (e) {
            print("Error playing audio: $e");
          }
        },
      ),
      PlaylistPage(
        onTrackSelected: (track, index, playlist) async {
          setState(() {
            _currentTrack = track;
            _playlist = playlist;
          });
          try {
            await _audioPlayer.setUrl(track.audio);
            await _audioPlayer.play();
            
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(
                    audioPlayer: _audioPlayer,
                    playlist: playlist,
                    initialIndex: index,
                  ),
                ),
              );
            }
          } catch (e) {
            print("Error playing audio: $e");
          }
        },
      ),
      DiscoverPage(
        onTrackSelected: (track, index, playlist) async {
          setState(() {
            _currentTrack = track;
            _playlist = playlist;
          });
          try {
            await _audioPlayer.setUrl(track.audio);
            await _audioPlayer.play();
            
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(
                    audioPlayer: _audioPlayer,
                    playlist: playlist,
                    initialIndex: index,
                  ),
                ),
              );
            }
          } catch (e) {
            print("Error playing audio: $e");
          }
        },
      ),
      AnalyticsPage(),
    ];
  }

  Future<void> _initServices() async {
    await StorageService.init();
    await NotificationService.init();
  }

  Future<void> _playTrack(Track track, int index) async {
    try {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      await _audioPlayer.setUrl(track.audio);
      await _audioPlayer.play();
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NowPlayingScreen(
              audioPlayer: _audioPlayer,
              playlist: _playlist,
              initialIndex: index,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)),
        actions: _getAppBarActions(_selectedIndex),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                bottom: _currentTrack != null ? 80 : kBottomNavigationBarHeight,
              ),
              child: _widgetOptions[_selectedIndex],
            ),
            if (_currentTrack != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MiniPlayer(
                      track: _currentTrack!,
                      audioPlayer: _audioPlayer,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NowPlayingScreen(
                              audioPlayer: _audioPlayer,
                              playlist: _playlist,
                              initialIndex: _playlist.indexWhere((t) => t.id == _currentTrack!.id),
                            ),
                          ),
                        );
                      },
                      onPlayPause: () {
                        if (_audioPlayer.playing) {
                          _audioPlayer.pause();
                        } else {
                          _audioPlayer.play();
                        }
                      },
                      onNext: () {
                        final currentIndex = _playlist.indexWhere((t) => t.id == _currentTrack!.id);
                        if (currentIndex < _playlist.length - 1) {
                          final nextTrack = _playlist[currentIndex + 1];
                          setState(() => _currentTrack = nextTrack);
                          _audioPlayer.setUrl(nextTrack.audio);
                          _audioPlayer.play();
                        }
                      },
                      onPrevious: () {
                        final currentIndex = _playlist.indexWhere((t) => t.id == _currentTrack!.id);
                        if (currentIndex > 0) {
                          final previousTrack = _playlist[currentIndex - 1];
                          setState(() => _currentTrack = previousTrack);
                          _audioPlayer.setUrl(previousTrack.audio);
                          _audioPlayer.play();
                        }
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.grey[900],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisa'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Playlists'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Descobrir'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
        ],
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Munix';
      case 1:
        return 'Pesquisa';
      case 2:
        return 'Sua Biblioteca';
      case 3:
        return 'Perfil';
      default:
        return 'Munix';
    }
  }

  List<Widget>? _getAppBarActions(int index) {
    if (index == 0) {
      return [
        const SizedBox(width: 10),
        Container(
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              authService.value.currentUser?.photoURL ??
                  'https://static.vecteezy.com/system/resources/previews/003/715/527/non_2x/picture-profile',
            ),
          ),
        ),
        const SizedBox(width: 10),
        Padding(padding: const EdgeInsets.only(right: 16.0)),
      ];
    }
    return null; // No actions for other screens
  }
}

Widget _buildProfileScreen(BuildContext context) {
  return SingleChildScrollView(
    // Use SingleChildScrollView to prevent overflow if content is long
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[700],
          backgroundImage: NetworkImage(
            authService.value.currentUser?.photoURL ??
                'https://static.vecteezy.com/system/resources/previews/003/715/527/non_2x/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-vector.jpg',
          ),
        ),
        SizedBox(height: 15),
        ValueListenableBuilder(
          valueListenable: authService,
          builder: (context, AuthService auth, _) {
            return Text(
              auth.currentUser?.displayName ?? 'Usuário',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            );
          },
        ),
        SizedBox(height: 30),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit_note),
          title: Text('Editar Perfil'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, Rotas.profile_edit);
          },
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notificações'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.lock_outline),
          title: Text('Privacidade'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Configurações da Conta'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.redAccent),
          title: Text('Sair', style: TextStyle(color: Colors.redAccent)),
          onTap: () async {
            try {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Sair'),
                  content: Text('Você tem certeza que deseja sair?'),
                  actions: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text('Sair'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await AuthService().signOut();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Rotas.home,
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              );
            } catch (e) {
              print(e.toString());
            }
          },
        ),
      ],
    ),
  );
}



