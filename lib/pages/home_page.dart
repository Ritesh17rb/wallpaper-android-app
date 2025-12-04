// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../api/pexels_api.dart';
import '../widgets/fancy_tile.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _photos = [];
  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;
  String _activeCategory = 'All';

  final List<String> _categories = ['All', 'Nature', 'Amoled', 'Abstract', 'Space', 'Cars', 'Anime'];

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 700 && !_loading && _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore({bool refresh = false}) async {
    if (_loading) return;
    setState(() => _loading = true);
    if (refresh) {
      _page = 1;
      _photos = [];
      _hasMore = true;
    }
    try {
      List<Map<String, dynamic>> fetched;
      if (_activeCategory == 'All') {
        fetched = await PexelsApi.curated(page: _page);
      } else {
        fetched = await PexelsApi.search(_activeCategory, page: _page);
      }
      setState(() {
        _photos.addAll(fetched);
        _page++;
        if (fetched.length < 10) _hasMore = false;
      });
    } catch (e) {
      // ignore for now
    }
    setState(() => _loading = false);
  }

  Future<void> _onRefresh() async {
    await _loadMore(refresh: true);
  }

  void _onCategoryTap(String cat) {
    setState(() {
      _activeCategory = cat;
      _photos = [];
      _page = 1;
      _hasMore = true;
    });
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 12;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App header
            Padding(
              padding: EdgeInsets.fromLTRB(16, topPadding - 12, 16, 8),
              child: Row(
                children: [
                  const Text('Snakey', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 6),
                  Text('Walls', style: TextStyle(fontSize: 26, color: Theme.of(context).colorScheme.primary)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search_outlined),
                    onPressed: () async {
                      final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
                      if (res is Map<String, dynamic>) {
                        // open full screen (handled via route in Search)
                      }
                    },
                  ),
                ],
              ),
            ),

            // Category chips
            SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final active = cat == _activeCategory;
                  return GestureDetector(
                    onTap: () => _onCategoryTap(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        gradient: active
                            ? LinearGradient(colors: [Theme.of(context).colorScheme.primary, Colors.pinkAccent])
                            : null,
                        color: active ? null : Colors.white12,
                        boxShadow: active
                            ? [BoxShadow(color: Colors.purple.withOpacity(0.18), blurRadius: 14, offset: const Offset(0,6))]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Icon(active ? Icons.auto_awesome : Icons.tag, size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(cat, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    itemCount: _photos.length + (_loading ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _photos.length) {
                        return Center(child: SizedBox(height: 120, child: Center(child: CircularProgressIndicator(strokeWidth: 2.2))));
                      }
                      final photo = _photos[index];
                      return FancyTile(photo: photo, index: index);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
