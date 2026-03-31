import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// 全螢幕圖片檢視器
/// 支援雙指縮放、拖曳平移，以及點擊關閉。
class FullscreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;

  const FullscreenImageViewer({
    super.key,
    required this.imageUrl,
    this.heroTag,
  });

  /// 以淡入淡出 + Hero 動畫的方式開啟全螢幕圖片。
  static void open(BuildContext context, String imageUrl, {String? heroTag}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullscreenImageViewer(imageUrl: imageUrl, heroTag: heroTag);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformController =
      TransformationController();
  late AnimationController _animController;
  Animation<Matrix4>? _animMatrix;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 250),
        )..addListener(() {
          if (_animMatrix != null) {
            _transformController.value = _animMatrix!.value;
          }
        });
  }

  @override
  void dispose() {
    _animController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    final position = _doubleTapDetails?.localPosition ?? Offset.zero;
    final currentScale = _transformController.value.getMaxScaleOnAxis();

    Matrix4 endMatrix;
    if (currentScale > 1.05) {
      // 已經放大 → 回原點
      endMatrix = Matrix4.identity();
    } else {
      // 放大到 3 倍
      endMatrix = Matrix4.identity();
      endMatrix.setEntry(0, 3, -position.dx * 2);
      endMatrix.setEntry(1, 3, -position.dy * 2);
      endMatrix.setEntry(0, 0, 3.0);
      endMatrix.setEntry(1, 1, 3.0);
    }

    _animMatrix =
        Matrix4Tween(begin: _transformController.value, end: endMatrix).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = Image.asset(
      widget.imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (ctx, err, stack) => Center(
        child: Icon(Icons.broken_image, color: AppColors.textMuted, size: 60),
      ),
    );

    final content = widget.heroTag != null
        ? Hero(tag: widget.heroTag!, child: imageWidget)
        : imageWidget;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 可縮放的圖片
          GestureDetector(
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 0.5,
              maxScale: 5.0,
              child: Center(child: content),
            ),
          ),
          // 關閉按鈕
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
                ),
                child: const Icon(
                  Icons.close,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
          // 放大提示
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.pinch_outlined,
                      color: AppColors.textMuted,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '雙指縮放  ·  雙擊放大  ·  點擊 ✕ 關閉',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
