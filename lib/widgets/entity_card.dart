import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../data/backrooms_data.dart';
import '../widgets/danger_badge.dart';

/// 實體卡片元件（用於首頁列表）
class EntityCard extends StatelessWidget {
  final Entity entity;
  final VoidCallback onTap;

  const EntityCard({super.key, required this.entity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            // 實體圖片（圓形）
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                entity.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context2, error2, stack) => CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.surface,
                  child: Icon(
                    Icons.visibility_off,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 文字內容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entity.name,
                          style: GoogleFonts.creepster(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      DangerBadge(
                        dangerLevel: entity.dangerLevel,
                        isEntity: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entity.nameEn,
                    style: GoogleFonts.spaceMono(
                      color: AppColors.primary,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entity.description,
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
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
