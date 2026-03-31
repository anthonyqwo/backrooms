// 後室術語表 — 靜態資料
// 收錄後室世界觀中的專有名詞與解釋

class GlossaryEntry {
  final String term;
  final String termEn;
  final String definition;
  final String? category; // '概念', '物品', '組織', '現象', '地點'

  const GlossaryEntry({
    required this.term,
    required this.termEn,
    required this.definition,
    this.category,
  });
}

class GlossaryData {
  GlossaryData._();

  static const List<GlossaryEntry> entries = [
    // ── 核心概念 ──
    GlossaryEntry(
      term: '後室',
      termEn: 'The Backrooms',
      definition:
          '人類已知現實之外的一個巨大的維度空間。由無數「層級」組成，每個層級都有獨特的環境與規則。通常被描述為人類建築的「背面」——沒有盡頭的空房間、走廊與樓梯。',
      category: '概念',
    ),
    GlossaryEntry(
      term: '層級',
      termEn: 'Level',
      definition:
          '後室中各個獨立的區域或空間。每個層級都有不同的環境特徵、危險等級和實體分佈。層級之間通過特定的方式連接，如門、樓梯、切出等。',
      category: '概念',
    ),
    GlossaryEntry(
      term: '切入',
      termEn: 'Noclip / Clip In',
      definition:
          '從現實世界意外進入後室的過程。通常發生在現實中某些「薄弱點」——如長時間獨自待在看似熟悉但又略顯詭異的空間中。成功切入的人被稱為「流浪者」。',
      category: '現象',
    ),
    GlossaryEntry(
      term: '切出',
      termEn: 'Clip Out / Noclip Out',
      definition:
          '從當前層級轉移至另一個層級的過程。可以是主動的（如通過特定出口或門）或被動的（如地板突然塌陷、觸碰特定物體）。也偶爾指從後室返回現實世界（極其罕見）。',
      category: '現象',
    ),

    // ── 實體相關 ──
    GlossaryEntry(
      term: '實體',
      termEn: 'Entity',
      definition:
          '後室中棲息的各種生物或存在的統稱。實體的危險程度各異——有些完全無害，有些則極度致命。每種實體都有獨特的行為模式和弱點。',
      category: '概念',
    ),
    GlossaryEntry(
      term: '笑魘',
      termEn: 'Smiler',
      definition:
          '後室中最具標誌性的實體之一。在完全黑暗的環境中出現，唯一可辨識的特徵是兩個發光的眼睛和一個寬大的笑容。直視笑魘會導致其發動攻擊。',
      category: '實體',
    ),
    GlossaryEntry(
      term: '無面靈',
      termEn: 'Faceling',
      definition: '外形與人類相似但完全沒有面部特徵的實體。大多數為中立或無害，但部分成年個體可能具有領地意識。是後室中數量最多的實體。',
      category: '實體',
    ),
    GlossaryEntry(
      term: '竊皮者',
      termEn: 'Skin-Stealer',
      definition:
          '能夠完美模仿人類外貌的極度危險實體。牠會偽裝成已消失的倖存者來接近獵物。識別方法包括瞳孔不收縮、半透明血液、無法回答情感問題。',
      category: '實體',
    ),
    GlossaryEntry(
      term: '獵犬',
      termEn: 'Hound',
      definition:
          '以四肢爬行的類人掠食者，聽覺和嗅覺極為敏銳。通常以 3-7 隻的群體形式狩獵，「轉身逃跑」會觸發其追逐本能。弱點為氨氣和水。',
      category: '實體',
    ),
    GlossaryEntry(
      term: '肢團',
      termEn: 'Clump',
      definition:
          '由多個人類肢體不自然融合而成的實體，對血液氣味極為敏感。無法進入寬度小於一公尺的空間，因此躲入狹小空間是有效的逃脫策略。',
      category: '實體',
    ),

    // ── 物品 ──
    GlossaryEntry(
      term: '杏仁水',
      termEn: 'Almond Water',
      definition:
          '後室中最重要的生存資源。外觀與普通瓶裝水相似，但有微弱的杏仁味。飲用後能恢復體力、治癒輕傷，並暫時提高對後室環境的耐受力。在多個層級中均可找到。',
      category: '物品',
    ),
    GlossaryEntry(
      term: '液態痛苦',
      termEn: 'Liquid Pain',
      definition:
          '一種外觀類似深紅色液體的危險物質。接觸或飲用會導致劇烈的全身疼痛，嚴重者可能失去意識或死亡。有時被偽裝成酒精或其他飲品。',
      category: '物品',
    ),
    GlossaryEntry(
      term: '皇家口糧',
      termEn: 'Royal Rations',
      definition:
          '後室中偶爾出現的高品質食物補給。通常以金色包裝出現，食用後能大幅恢復體力和精神狀態。來源不明，被認為可能是某種友好實體的贈禮。',
      category: '物品',
    ),

    // ── 組織 ──
    GlossaryEntry(
      term: 'M.E.G.',
      termEn: 'Major Explorer Group',
      definition:
          '探險者總署（Major Explorer Group），後室中最大的人類組織。致力於探索和記錄後室的層級、實體與資源，為流浪者提供庇護和情報。在多個安全層級設有前哨站。',
      category: '組織',
    ),
    GlossaryEntry(
      term: 'B.N.T.G.',
      termEn: 'Backrooms Nonaligned Trade Group',
      definition:
          '後室遊牧貿易集團，一個以貿易為主的中立組織。在各層級之間流動，交換物資和情報。通常不介入政治衝突，但與 M.E.G. 保持友好關係。',
      category: '組織',
    ),
    GlossaryEntry(
      term: '迷失者',
      termEn: 'The Lost',
      definition:
          '在後室中失去理智、無法正常溝通的人類。長期暴露於後室的異常環境中（尤其是孤立、黑暗的層級），人類可能精神崩潰成為「迷失者」。',
      category: '組織',
    ),

    // ── 現象與概念 ──
    GlossaryEntry(
      term: '閾限空間',
      termEn: 'Liminal Space',
      definition:
          '一種介於兩個狀態之間的過渡空間。在後室語境中，指那些看似熟悉卻令人不安的空間——如空蕩蕩的購物中心、凌晨三點的辦公大樓走廊。後室被認為是現實世界閾限空間的「另一面」。',
      category: '現象',
    ),
    GlossaryEntry(
      term: '流浪者',
      termEn: 'Wanderer',
      definition: '所有意外或自願進入後室的人類的統稱。流浪者們在後室中建立了社區、組織和貿易網絡，共同對抗後室的危險。',
      category: '概念',
    ),
    GlossaryEntry(
      term: '前哨站',
      termEn: 'Outpost',
      definition: '人類組織（主要是 M.E.G.）在相對安全的層級中建立的臨時或永久據點。提供庇護、物資補給和情報交換。',
      category: '地點',
    ),
    GlossaryEntry(
      term: '生存難度等級',
      termEn: 'Survival Difficulty Class',
      definition:
          '用於評估一個層級危險程度的分級系統。等級 1 為最安全（安全、穩定、極少實體），等級 5 為最危險（極度不安全、不穩定、大量敵對實體），「死區」則為無法生存的區域。',
      category: '概念',
    ),
    GlossaryEntry(
      term: '閃爍事件',
      termEn: 'Flickering Event',
      definition:
          '某些層級中燈光異常閃爍的現象，通常預示著實體活動的增加。在 Level 1 中尤為常見，閃爍期間獵犬和笑魘的出沒頻率會大幅上升。',
      category: '現象',
    ),
    GlossaryEntry(
      term: '非歐幾何',
      termEn: 'Non-Euclidean Geometry',
      definition:
          '後室中常見的空間異常現象。表現為：一條直走的走廊可能首尾相連、同一條路走兩次到達不同地方、房間內部比外觀大得多等。在 Level 8 等層級尤為嚴重。',
      category: '現象',
    ),
    GlossaryEntry(
      term: '第九大道',
      termEn: 'The Ninth Avenue',
      definition:
          'M.E.G. 在 Level 8（岩洞系統）中標記的逃生路線。沿途設有路標和臨時物資站，幫助流浪者安全穿越危險的洞穴網絡到達 Level 9。',
      category: '地點',
    ),
  ];
}
