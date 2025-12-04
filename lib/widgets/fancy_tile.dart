// lib/widgets/fancy_tile.dart
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import '../pages/full_screen_page.dart';

class FancyTile extends StatefulWidget {
  final Map<String, dynamic> photo;
  final int index;
  const FancyTile({super.key, required this.photo, required this.index});

  @override
  State<FancyTile> createState() => _FancyTileState();
}

class _FancyTileState extends State<FancyTile> {
  double _angleX = 0.0;
  double _angleY = 0.0;
  double _scale = 1.0;

  void _onPointerMove(PointerEvent e, Size size) {
    final local = (e.localPosition);
    final dx = (local.dx - size.width / 2) / (size.width / 2);
    final dy = (local.dy - size.height / 2) / (size.height / 2);
    setState(() {
      _angleY = dx * 0.08;
      _angleX = -dy * 0.08;
      _scale = 1.02;
    });
  }

  void _onPointerExit(PointerEvent e) {
    setState(() {
      _angleX = 0;
      _angleY = 0;
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final src = widget.photo['src']?['large'] ?? widget.photo['src']?['large2x'] ?? widget.photo['src']?['medium'];
    final id = widget.photo['id'].toString();
    return Listener(
      onPointerHover: (_) {},
      child: MouseRegion(
        onExit: _onPointerExit,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 650),
              reverseTransitionDuration: const Duration(milliseconds: 450),
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(opacity: animation, child: FullScreenPage(image: widget.photo, tag: 'hero_$id'));
              },
            ));
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest;
              return Listener(
                onPointerMove: (e) => _onPointerMove(e, size),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(_angleX)
                    ..rotateY(_angleY)
                    ..scale(_scale),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 20, offset: const Offset(0,10))],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'hero_$id',
                          child: CachedNetworkImage(
                            imageUrl: src ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (c, s) => Container(color: Colors.grey[900], height: 200),
                            errorWidget: (c, s, e) => const SizedBox(height: 200, child: Center(child: Icon(Icons.broken_image))),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 10,
                          right: 10,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.photo['photographer'] ?? '',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [
                                    Shadow(blurRadius: 6, color: Colors.black),
                                  ]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  const Icon(Icons.download_rounded, size: 16),
                                  const SizedBox(width: 6),
                                  Text((widget.photo['width'] ?? 0).toString()),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
