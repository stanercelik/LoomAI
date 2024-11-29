import 'dart:math';
import 'package:flutter/material.dart';

class CarpetAnimation extends StatefulWidget {
  final AxisDirection direction;

  const CarpetAnimation({
    super.key, 
    this.direction = AxisDirection.left,
  });

  @override
  _CarpetAnimationState createState() => _CarpetAnimationState();
}

class _CarpetAnimationState extends State<CarpetAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final ScrollController _scrollController;

  List<String> carpetImages = [];
  final double carpetWidth = 200;
  final int numberOfCarpets = 5;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadCarpetImages();
    _initAnimation();
  }

  void _loadCarpetImages() {
    int totalCarpetImages = 7;
    List<String> allCarpetImages = List.generate(totalCarpetImages, (index) {
      return 'assets/images/carpets/carpet${index + 1}.jpeg';
    });

    allCarpetImages.shuffle(Random());
    carpetImages = allCarpetImages.take(numberOfCarpets).toList();
    carpetImages = [...carpetImages, ...carpetImages];
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: carpetWidth * (carpetImages.length / 2),
    ).animate(_controller);

    _animation.addListener(() {
      if (_scrollController.hasClients && mounted) {
        try {
          double offset = _animation.value;
          if (widget.direction == AxisDirection.left) {
            offset = _scrollController.position.maxScrollExtent - offset;
          }
          _scrollController.jumpTo(
            offset % _scrollController.position.maxScrollExtent,
          );
        } catch (e) {
          print('Animation error: $e');
        }
      }
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRect(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: carpetImages.map((imagePath) {
                return SizedBox(
                  width: carpetWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}