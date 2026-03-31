# 後室 Backrooms App

> 🕳️ 倖存者資料庫 · SURVIVOR DATABASE

基於 [Backrooms 中文維基](https://backrooms-wiki-cn.wikidot.com/) 的 Flutter 內容型應用，提供後室層級百科、實體圖鑑，以及沉浸式深色主題 UI。

---

## ✨ 功能特色

### 📚 層級百科
- 收錄 **Level 0 – Level 12** 共 13 個層級的詳細資料
- 包含生存難度、環境描述、進入/逃離方式、已知實體等完整資訊
- 所有層級圖片均從 [Backrooms Wiki](https://backrooms-wiki-cn.wikidot.com/) 下載至本地

### 👁️ 實體圖鑑
- 收錄 5 種主要實體：**笑魘 (Smiler)**、**無面靈 (Faceling)**、**肢團 (Clump)**、**獵犬 (Hound)**、**竊皮者 (Skin-Stealer)**
- 每種實體含完整描述、出沒層級、倖存者守則
- 實體使用專屬危險程度標籤（安全 / 注意 / 危險 / 極度危險）

### 🔗 智慧互連導航
- 文內自動識別「Level X」字串，轉換為可點擊的層級連結
- 點擊連結直接跳轉至對應層級詳情頁
- 導航堆疊優化：所有詳情頁右上角提供「🏡 首頁」快捷按鈕，一鍵回首頁

### 🔍 圖片全螢幕檢視
- 詳情頁 Hero 圖片支援**點擊放大**
- 全螢幕檢視器支援：
  - 雙指縮放（0.5x – 5x）
  - 雙擊快速放大 / 還原
  - Hero 動畫過渡
  - 操作提示與關閉按鈕

### 🎨 沉浸式設計
- 深色主題，使用暖色調色盤（金棕色系）
- Creepster 恐怖風格標題字體
- Space Mono 等寬字體用於分類標籤
- 漸層遮罩、卡片式佈局、微動畫效果

---

## 🗂️ 專案結構

```
lib/
├── core/
│   └── app_colors.dart           # 全域色彩定義
├── data/
│   └── backrooms_data.dart       # 層級 & 實體靜態資料
├── pages/
│   ├── home_page.dart            # 首頁（Hero 橫幅 + 列表）
│   ├── level_detail_page.dart    # 層級詳情頁
│   └── entity_detail_page.dart   # 實體詳情頁
├── widgets/
│   ├── level_card.dart           # 層級卡片元件
│   ├── entity_card.dart          # 實體卡片元件
│   ├── danger_badge.dart         # 危險等級徽章（支援層級/實體雙模式）
│   ├── section_header.dart       # 區塊標題
│   ├── info_item.dart            # 資訊條目
│   ├── level_link_text.dart      # 自動連結文字元件
│   └── fullscreen_image_viewer.dart  # 全螢幕圖片檢視器
├── main.dart                     # App 進入點
assets/
└── images/
    ├── hero.png                  # 首頁橫幅圖
    ├── level_0.jpg ~ level_12.*  # 各層級代表圖片
    └── entity_*.jpg/png          # 各實體圖片
```

---

## 📊 資料庫狀態

| 類別 | 數量 | 範圍 |
|------|------|------|
| 層級 | 13 | Level 0 – Level 12 |
| 實體 | 5 | 笑魘、無面靈、肢團、獵犬、竊皮者 |
| 本地圖片 | 19 | 含所有層級 + 實體代表圖 |

---

## 🚀 快速開始

### 環境需求
- Flutter SDK `^3.41.4`
- Dart SDK `^3.11.1`

### 執行方式

```bash
# 安裝依賴
flutter pub get

# 開發模式執行（macOS）
flutter run -d macos

# 編譯正式版
flutter build macos
```

---

## 🛠️ 技術棧

| 技術 | 用途 |
|------|------|
| Flutter | 跨平台 UI 框架 |
| Dart | 程式語言 |
| google_fonts | 字體管理（Creepster、Space Mono、Noto Sans） |
| Image.asset | 本地圖片載入 |

---

## 📋 開發日誌

### v1.0 — 基礎建設
- ✅ 建立深色主題設計系統
- ✅ 實作首頁 Hero 橫幅 + 警告橫幅
- ✅ 層級卡片與實體卡片 UI
- ✅ 層級詳情頁與實體詳情頁
- ✅ 危險等級徽章元件

### v1.1 — 圖片本地化
- ✅ 從 Backrooms Wiki CN 下載所有圖片至本地
- ✅ 全面替換 `Image.network` → `Image.asset`

### v1.2 — 導航增強
- ✅ `LevelLinkText` 自動辨識文內層級連結
- ✅ 各詳情頁新增「首頁」快捷按鈕

### v1.3 — 內容擴展
- ✅ 層級資料從 Level 0-5 擴展至 **Level 0-12**
- ✅ 從維基下載 Level 6-12 代表圖片

### v1.4 — 體驗優化
- ✅ 全螢幕圖片檢視器（縮放、雙擊、Hero 動畫）
- ✅ 修正實體誤用層級標籤的問題（安全/注意/危險/極度危險）

### 🔮 Planned — 文字冒險模式
- ⬜ AI 驅動的第一人稱文字冒險
- ⬜ 搭配 LLM API 即時生成故事內容
- ⬜ 融入已有的層級與實體資料作為世界觀

---

## 📄 授權

- 內容來源：[Backrooms 中文維基](https://backrooms-wiki-cn.wikidot.com/)
- 圖片授權：[CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)
