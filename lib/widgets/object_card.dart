import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../data/backrooms_data.dart';
import '../widgets/danger_badge.dart';

/// 物資卡片元件（用於首頁列表）
class ObjectCard extends StatelessWidget {
  final BackroomsObject object;
  final VoidCallback onTap;

  const ObjectCard({super.key, required this.object, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // 背景圖片（在右側 40% 的區域顯示部分圖片）
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 150,
                child: Hero(
                  tag: 'obj_img_${object.id}',
                  child: Image.asset(
                    object.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) =>
                        Container(color: AppColors.surface),
                  ),
                ),
              ),
              // 暗色漸層遮罩 (從左到右)
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF1A1208),
                      Color(0xDD1A1208),
                      Color(0x661A1208),
                      Color(0x001A1208)
                    ],
                    stops: [0.0, 0.4, 0.75, 1.0],
                  ),
                ),
              ),
              // 內容
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          object.objectClass.toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            color: AppColors.primary,
                            fontSize: 10,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 這裡複用 DangerBadge 但傳入 object 的 dangerLevel
                        DangerBadge(dangerLevel: object.dangerLevel),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      object.name,
                      style: GoogleFonts.creepster(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        object.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 右小角裝飾圖示
              Positioned(
                right: 12,
                bottom: 12,
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.primary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
