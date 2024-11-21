
import 'dart:math';

import 'package:flutter/material.dart';

class CarpetAnimation extends StatefulWidget {
  final AxisDirection direction;

  const CarpetAnimation({Key? key, required this.direction}) : super(key: key);

  @override
  _CarpetAnimationState createState() => _CarpetAnimationState();
}

class _CarpetAnimationState extends State<CarpetAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final ScrollController _scrollController;

  List<String> carpetImages = [];
  final double carpetWidth = 200; // Adjust based on image dimensions
  final int numberOfCarpets = 5;

  @override
  void initState() {
    super.initState();

    // Initialize the scroll controller
    _scrollController = ScrollController();

    // Load carpet images
    _loadCarpetImages();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 25), // Adjust the speed as needed
      vsync: this,
    );

    // Initialize the animation
    _animation = Tween<double>(
      begin: 0.0,
      end: carpetWidth * (carpetImages.length / 2),
    ).animate(_controller)
      ..addListener(() {
        if (_scrollController.hasClients) {
          double offset = _animation.value;
          if (widget.direction == AxisDirection.left) {
            offset = _scrollController.position.maxScrollExtent - offset;
          }
          _scrollController.jumpTo(
              offset % _scrollController.position.maxScrollExtent);
        }
      });

    // Repeat the animation indefinitely
    _controller.repeat();
  }

  void _loadCarpetImages() {
    int totalCarpetImages = 7; // Adjust based on your actual number of images

    // Generate a list of image asset paths
    List<String> allCarpetImages = List.generate(totalCarpetImages, (index) {
      return 'assets/images/carpets/carpet${index + 1}.jpeg';
    });

    // Randomly select 5 different carpets
    allCarpetImages.shuffle(Random());
    carpetImages = allCarpetImages.take(numberOfCarpets).toList();

    // Duplicate the list to enable seamless scrolling
    carpetImages = [...carpetImages, ...carpetImages];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
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
            stops: [0.0, 0.5, 0.5, 1.0],
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
    );
  }
}