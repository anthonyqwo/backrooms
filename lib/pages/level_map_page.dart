import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../data/backrooms_data.dart';
import '../pages/level_detail_page.dart';

/// 層級連接圖頁面
/// 以視覺化方式呈現各層級之間的連結關係。
class LevelMapPage extends StatelessWidget {
  const LevelMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '層級連接圖',
          style: GoogleFonts.creepster(
            color: AppColors.primary,
            fontSize: 22,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 說明
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '此圖根據已確認的出入口資料繪製。點擊節點可查看層級詳情。',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 層級節點列表
              ...BackroomsData.levels.map((level) => _LevelNode(level: level)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// 單個層級節點及其連線
class _LevelNode extends StatelessWidget {
  final Level level;

  const _LevelNode({required this.level});

  /// 從 exitMethods 中提取出目標層級 ID
  List<_Connection> _parseConnections() {
    final connections = <_Connection>[];
    final allText = [...level.exitMethods, ...level.accessMethods].join(' ');

    // 匹配 "Level X" 模式
    final regex = RegExp(r'Level\s+(\d+)');
    final matches = regex.allMatches(allText);
    final seenIds = <int>{};

    for (final match in matches) {
      final targetId = int.tryParse(match.group(1) ?? '');
      if (targetId != null &&
          targetId != level.id &&
          !seenIds.contains(targetId)) {
        seenIds.add(targetId);
        // 判斷方向
        final isInput = level.accessMethods.any(
          (m) => m.contains('Level $targetId'),
        );
        final isOutput = level.exitMethods.any(
          (m) => m.contains('Level $targetId'),
        );

        String direction;
        if (isInput && isOutput) {
          direction = '雙向';
        } else if (isInput) {
          direction = '來自';
        } else {
          direction = '通往';
        }
        connections.add(_Connection(targetId: targetId, direction: direction));
      }
    }
    return connections;
  }

  Color _dangerColor() {
    switch (level.dangerLevel) {
      case 'safe':
        return AppColors.dangerSafe;
      case 'caution':
        return AppColors.dangerMedium;
      case 'danger':
        return const Color(0xFFE64A19);
      case 'extreme':
        return AppColors.dangerExtreme;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final connections = _parseConnections();
    final color = _dangerColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          // 層級節點
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LevelDetailPage(level: level)),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  // 層級 ID 圓形標記
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.2),
                      border: Border.all(color: color, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '${level.id}',
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 層級資訊
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level.name,
                          style: GoogleFonts.creepster(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          level.subtitle,
                          style: GoogleFonts.spaceMono(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 連接數量
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${connections.length} 連接',
                      style: GoogleFonts.spaceMono(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          // 連線指示
          if (connections.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Column(
                children: connections.map((conn) {
                  final targetLevel = BackroomsData.levels.where(
                    (l) => l.id == conn.targetId,
                  );
                  final targetName = targetLevel.isNotEmpty
                      ? targetLevel.first.name
                      : '未知層級';

                  IconData icon;
                  Color lineColor;
                  switch (conn.direction) {
                    case '雙向':
                      icon = Icons.swap_vert;
                      lineColor = AppColors.primary;
                      break;
                    case '來自':
                      icon = Icons.arrow_downward;
                      lineColor = AppColors.dangerSafeLight;
                      break;
                    default:
                      icon = Icons.arrow_upward;
                      lineColor = AppColors.dangerHigh;
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        // 連線
                        Container(
                          width: 2,
                          height: 16,
                          color: lineColor.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 10),
                        Icon(icon, color: lineColor, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${conn.direction} Level ${conn.targetId}',
                          style: GoogleFonts.spaceMono(
                            color: lineColor,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          targetName,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _Connection {
  final int targetId;
  final String direction; // '通往' | '來自' | '雙向'

  const _Connection({required this.targetId, required this.direction});
}
