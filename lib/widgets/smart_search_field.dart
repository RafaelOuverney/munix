import 'package:flutter/material.dart';
import 'package:munix/services/jamendo_service.dart';
import 'package:munix/models/track_model.dart';

class SmartSearchField extends StatefulWidget {
  final Function(Track) onTrackSelected;
  final String hintText;

  const SmartSearchField({
    Key? key,
    required this.onTrackSelected,
    this.hintText = 'Buscar música...',
  }) : super(key: key);

  @override
  State<SmartSearchField> createState() => _SmartSearchFieldState();
}

class _SmartSearchFieldState extends State<SmartSearchField> {
  final TextEditingController _controller = TextEditingController();
  List<Track> _suggestions = [];
  bool _showSuggestions = false;

  Future<void> _searchTracks(String query) async {
    if (query.length < 2) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    try {
      final tracks = await JamendoService().searchTracks(query);
      setState(() {
        _suggestions = tracks.take(5).toList();
        _showSuggestions = true;
      });
    } catch (e) {
      print('Error searching tracks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _suggestions = [];
                        _showSuggestions = false;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: _searchTracks,
        ),
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final track = _suggestions[index];
                return ListTile(
                  leading: Image.network(
                    track.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  title: Text(track.name),
                  subtitle: Text(track.artistName),
                  onTap: () {
                    widget.onTrackSelected(track);
                    _controller.text = track.name;
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
