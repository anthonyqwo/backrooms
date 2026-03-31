import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/inventory_manager.dart';
import '../data/backrooms_data.dart';
import '../widgets/section_header.dart';
import 'object_detail_page.dart';

/// 生存包頁面（物資管理中心）
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'SURVIVOR KIT',
          style: GoogleFonts.spaceMono(
            color: AppColors.primary,
            fontSize: 18,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_outlined, color: AppColors.textMuted),
            onPressed: () => _confirmClear(context),
            tooltip: '清空生存包',
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<Map<String, int>>(
          valueListenable: InventoryManager.instance.inventory,
          builder: (context, inv, child) {
            final itemIds = InventoryManager.instance.possessedItemIds;

            if (itemIds.isEmpty) {
              return _EmptyInventory();
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: itemIds.length,
              itemBuilder: (context, index) {
                final id = itemIds[index];
                final count = inv[id]!;
                final object = BackroomsData.objects.firstWhere((o) => o.id == id);

                return _InventoryItem(
                  object: object,
                  count: count,
                  onAdd: () => InventoryManager.instance.addItem(id),
                  onRemove: () => InventoryManager.instance.removeItem(id),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ObjectDetailPage(object: object),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          '拋棄所有物資？',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
        ),
        content: Text(
          '確要清空目前的生存包嗎？在後室中丟失物資通常意味著死亡。',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              '取消',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              InventoryManager.instance.clear();
              Navigator.pop(ctx);
            },
            child: Text(
              '確認拋棄',
              style: TextStyle(color: AppColors.dangerHigh),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyInventory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: AppColors.textMuted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          Text(
            '生存包空空如也',
            style: GoogleFonts.notoSans(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '你沒有任何可用於生存的物資。',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
            ),
            child: const Text('返回搜尋物資'),
          ),
        ],
      ),
    );
  }
}

class _InventoryItem extends StatelessWidget {
  final BackroomsObject object;
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _InventoryItem({
    required this.object,
    required this.count,
    required this.onAdd,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  object.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      object.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      object.nameEn,
                      style: GoogleFonts.spaceMono(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    color: AppColors.textMuted,
                  ),
                  Text(
                    '$count',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
