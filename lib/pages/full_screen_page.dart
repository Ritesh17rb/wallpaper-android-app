// lib/pages/full_screen_page.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart'; // ⭐ Modern gallery saver

class FullScreenPage extends StatelessWidget {
  final Map<String, dynamic> image;
  final String tag;
  const FullScreenPage({super.key, required this.image, required this.tag});

  @override
  Widget build(BuildContext context) {
    final url = image['src']?['large2x'] ?? image['src']?['original'] ?? '';
    final photographer = image['photographer'] ?? '';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(photographer),
        actions: [
          IconButton(onPressed: () => _download(context, url), icon: const Icon(Icons.download)),
          IconButton(onPressed: () => _share(url), icon: const Icon(Icons.share)),
          FavoriteIcon(image: image),
        ],
      ),
      body: Hero(
        tag: tag,
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(url),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () => _setWallpaper(context, url),
                  icon: const Icon(Icons.wallpaper),
                  label: const Text('Set as Wallpaper'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _share(String url) {
    Share.share(url);
  }

  // ⭐ Download and save using gal (AGP 8 compatible)
  Future<void> _download(BuildContext context, String url) async {
    if (url.isEmpty) return;

    // Request permission (gal handles most cases)
    if (!(await Gal.hasAccess())) {
      await Gal.requestAccess();
    }

    try {
      // Download bytes
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(response.data);

      // Save to gallery
      await Gal.putImageBytes(
        bytes,
        album: "Wallpapers", // Optional custom album
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Saved to gallery")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Download failed")));
    }
  }

  Future<void> _setWallpaper(BuildContext context, String url) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Use Android device to set wallpaper")));
  }
}

class FavoriteIcon extends StatefulWidget {
  final Map<String, dynamic> image;
  const FavoriteIcon({super.key, required this.image});
  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  late Box _box;
  bool _fav = false;
  @override
  void initState() {
    super.initState();
    _box = Hive.box('favorites');
    _fav = _box.containsKey(widget.image['id'].toString());
  }

  void _toggle() {
    final id = widget.image['id'].toString();
    if (_fav) {
      _box.delete(id);
    } else {
      _box.put(id, widget.image);
    }
    setState(() => _fav = !_fav);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggle,
      icon: Icon(
        _fav ? Icons.favorite : Icons.favorite_border,
        color: _fav ? Colors.redAccent : Colors.white,
      ),
    );
  }
}
