import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/backrooms_data.dart';
import '../pages/level_detail_page.dart';

/// 支援將文本中「Level X」轉換為可點擊連結的元件
class LevelLinkText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const LevelLinkText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    // 匹配 "Level 1", "Level 0", "Level 283" 等字眼
    final RegExp levelRegex = RegExp(r'Level\s+\d+', caseSensitive: false);
    final matches = levelRegex.allMatches(text);

    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      final matchedText = match.group(0)!;
      // 提取層級數字
      final idMatch = RegExp(r'\d+').firstMatch(matchedText);
      final idStr = idMatch?.group(0);
      final levelId = idStr != null ? int.tryParse(idStr) : null;

      // 檢查層級是否存在於我們的靜態資料庫中
      Level? targetLevel;
      if (levelId != null) {
        final matchingLevels = BackroomsData.levels.where(
          (l) => l.id == levelId,
        );
        targetLevel = matchingLevels.isNotEmpty ? matchingLevels.first : null;
      }

      if (targetLevel != null) {
        spans.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // 跳轉至該層級的詳情頁
                final l = targetLevel;
                if (l != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelDetailPage(level: l),
                    ),
                  );
                }
              },
          ),
        );
      } else {
        // 如果該層級存在於文本但開發尚未收錄，使用不同顏色或僅顯示斜體，且不可點擊
        spans.add(
          TextSpan(
            text: matchedText,
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      }
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return RichText(
      text: TextSpan(
        style: style ?? const TextStyle(color: Colors.white), // 預設字體顏色
        children: spans,
      ),
    );
  }
}
