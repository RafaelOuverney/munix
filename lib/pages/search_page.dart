import 'package:flutter/material.dart';
import 'package:munix/models/track_model.dart';
import 'package:munix/services/jamendo_service.dart';
import 'package:munix/services/search_history_service.dart';

class SearchPage extends StatefulWidget {
  final Function(Track, int, List<Track>) onTrackSelected;

  const SearchPage({Key? key, required this.onTrackSelected}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchHistoryService _historyService = SearchHistoryService();
  final JamendoService _jamendoService = JamendoService();
  List<String> _searchHistory = [];
  List<Track> _searchResults = [];
  List<Track> _recommendedTracks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadRecommendedTracks();
  }

  Future<void> _loadHistory() async {
    _searchHistory = await _historyService.getSearchHistory();
    setState(() {});
  }

  Future<void> _loadRecommendedTracks() async {
    setState(() => _isLoading = true);
    try {
      _recommendedTracks = await _jamendoService.fetchTopTracks();
    } catch (e) {
      print("Error loading top tracks: $e");
    }
    setState(() => _isLoading = false);
  }

  Future<void> _handleSearch() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final results = await _jamendoService.searchTracks(query);
      await _historyService.addSearch(query);
      setState(() {
        _searchResults = results;
        _loadHistory();
      });
    } catch (e) {
      print("Error searching tracks: $e");
    }
    setState(() => _isLoading = false);
  }

  Widget _buildRecommendedTracks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Mais tocadas',
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _recommendedTracks.length,
            itemBuilder: (context, index) {
              final track = _recommendedTracks[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      track.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    track.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    track.artistName,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  onTap: () => widget.onTrackSelected(track, index, _recommendedTracks),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'O que você quer ouvir?',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchResults = [];
                              _loadRecommendedTracks();
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onSubmitted: (_) => _handleSearch(),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isNotEmpty
                      ? _buildTrackList(_searchResults)
                      : _searchController.text.isEmpty
                          ? Column(
                              children: [
                                if (_searchHistory.isNotEmpty) _buildSearchHistory(),
                                Expanded(child: _buildRecommendedTracks()),
                              ],
                            )
                          : _buildRecommendedTracks(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
      return _buildRecommendedTracks();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Buscas recentes',
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _historyService.clearHistory();
                  _loadHistory();
                },
                child: Text(
                  'Limpar',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.history, color: Colors.grey[400]),
                title: Text(
                  _searchHistory[index],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _searchController.text = _searchHistory[index];
                  _handleSearch();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrackList(List<Track> tracks) {
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                track.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              track.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              track.artistName,
              style: TextStyle(color: Colors.grey[400]),
            ),
            onTap: () => widget.onTrackSelected(track, index, tracks),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
