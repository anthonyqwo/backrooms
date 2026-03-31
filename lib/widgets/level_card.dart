import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../data/backrooms_data.dart';
import '../widgets/danger_badge.dart';

/// 層級卡片元件（用於首頁列表）
class LevelCard extends StatelessWidget {
  final Level level;
  final VoidCallback onTap;

  const LevelCard({super.key, required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Stack(
          children: [
            // 背景圖片
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                level.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context2, error2, stack) =>
                    Container(color: AppColors.surface),
              ),
            ),
            // 暗色漸層遮罩
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0x001A1208), Color(0xDD1A1208)],
                ),
              ),
            ),
            // 內容
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'LEVEL ${level.id}',
                        style: GoogleFonts.spaceMono(
                          color: AppColors.primary,
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DangerBadge(dangerLevel: level.dangerLevel),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.name,
                        style: GoogleFonts.creepster(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        level.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 右側箭頭
            Positioned(
              right: 16,
              bottom: 16,
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
