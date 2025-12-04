// lib/pages/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../api/pexels_api.dart';
import '../widgets/fancy_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _ctl = TextEditingController();
  final ScrollController _sc = ScrollController();
  List<Map<String, dynamic>> _photos = [];
  int _page = 1;
  bool _loading = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels > _sc.position.maxScrollExtent - 600 && !_loading) {
        _search(loadMore: true);
      }
    });
  }

  Future<void> _search({bool loadMore = false}) async {
    if (!loadMore) {
      _photos = [];
      _page = 1;
    }
    if (_query.trim().isEmpty) return;
    setState(() => _loading = true);
    final res = await PexelsApi.search(_query, page: _page);
    setState(() {
      _photos.addAll(res);
      _page++;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctl,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(hintText: 'Search wallpapers...'),
          onSubmitted: (s) {
            _query = s;
            _search();
          },
        ),
      ),
      body: _photos.isEmpty
          ? Center(child: _loading ? const CircularProgressIndicator() : const Text('Type and press search'))
          : Padding(
              padding: const EdgeInsets.all(12),
              child: MasonryGridView.count(
                controller: _sc,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: _photos.length + (_loading ? 2 : 0),
                itemBuilder: (context, i) {
                  if (i >= _photos.length) return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
                  final photo = _photos[i];
                  return FancyTile(photo: photo, index: i);
                },
              ),
            ),
    );
  }
}
