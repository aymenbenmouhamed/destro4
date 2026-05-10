import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingSkeletonWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppTheme.outlineVariant,
                AppTheme.surfaceVariant,
                AppTheme.outlineVariant,
              ],
              stops: [
                (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                _shimmerAnimation.value.clamp(0.0, 1.0),
                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DashboardSkeletonWidget extends StatelessWidget {
  const DashboardSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: LoadingSkeletonWidget(
                  width: double.infinity,
                  height: 100,
                  borderRadius: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LoadingSkeletonWidget(
                  width: double.infinity,
                  height: 100,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LoadingSkeletonWidget(
                  width: double.infinity,
                  height: 100,
                  borderRadius: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LoadingSkeletonWidget(
                  width: double.infinity,
                  height: 100,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const LoadingSkeletonWidget(width: 160, height: 20, borderRadius: 6),
          const SizedBox(height: 16),
          const LoadingSkeletonWidget(
            width: double.infinity,
            height: 180,
            borderRadius: 12,
          ),
          const SizedBox(height: 24),
          const LoadingSkeletonWidget(width: 140, height: 20, borderRadius: 6),
          const SizedBox(height: 16),
          ...List.generate(
            4,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: LoadingSkeletonWidget(
                width: double.infinity,
                height: 72,
                borderRadius: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
