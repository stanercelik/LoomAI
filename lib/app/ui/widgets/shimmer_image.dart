import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerImage> createState() => _ShimmerImageState();
}

class _ShimmerImageState extends State<ShimmerImage> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.imageUrl,
          fit: widget.fit ?? BoxFit.cover,
          width: widget.width,
          height: widget.height,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              _isLoading = false;
              return child;
            }
            return _buildShimmer();
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.error_outline, color: Colors.red),
            );
          },
        ),
        if (_isLoading) _buildShimmer(),
      ],
    );
  }

  Widget _buildShimmer() {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}