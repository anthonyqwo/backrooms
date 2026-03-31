import 'package:flutter/material.dart';

/// 生存包（物資管理）管理器
/// 使用 ValueNotifier 提供簡單的狀態管理
class InventoryManager {
  InventoryManager._();

  static final InventoryManager instance = InventoryManager._();

  /// 格式: { '物資ID': 數量 }
  final ValueNotifier<Map<String, int>> _inventory =
      ValueNotifier<Map<String, int>>({});

  ValueNotifier<Map<String, int>> get inventory => _inventory;

  /// 新增物資
  void addItem(String id, {int count = 1}) {
    final current = Map<String, int>.from(_inventory.value);
    current[id] = (current[id] ?? 0) + count;
    _inventory.value = current;
  }

  /// 移除/減少物資
  void removeItem(String id, {int count = 1}) {
    final current = Map<String, int>.from(_inventory.value);
    if (current.containsKey(id)) {
      final newCount = (current[id] ?? 0) - count;
      if (newCount <= 0) {
        current.remove(id);
      } else {
        current[id] = newCount;
      }
      _inventory.value = current;
    }
  }

  /// 檢查特定物資數量
  int getItemCount(String id) {
    return _inventory.value[id] ?? 0;
  }

  /// 獲取所有持有的物資 ID 列表（數量 > 0）
  List<String> get possessedItemIds => _inventory.value.keys.toList();

  /// 清空生存包
  void clear() {
    _inventory.value = {};
  }
}
