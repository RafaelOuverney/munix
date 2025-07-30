import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shake/shake.dart';
import 'package:munix/services/jamendo_service.dart';
import 'package:munix/models/track_model.dart';

class DiscoverPage extends StatefulWidget {
  final Function(Track, int, List<Track>) onTrackSelected;

  const DiscoverPage({Key? key, required this.onTrackSelected}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  List<Track> _nearbyTracks = [];
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initShakeDetector();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;

      final position = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = position);
      
      _loadNearbyMusic();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _initShakeDetector() {
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        _discoverRandomMusic();
      } as PhoneShakeCallback,
    );
  }

  Future<void> _loadNearbyMusic() async {
    try {
      final tracks = await JamendoService().fetchPopularTracks();
      setState(() => _nearbyTracks = tracks.take(5).toList());
    } catch (e) {
      print('Error loading nearby music: $e');
    }
  }

  Future<void> _discoverRandomMusic() async {
    try {
      final tracks = await JamendoService().fetchTopTracks();
      if (tracks.isNotEmpty) {
        final randomTrack = tracks[DateTime.now().millisecond % tracks.length];
        widget.onTrackSelected(randomTrack, 0, [randomTrack]);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎵 Descoberta: ${randomTrack.name}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error discovering music: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: _currentPosition != null
              ? GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('current'),
                      position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      infoWindow: const InfoWindow(title: 'Você está aqui'),
                    ),
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '🎵 Músicas populares na sua região',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _nearbyTracks.length,
            itemBuilder: (context, index) {
              final track = _nearbyTracks[index];
              return ListTile(
                leading: Image.network(track.image, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(track.name),
                subtitle: Text(track.artistName),
                onTap: () => widget.onTrackSelected(track, index, _nearbyTracks),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.vibration, size: 40, color: Colors.blue),
              const Text('Balançar para descobrir música aleatória!'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _discoverRandomMusic,
                child: const Text('Descobrir Agora'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }
}