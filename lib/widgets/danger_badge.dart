import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// 生存難度徽章元件（對應後室 Wiki 的等級分類系統）
/// 等級 0 ~ 5、宜居、死區、等待分級
/// [isEntity] 為 true 時，顯示實體的危險程度標籤。
class DangerBadge extends StatelessWidget {
  final String dangerLevel;
  final bool isEntity;

  const DangerBadge({
    super.key,
    required this.dangerLevel,
    this.isEntity = false,
  });

  // Wiki 配色方案（參照 Backrooms Wiki CSS 的等級顏色）
  static const _classColors = {
    'class0': Color(0xFFF7E375), // 等級 0 - 黃綠
    'class1': Color(0xFFFFC90E), // 等級 1 - 金黃
    'class2': Color(0xFFF59C00), // 等級 2 - 橘黃
    'class3': Color(0xFFF95A00), // 等級 3 - 橘紅
    'class4': Color(0xFFFE1701), // 等級 4 - 紅
    'class5': Color(0xFFAF0606), // 等級 5 - 深紅
    'deadzone': Color(0xFF2C0D0C), // 死區
    'habitable': Color(0xFF1A806F), // 宜居
    'pending': Color(0xFFB6B6B6), // 等待分級
  };

  Color get _color {
    return _classColors[dangerLevel] ?? AppColors.textMuted;
  }

  String get _label {
    if (isEntity) {
      switch (dangerLevel) {
        case 'class0':
          return '無威脅';
        case 'class1':
          return '低危';
        case 'class2':
          return '注意';
        case 'class3':
          return '危險';
        case 'class4':
          return '高危';
        case 'class5':
          return '極度危險';
        case 'deadzone':
          return '致命';
        default:
          return '未知';
      }
    } else {
      switch (dangerLevel) {
        case 'class0':
          return '等級 0';
        case 'class1':
          return '等級 1';
        case 'class2':
          return '等級 2';
        case 'class3':
          return '等級 3';
        case 'class4':
          return '等級 4';
        case 'class5':
          return '等級 5';
        case 'deadzone':
          return '死區';
        case 'habitable':
          return '宜居';
        case 'pending':
          return '等待分級';
        default:
          return '未知';
      }
    }
  }

  IconData get _icon {
    switch (dangerLevel) {
      case 'class0':
      case 'class1':
      case 'habitable':
        return Icons.check_circle_outline;
      case 'class2':
        return Icons.warning_amber_outlined;
      case 'class3':
      case 'class4':
        return Icons.dangerous_outlined;
      case 'class5':
      case 'deadzone':
        return Icons.dangerous;
      case 'pending':
        return Icons.help_outline;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    // 深色背景需要的前景色亮度調整
    final fgColor = dangerLevel == 'deadzone' ? const Color(0xFFFF4444) : color;
    final bgColor = dangerLevel == 'deadzone' ? const Color(0xFF4A1010) : color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bgColor.withValues(alpha: 0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: fgColor, size: 13),
          const SizedBox(width: 5),
          Text(
            _label,
            style: TextStyle(
              color: fgColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
