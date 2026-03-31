// 後室 App — 資料模型與靜態內容
// 資料來源：https://backrooms-wiki-cn.wikidot.com/
// 圖片授權：CC BY-SA 3.0

class Level {
  final int id;
  final String name; // 繁體中文名
  final String nameEn; // 英文名
  final String subtitle; // 副標題（英文）
  final String classLabel; // 生存難度，如「等級 1」
  final String classTags; // 如「安全、穩定、極少量實體」
  final String description;
  final String fullDescription;
  final String dangerLevel; // 'safe' | 'caution' | 'danger' | 'extreme'
  final List<String> entities;
  final List<String> accessMethods;
  final List<String> exitMethods;
  final String imageUrl;
  final String sizeDesc;

  const Level({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.subtitle,
    required this.classLabel,
    required this.classTags,
    required this.description,
    required this.fullDescription,
    required this.dangerLevel,
    required this.entities,
    required this.accessMethods,
    required this.exitMethods,
    required this.imageUrl,
    required this.sizeDesc,
  });

  String get dangerText => classLabel;
}

class Entity {
  final String id;
  final String name;
  final String nameEn;
  final String category;
  final String description;
  final String fullDescription;
  final String dangerLevel;
  final List<String> foundInLevels;
  final List<String> survivorTips;
  final String imageUrl;

  const Entity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.category,
    required this.description,
    required this.fullDescription,
    required this.dangerLevel,
    required this.foundInLevels,
    required this.survivorTips,
    required this.imageUrl,
  });
}

class BackroomsObject {
  final String id;
  final String name;
  final String nameEn;
  final String objectClass; // 'Class 1' | 'Class 2' | 'Class 3'
  final String description;
  final String fullDescription;
  final List<String> properties; // 特點 / 用途
  final String dangerLevel; // 'safe' | 'caution' | 'danger'
  final String imageUrl;

  const BackroomsObject({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.objectClass,
    required this.description,
    required this.fullDescription,
    required this.properties,
    required this.dangerLevel,
    required this.imageUrl,
  });
}

class BackroomsData {
  BackroomsData._();

  static const List<Level> levels = [
    Level(
      id: 0,
      name: '閾界',
      nameEn: 'Level 0',
      subtitle: 'The Lobby / Yellow Hell',
      classLabel: '等級 1',
      classTags: '安全・穩定・未確認實體',
      description: '被稱為「黃色地獄」，由無盡重複的辦公空間構成。泛黃壁紙、霉斑地毯與螢光燈嗡鳴是其特徵，這裡是流浪者進入後室的第一站。',
      fullDescription:
          'Level 0 是後室的第一層，往往也是誤入者們的第一站。這是一個由無限延伸的隔間、走廊與樓梯組成的非線性空間。其共同特徵包括：病態泛黃的壁紙、覆滿霉斑的潮濕地毯，以及不斷閃爍且發出震耳欲聾嗡鳴聲的螢光燈具。\n\n本層級存在多種空間異變（變體）：\n1. **拱門 (Arches)**：穩定性最佳，適合辨認方向。\n2. **柱廳 (Pillars)**：巨大的立柱房間，會發生「邊緣位移」使來路難以辨認。\n3. **深坑 (Deep Pits)**：直通地底深處，墜落後果不明。\n4. **熄燈區 (Blackout Zones)**：完全無照明的區域，充斥著沒過腳踝的積液。\n5. **紅室 (Red Rooms)**：極度危險且幾乎無法逃離，牆紙會剝落暴露出下方的血紅色，請務必徹底遠離。\n\n「孤立效應」是本層最顯著的現象：即使兩名流浪者並肩進入，也永遠無法找到彼此，這是一道必須孤身面對的難關。地毯中的液體成分駁雜，包含鹽水、杏仁水、液態痛苦、甚至福爾馬林及人類 DNA，強烈建議不要啃食或飲用。',
      dangerLevel: 'class1',
      entities: ['尚不可知，可能受孤立效應影響，有報告稱見到黑色人影尾隨'],
      accessMethods: [
        '從現實世界中意外「切出」（No-clipping）',
        '在 Level 283 的堡壘中，極其少見地存在散發霉味的木門通向 Level 0',
      ],
      exitMethods: [
        '存活足夠久，直到發現閃爍的牆壁並縱身投入其中，將抵達 Level 1',
        '找到極其罕見的「馬尼拉房間（Manila Room）」',
      ],
      imageUrl: 'assets/images/level_0.jpg',
      sizeDesc: '約六億平方英里（估計）',
    ),
    Level(
      id: 1,
      name: '宜居地帶',
      nameEn: 'Level 1',
      subtitle: 'Habitable Zone',
      classLabel: '等級 1',
      classTags: '安全・穩定・極少量實體',
      description: '巨大的無限建築物，外觀像停車場或廢棄倉庫。混凝土地板與牆壁，天花板掛著閃爍的管狀螢光燈，是流浪者定居的主要層級。',
      fullDescription:
          'Level 1 是後室的第二個層級，又稱「宜居地帶」，是流浪者最常選擇定居的層級。與 Level 0 不同，此地要更為複雜且致命，因為這裡擁有多種實體和現象。不過，幸運的是，你還會找到食物和水這樣的資源，同時會發現人類定居點。\n\n宜居地帶的過道：寬敞開闊的空間裡，單調褪色的牆壁綿延數英里，偶爾出現的混凝土支柱支撐著整個結構。許多流浪者稱此地是「地下停車場和廢棄倉庫的無盡縫合體」。\n\n宜居地帶受所謂的「非歐幾何」影響。這意味著你所感知的距離不過是感官製造的假象，周遭環境也絕非你看到的模樣。指南針等設備可在此層正常使用。\n\n「閃爍」是此層最危險的現象——所有自然光源隨機切斷，導致整個層級陷入完全黑暗。在黑暗中，許多危險實體會出沒並獵捕流浪者。探險者總署（M.E.G.）在此層的天鷹段設立了 Alpha 基地，會積極尋找新進入的流浪者並給予協助。',
      dangerLevel: 'class1',
      entities: ['肢團 (Clumps)', '獵犬 (Hounds)', '笑魘 (Smilers)（閃爍期間）'],
      accessMethods: ['從 Level 0「切出」後通常直接進入', '從部分其他層級進入'],
      exitMethods: ['從特定出口進入 Level 2', '透過特殊管道進入其他層級', '與探險者總署合作尋找已知出口'],
      imageUrl: 'assets/images/level_1.jpg',
      sizeDesc: '估計無限大',
    ),
    Level(
      id: 2,
      name: '廢棄公共帶',
      nameEn: 'Level 2',
      subtitle: 'Pipe Dreams',
      classLabel: '等級 3',
      classTags: '不安全・不穩定・少量實體',
      description: '由無限且複雜的工業隧道組成，牆壁為髒污的水泥，佈滿管線、機器與工業設備，常有震耳欲聾的運轉噪音。',
      fullDescription:
          'Level 2 又稱「廢棄公共帶」，是一個由工業管道、機械設備和混凝土通道構成的複雜網絡。此層的溫度極低，約攝氏4度，且存在持續的強烈機械噪音，使得任何聲音通訊都十分困難。\n\n此層級的危險性遠超 Level 1。光線極為稀少，許多區域幾乎完全黑暗，而黑暗正是笑魘最活躍的環境。管道中流動著各種不明液體，部分有毒。此層的氣壓比正常更高，長時間停留可能導致頭痛和定向障礙。\n\n此層中有一種特殊現象——某些管道會突然噴出高溫蒸汽，無任何預警。流浪者報告指出，在此層迷路後很難找到出路，因為管道網絡極為複雜，且沒有任何標識系統。極少數倖存者記錄了在此層找到廢棄工廠區域的經歷，其中存在一些補給品，但這些區域也是實體最密集的地方。',
      dangerLevel: 'class3',
      entities: ['笑魘 (Smilers)', '肢團 (Clumps)', '獵犬 (Hounds)'],
      accessMethods: ['從 Level 1 的特定出口進入', '從 Level 3 的通風孔滑落', '在某些層級中意外穿越薄弱點'],
      exitMethods: ['找到標有黃色膠帶的出口管道並沿其前進', '透過緊急出口門（十分罕見）進入 Level 1 或 Level 3'],
      imageUrl: 'assets/images/level_2.jpg',
      sizeDesc: '估計無限大',
    ),
    Level(
      id: 3,
      name: '發電站',
      nameEn: 'Level 3',
      subtitle: 'Electrical Station',
      classLabel: '等級 4',
      classTags: '不安全・不穩定・中量實體',
      description: '長而黑暗的曲折走廊，結構類似 Level 0 但更為狹窄封閉，充滿轟鳴的機器噪音，電氣設備遍佈各處。',
      fullDescription:
          'Level 3 又稱「發電站」，是一個充斥大量電氣設備的危險層級。此層的走廊比 Level 0 更為狹窄，且幾乎完全黑暗，只有零星閃爍的電氣設備提供微弱光線。\n\n此層電磁干擾極為強烈，所有電子設備（包括手電筒）都無法穩定工作。無線電通訊在此完全失效。走廊中充斥著各種裸露的電線和高壓設備，任何不小心的碰觸都可能造成嚴重電擊甚至死亡。\n\n此層中的實體密度遠高於前幾層。無面靈（Facelings）在此層異常活躍，但更令人擔憂的是笑魘——由於此層幾乎完全黑暗，笑魘幾乎無處不在。倖存者報告指出，在此層中行走時，幾乎任何方向都能看到笑魘特有的發光笑容。探險者總署警告，Level 3 是後室中死亡率最高的層級之一，不建議任何未充分準備的流浪者進入。',
      dangerLevel: 'class4',
      entities: ['無面靈 (Facelings)', '笑魘 (Smilers)', '獵犬 (Hounds)'],
      accessMethods: [
        '從 Level 2 的某些通道進入',
        '觸碰特定的損壞電氣設備',
        '從 Level 4 的某些出口反向進入',
      ],
      exitMethods: ['找到主配電盤並關閉特定電路', '在走廊中找到標有「EXIT」的緊急門'],
      imageUrl: 'assets/images/level_3.jpg',
      sizeDesc: '估計無限大',
    ),
    Level(
      id: 4,
      name: '廢棄辦公室',
      nameEn: 'Level 4',
      subtitle: 'Abandoned Office',
      classLabel: '等級 1',
      classTags: '安全・穩定・極少量實體',
      description: '類似空置辦公大樓，幾乎沒有家具。部分房間有被塗黑的窗戶，是流浪者的重要避難所與中繼站。',
      fullDescription:
          'Level 4 又稱「廢棄辦公室」，是後室中相對安全的居住層級之一。此層的外觀類似一棟廢棄的現代辦公大樓，走廊整潔，部分房間保留著辦公桌椅等家具。\n\n此層的光線比前幾層充足許多，螢光燈雖有些昏暗，但基本維持穩定。部分房間的窗戶被完全塗黑，無法從外部看到任何景象，也無法確定外部是否存在任何空間。空氣相對新鮮，溫度適中，約攝氏18至22度。\n\n Level 4 是探險者總署（M.E.G.）的主要基地所在地，同時也是後室中許多組織的重要據點。由於環境相對安全，許多流浪者選擇在此定居，形成了數個較為穩定的社群。此層的實體數量極少，偶爾會看到無面靈，但牠們通常不具攻擊性。對於剛從危險層級逃出的流浪者而言，Level 4 是最理想的休整地點。',
      dangerLevel: 'class1',
      entities: ['無面靈 (Facelings)（極少量）'],
      accessMethods: [
        '從 Level 3 的緊急出口進入',
        '從 Level 5 的特定通道進入',
        '在 Level 1 中長時間迷路後偶爾進入',
      ],
      exitMethods: ['乘坐大樓電梯（通往不同層級）', '從特定的逃生樓梯進入 Level 5', '透過「切出」進入鄰近層級'],
      imageUrl: 'assets/images/level_4.jpg',
      sizeDesc: '估計數億平方公里',
    ),
    Level(
      id: 5,
      name: '恐怖旅館',
      nameEn: 'Level 5',
      subtitle: 'Terror Hotel',
      classLabel: '等級 2',
      classTags: '不安全・穩定・少量實體',
      description: '無限的酒店綜合樓，呈現1930年代的復古風格。時常能聽到從牆壁另一側傳來模糊的聚會閒聊聲，令人毛骨悚然。',
      fullDescription:
          'Level 5 又稱「恐怖旅館」，外觀是一棟無限延伸的1930年代風格豪華酒店。大廳鋪著深紅色地毯，牆上掛著古舊的藝術畫作，走廊以厚重的木門和黃銅壁燈裝飾。\n\n此層最令人不安的特徵是聲音——你時常能聽到從牆壁另一側傳來的聚會聲音、笑聲、酒杯碰撞聲，但打開任何一扇門，裡面都是空蕩蕩的。這些聲音的來源至今無法解釋。\n\n Level 5 的危險性主要來自其複雜的空間結構。酒店的走廊和房間會定期重新排列，導致流浪者很容易在看似熟悉的區域迷路。此層存在幾種獨特的實體，其中最令人恐懼的是「影子旅客」——牠們的外形幾乎與人類相同，只有在燈光下才能分辨出其實際上是二維的黑色剪影。探險者總署在此層有一個小規模的前哨站，專門研究此層的空間異常現象。',
      dangerLevel: 'class2',
      entities: ['影子旅客 (Shadow Guests)', '無面靈 (Facelings)'],
      accessMethods: ['從 Level 4 的特定逃生樓梯進入', '在部分其他層級的電梯中按下特定樓層'],
      exitMethods: [
        '找到大廳的「員工出口」標誌並進入',
        '從酒店停車場找到通向 Level 1 的出口',
        '透過特定的服務通道進入 Level 6',
      ],
      imageUrl: 'assets/images/level_5.png',
      sizeDesc: '估計無限大',
    ),
    Level(
      id: 6,
      name: '熄燈',
      nameEn: 'Level 6',
      subtitle: 'Lights Out',
      classLabel: '等待分級',
      classTags: '安全性未知・不穩定・未探明實體存在',
      description: '被徹頭徹尾的黑暗籠罩，層級內無光線照射，帶入的光源也會喪失功能。由無盡的狹窄走廊構成，寂靜異常如同隔音室。',
      fullDescription:
          'Level 6 是後室的第七層。由於 Level 6 被徹頭徹尾的黑暗籠罩，我們對該層級的真實結構了解甚少。層級內無光線照射，而被帶入層級的光源也會喪失功能。Level 6 內的探索是通過在黑暗中摸索前進來開展的，這揭示出該層級由一系列似乎無窮無盡的狹窄走廊構成。這些走廊由一種光滑且冰涼的材料（很可能是混凝土）製成。\n\n除了永無止境的黑暗，Level 6 也寂靜異常，如同一間隔音室。探索 Level 6 就是在讓自己走上一遭穿越了完全漆黑、絕對靜謐與徹底孤立的緩慢旅途。因此，大多數在 Level 6 內待了數分鐘以上的人都報告稱感受到了偏執、恐懼、焦慮與愈發加劇的緊張。也有數位親歷者報告稱偶爾會有幻聽，如碎步聲、呼吸聲與呢喃。\n\nLevel 6 很大程度上被認為是後室早期最危險的層級之一。然而，調查顯示迄今為止尚未在該層級發現任何已知類型的實體。儘管如此，似乎很少有人能離開 Level 6。其原因未知。',
      dangerLevel: 'pending',
      entities: ['尚未發現已知實體（但有襲擊報告）', '「模仿者」社區（約4人，能完美模仿任何聲音）'],
      accessMethods: ['從 Level 5 的鍋爐房抵達', 'Level 4 內的 Omega 基地周邊存在另一入口'],
      exitMethods: [
        '探索得足夠深入，可以找到一個向下通往 Level 7 的樓梯井（留意微弱的海浪聲）',
        '找到一扇令人感到極冷的巨大鐵門可到達 Level 129',
      ],
      imageUrl: 'assets/images/level_6.jpg',
      sizeDesc: '未知（無法測量）',
    ),
    Level(
      id: 7,
      name: '深海恐懼症',
      nameEn: 'Level 7',
      subtitle: 'Thalassophobia',
      classLabel: '等級 4',
      classTags: '不安全・不穩定・中量實體',
      description: '一片廣闘到不可思議的海洋，似乎在所有方向上都無限延伸。層級內缺乏固定光源，僅有昏暗的自然光照明。',
      fullDescription:
          'Level 7 是後室的第八層。該層級的存在對探索 Level 8 以及更高層級構成了顯著障礙。Level 7 是一片不可思議的海洋，在所有方向上無限延伸。該層級由兩個部分組成：入口房間與承載海洋的「房間」。\n\n入口房間內家具齊全，有書架、咖啡桌、椅子和螢光吊燈。鋪有地毯的地面覆蓋著一層淺水。入口房間的重力方向與海洋區域不同——入口房間側著建在天花板上，打開門後會從上往下面向海面。\n\n海洋依據光照水平分為四個區域：日光帶（最亮、最荒涼）、暮色帶（深約一千米，溫度與亮度顯著下降，可見骸骨與廢鐵）、午夜帶（約三千米，徹底黑暗，大量類人骸骨）、深淵帶（超過七千米，極度危險，存在焦油與氣泡）。\n\n層級內存在兩個極度危險的實體：七層之物與小小。七層之物棲息於午夜帶與深淵帶，小小則活動於日光帶與暮色帶。',
      dangerLevel: 'class4',
      entities: ['七層之物', '小小'],
      accessMethods: ['從 Level 6 的樓梯井進入入口房間', '傳聞 Level 8 地面的水坑也可能是入口'],
      exitMethods: ['午夜帶底部海底山一側的岩洞通往 Level 8', '入口房間西側約150米處有通向 Level 9 的水下出口'],
      imageUrl: 'assets/images/level_7.jpg',
      sizeDesc: '估計無限大',
    ),
    Level(
      id: 8,
      name: '岩洞系統',
      nameEn: 'Level 8',
      subtitle: 'Cave System',
      classLabel: '等級 4',
      classTags: '不安全・不穩定・大量實體',
      description: '無限蔓延的地下洞穴，隧道網布，寒冷、黑暗、危機四伏。非歐幾何空間、不穩定重力與異常熵變使得此地極其危險。',
      fullDescription:
          'Level 8 是後室前十二層中最後一個封閉層級。這座無限蔓延的地下洞穴中隧道網布，織成一座令人窒息的監獄。寒冷、黑暗、危機四伏——每一個轉角之後，都潛藏著伺機待發的捕食者。\n\n此層級受到非歐幾何空間的嚴重影響：一條看似筆直的通道可能首尾相銜，同一條路走兩遍可能到達不同終點。不穩定的重力使混亂雪上加霜——強度時高時低、方向變化無常。更可怕的是異常的熵變：時間流速大大加快，食物難以保存，電池迅速失效，長期生活的人甚至會加速衰老。\n\n洞穴中遍布杏仁水，許多洞穴被完全淹沒。部分區域會突然湧水，溫度從10°C到43°C不等。探險者總署（M.E.G.）在此標記了一條名為「第九大道」的道路，幫助流浪者逃離此地。M.E.G.的「空巢」前哨站和哈莫茲洞穴社群在此提供庇護。',
      dangerLevel: 'class4',
      entities: [
        '牧蛇 (Wranglers)',
        '迷彩爬行者 (Camo Crawlers)',
        '笑魘 (Smilers)',
        '悲屍 (Wretches)',
        '大量蛛形綱生物',
      ],
      accessMethods: ['從 Level 7 午夜帶的海底岩洞進入', '從 Level 6 或其他深層層級意外穿越'],
      exitMethods: ['沿「第九大道」路標前進最終到達 Level 9', '從 Level 8 的地面切出可能到達 Level 9'],
      imageUrl: 'assets/images/level_8.png',
      sizeDesc: '實際無限大（已探明區域為高60英里、半徑2.5英里的圓柱區域）',
    ),
    Level(
      id: 9,
      name: '郊區',
      nameEn: 'Level 9',
      subtitle: 'The Suburbs',
      classLabel: '等級 5',
      classTags: '不安全・開闊性・實體侵害',
      description: '一片處於永恆午夜的無限郊區，有著各式各樣的房屋與街道。黑暗程度類似 Level 6，但危險性來自大量實體的出沒。',
      fullDescription:
          'Level 9 是後室的第十層，外觀是一片無窮的處於午夜的郊區。這一層有著如同 Level 6 那樣的黑暗，但沒有那麼絕對。房屋有著各式的設計和體積，每一棟都截然不同，且看上去有家具、相當嶄新，但沒有電源供照明系統運作。\n\n街道是此層中更加危險的區域。這些潮濕的瀝青路沒有塗上油漆，某些地區被樹葉覆蓋。路燈通常關閉且不運轉，偶有閃爍的燈。濃霧時要特別警惕，那是碾壓者的生成機制。\n\n此層出現大量危險實體：笑魘、竊皮者、獵犬、悲屍、碾壓者、邻里守望等。Level 9 也有一些特殊現象——走得太遠時，會發現兩棟房子奇怪地卡在彼此之中，從物理角度不可能發生。通往草地的人行道會到達 Level 10。',
      dangerLevel: 'class5',
      entities: [
        '笑魘 (Smilers)',
        '竊皮者 (Skin-Stealers)',
        '獵犬 (Hounds)',
        '悲屍 (Wretches)',
        '碾壓者 (Crushers)',
        '邻里守望 (Neighborhood Watch)',
      ],
      accessMethods: ['從 Level 8 的地板切出是最主要的方式', '從 Level 34 的下水道格柵爬上來'],
      exitMethods: [
        '跟著街道上的箭頭標誌，行走100至200英里後可到達 Level 11',
        '通往草地的人行道通往 Level 10',
      ],
      imageUrl: 'assets/images/level_9.jpg',
      sizeDesc: '估計無限大',
    ),
    Level(
      id: 10,
      name: '麥田',
      nameEn: 'Level 10',
      subtitle: 'Field of Wheat',
      classLabel: '等級 1',
      classTags: '安全・開闊性・懷舊',
      description: '一片廣闊、向四面八方無限延伸的麥田。天空永遠呈現陰沉的鉛灰色，點綴著灌木叢、湖泊和散落的穀倉建築。',
      fullDescription:
          'Level 10 是一片廣闘的、向四面八方無限延伸的麥田。其中，一排排的樹木與灌木叢將這塊麥田分割成許多小塊。該層級氣候從不改變，天空永遠呈現陰沉的鉛灰色，罕有短暫的小雨與霧天。沉悶的氣氛與一成不變的白天讓人容易失去時間觀念。\n\n水體廣佈於低地，水被認為可以安全飲用（帶有泥土味道）。在此層可間或發現各種建築物，從小木棚、外屋到較大的穀倉和馬廄一應俱全。除存放木材和釘子等資源外，內部大多空空如也。\n\n此層獨有的實體很少，主要是棲息在地表下土壤中的小體型蠕蟲實體。挖掘超過一公尺深的洞可能導致蠕蟲從土壤中迅速湧出。泥土小路經常出現，沿著這些小路走很遠通常可以到達 Level 11。',
      dangerLevel: 'class1',
      entities: ['蠕蟲實體（土壤中）'],
      accessMethods: ['從 Level 9 中通往草地的人行道進入', '在 Level 11 的某些街道旁找到偏僻小道返回'],
      exitMethods: ['找到泥土小路並長時間沿它行走，最終到達 Level 11', '在湖中游泳可能進入水域層級'],
      imageUrl: 'assets/images/level_10.png',
      sizeDesc: '估計無限大',
    ),
    Level(
      id: 11,
      name: '無垠城市',
      nameEn: 'Level 11',
      subtitle: 'The Infinite City',
      classLabel: '等級 1',
      classTags: '安全・穩定・城鎮',
      description: '一座永遠處於白天的無限城市，街道上空無一人卻保持著完好的基礎設施。是後室中最安全、最宜居的層級之一。',
      fullDescription:
          'Level 11 又稱「無垠城市」，是後室中最知名且最宜居的層級之一。它呈現為一座無限延伸的現代城市，永遠處於明亮的白天，天空是清澈的藍色但看不到太陽。街道上空無一人，但建築保持著完好的狀態。\n\n城市中有各式各樣的建築：商店、餐廳、辦公樓、公寓——許多建築內部可以找到有用的補給品，包括食物、水和其他生存資源。電力在這裡基本正常運作，許多建築有照明和暖氣。\n\n此層級是後室中多個重要組織的主要活動區域。探險者總署（M.E.G.）的多個前哨站設立於此，B.N.T.G.（後室遊牧貿易集團）也將此地作為重要的貿易中心。由於環境穩定且資源豐富，許多流浪者選擇在此定居。實體在此層級相對稀少，主要是無害的無面靈。',
      dangerLevel: 'class1',
      entities: ['無面靈 (Facelings)（多為中立）'],
      accessMethods: [
        '從 Level 10 沿泥土小路長時間行走',
        '從 Level 9 跟著箭頭標誌行走100至200英里',
        '多個其他層級都有通往 Level 11 的出口',
      ],
      exitMethods: ['進入特定建築可能被傳送至其他層級', '在城市邊緣的區域可能到達 Level 12', '某些巷弄可通往不同層級'],
      imageUrl: 'assets/images/level_11.jpg',
      sizeDesc: '估計無限大',
    ),
    Level(
      id: 12,
      name: '矩陣',
      nameEn: 'Level 12',
      subtitle: 'The Matrix',
      classLabel: '等級 0',
      classTags: '安全・穩定・實體絕跡',
      description: '一片由不規則排列的混凝土柱子組成的開闊空間，天花板極高，螢光燈提供昏暗照明，體感類似巨大的地下停車場。',
      fullDescription:
          'Level 12 又稱「矩陣」，是一片由不規則排列的混凝土柱子組成的極度開闘空間。天花板極高（約12至15米），由間距不一的螢光燈提供昏暗照明。整個空間瀰漫著一層薄霧，使得能見度受到限制。\n\n此層級的空間結構類似一個巨大的地下停車場，但沒有任何車輛。地面是灰色的混凝土，偶爾可以看到水漬和裂縫。柱子之間的間距不一致，有時密集得需要側身通過，有時則開闘到看不到周圍的柱子。\n\n此層的危險主要來源於空間的不穩定性和迷失方向。由於所有柱子外觀幾乎相同，且缺乏參照物，流浪者極易在此迷路。部分區域的地面會無預警地陷落。此層偶爾會出現實體，但數量相對較少。探險者總署建議流浪者在柱子上做標記以追蹤行進方向。',
      dangerLevel: 'class0',
      entities: ['無面靈 (Facelings)', '獵犬 (Hounds)（偶爾）'],
      accessMethods: ['從 Level 11 的城市邊緣區域進入', '從某些層級的地面切出'],
      exitMethods: ['在特定柱子上找到標記門可進入其他層級', '穿越足夠遠的距離可能到達更高層級'],
      imageUrl: 'assets/images/level_12.gif',
      sizeDesc: '估計無限大',
    ),
  ];

  static const List<Entity> entities = [
    Entity(
      id: 'smiler',
      name: '笑魘',
      nameEn: 'Smiler',
      category: '掠食型實體',
      description: '以標誌性的反光雙眼和閃爍牙齒識別，通常待在黑暗中，遇到時需保持眼神接觸並緩慢退後。',
      fullDescription:
          '笑魘是後室最令人恐懼的實體——在完全黑暗的環境中，你會看到兩道發光的弧形光，那就是它的笑容。牠通常保持靜止，潛伏在黑暗角落中，等待目標關閉光源或眼神移開黑暗角落。\n\n一旦被直視，笑魘會以極高速度衝向目標。牠的速度遠超人類，幾乎無法逃脫。倖存的唯一方式是維持光源並盡快離開黑暗區域。\n\n笑魘對光線有明顯的厭惡，任何強光都能使其退卻。然而，若光源突然熄滅，牠會立即發動攻擊。後室研究人員推測，笑魘可能不是單一物種，而是多種外形類似的實體的統稱。牠們廣泛分布於各個光線昏暗的層級，尤其是 Level 2 和 Level 3。',
      dangerLevel: 'class5',
      foundInLevels: ['Level 2', 'Level 3', 'Level 7'],
      survivorTips: [
        '隨時保持光源，不得熄滅',
        '切勿獨自進入黑暗區域',
        '聽到嘻笑聲立刻移向光源',
        '用強光直射可使其退卻',
        '不要試圖與其正面對抗',
      ],
      imageUrl: 'assets/images/entity_smiler.png',
    ),
    Entity(
      id: 'faceling',
      name: '無面靈',
      nameEn: 'Faceling',
      category: '中性型實體',
      description: '與人類相似但完全沒有面部特徵的生物，城市型層級常見，多數為中立，但成年個體可能具備領地意識。',
      fullDescription:
          '無面靈（又稱「無面人」）是後室中最常見的實體，外形與人類相似，但面部完全光滑，沒有任何五官。牠們通常穿著普通的日常服裝，緩慢地在走廊中移動，幾乎完全無視人類的存在。\n\n研究顯示，無面靈並非天生具有攻擊性。然而，根據其發育階段，行為模式有所不同：幼年個體完全無害，會自然迴避接觸；成年個體通常中立，偶有好奇心；老年個體則可能具有強烈的領地意識，若感到受威脅會主動攻擊。\n\n若突然大聲打擾牠們或做出激烈動作，部分個體可能會表現出攻擊行為。值得注意的是，某些無面靈似乎能感知人類的恐懼，並在恐慌的流浪者附近聚集，但目前尚不清楚這是出於好奇還是捕食本能。',
      dangerLevel: 'class2',
      foundInLevels: ['Level 0', 'Level 1', 'Level 3', 'Level 4', 'Level 5'],
      survivorTips: [
        '保持平靜，緩慢移動',
        '不要發出突然的大聲響',
        '繞行而非直接穿越其路徑',
        '遇到成年個體時保持距離',
        '切勿奔跑——這會觸發其追逐本能',
      ],
      imageUrl: 'assets/images/entity_faceling.jpg',
    ),
    Entity(
      id: 'clump',
      name: '肢團',
      nameEn: 'Clump',
      category: '掠食型實體',
      description: '由多隻肢體胡亂組成的實體，身手極其敏捷且富有侵略性，常隱藏在陰暗角落伺機而動。',
      fullDescription:
          '肢團（又稱「聚合體」）是後室中外貌最令人不安的實體之一。它由多個（通常為4到8個）人類肢體不自然地扭曲、融合在一起，形成一個巨大的肉塊生物，以多條手臂交替撐地移動，發出骨骼折斷與肌肉撕裂的噪音。\n\n肢團的速度比外表看起來快得多，且嗅覺極為靈敏，對血液氣味特別敏感。在受傷後試圖逃跑是極其危險的行為——血腥氣味會吸引更多肢團聚集。\n\n此實體出沒時通常伴隨著沉重的拖行聲，聽到此聲音時應立刻尋找高處或狹小空間藏匿——肢團無法進入寬度小於一公尺的空間。後室研究人員推測，肢團可能是後室的某種「清潔機制」，專門收集死亡流浪者的遺體並將其同化。',
      dangerLevel: 'class4',
      foundInLevels: ['Level 1', 'Level 2'],
      survivorTips: [
        '聽到拖行聲立刻躲入狹小空間',
        '受傷後立刻包紮遮蓋氣味',
        '不要嘗試正面對抗',
        '尋找高處攀爬是有效的逃脫方式',
        '保持安靜——聲音會吸引其注意',
      ],
      imageUrl: 'assets/images/entity_clump.jpg',
    ),
    Entity(
      id: 'hound',
      name: '獵犬',
      nameEn: 'Hound',
      category: '掠食型實體',
      description: '有長黑髮且以四足爬行的類人生物，極具攻擊性，會追逐並襲擊任何激怒它們的人，聽覺與嗅覺極為敏銳。',
      fullDescription:
          '獵犬是後室中最活躍的掠食型實體之一。外形與大型犬隻類似，但實際上是以四肢爬行的類人生物，全身覆滿長而凌亂的黑色頭髮，遮蓋了其面部特徵。牠的聽覺和嗅覺是後室實體中最為銳利的。\n\n獵犬以群體形式狩獵，通常3至7隻一組。牠們十分聰明，會圍堵目標的逃跑路線。受到驚嚇會觸發其追逐本能——切勿在目視獵犬後轉身逃跑，這是最危險的行為。\n\n獵犬在 Level 1 的「閃爍」事件期間特別活躍。後室研究人員記錄了獵犬的幾個弱點：牠們對強烈的氨氣氣味有極度厭惡，遇到此氣味時會立即逃離；同時，牠們無法游泳，遇水會迴避。此外，獵犬似乎對某些特定頻率的聲音感到痛苦，部分倖存者利用口哨成功驅趕了獵犬。',
      dangerLevel: 'class3',
      foundInLevels: ['Level 1', 'Level 2', 'Level 3'],
      survivorTips: [
        '不要轉身跑——面對牠倒退撤離',
        '躲入狹小通道或水邊',
        '氨水和漂白劑的氣味可驅趕牠',
        '避免攜帶食物或血腥氣味',
        '群體中遭遇時優先逃往高處',
      ],
      imageUrl: 'assets/images/entity_hound.jpg',
    ),
    Entity(
      id: 'skin-stealer',
      name: '竊皮者',
      nameEn: 'Skin-Stealer',
      category: '偽裝型實體',
      description: '大型類人實體，能穿上受害者的皮進行偽裝，血液為半透明，能模仿人類語言吸引獵物，是後室中最難辨識的威脅。',
      fullDescription:
          '竊皮者是後室中最令人毛骨悚然的實體，因為牠們看起來與人類完全相同。牠們能夠完美複製特定人類的外貌、聲音、行走方式，甚至記憶片段。\n\n竊皮者通常偽裝成已在後室中消失的倖存者，試圖接近並孤立其他生存者。識別方法包括：瞳孔在強光下不收縮、血液呈半透明而非紅色、無法正確回答「情感性」問題（如「你最喜歡的親人是誰？你們上次見面有什麼感受？」），以及對特定氣味（如強烈香皂味）表現出不自然的厭惡。\n\n後室倖存者社群建立了一套驗證問題體系。當遇到未知的「倖存者」時，應使用這些問題確認身份。竊皮者的皮膚觸感異常光滑，且在高溫下會表現出不適，這也是辨識的方式之一。',
      dangerLevel: 'class5',
      foundInLevels: ['Level 3', 'Level 4', 'Level 5'],
      survivorTips: [
        '用強光照射眼睛觀察瞳孔反應',
        '詢問只有真實倖存者才能回答的情感問題',
        '不要獨自與陌生「倖存者」相處',
        '注意皮膚觸感和排汗是否正常',
        '相信直覺——若感覺不對勁立刻離開',
      ],
      imageUrl: 'assets/images/entity_skin_stealer.jpg',
    ),
  ];

  static const List<BackroomsObject> objects = [
    BackroomsObject(
      id: 'almond-water',
      name: '杏仁水',
      nameEn: 'Almond Water',
      objectClass: 'Class 1 (安全)',
      description: '後室中最常見且最重要的生存物資，帶有淡淡杏仁味的透明液體。',
      fullDescription:
          '杏仁水是後室中最重要的生存物資。它是一種透明液體，聞起來有淡淡的苦杏仁味。這種液體不僅可以維持流浪者的水分，還能提供一定的能量（每瓶約 600 卡路里）。\n\n除了食用價值，杏仁水還具有顯著的醫療與心理效應：它能加速傷口癒合，緩解流浪者的精神壓力。最重要的是，飲用適量的杏仁水可以中和某些實體造成的負面變異（如「爬菌」感染），防止流浪者喪失人性轉化為實體。',
      properties: [
        '維持水分與高熱量補給',
        '加速外傷癒合',
        '緩解精神壓力，防止實體化',
        '在特定層級可能有毒，建議過濾或煮沸',
      ],
      dangerLevel: 'safe',
      imageUrl: 'assets/images/object_almond_water.jpg',
    ),
    BackroomsObject(
      id: 'firesalt',
      name: '火鹽',
      nameEn: 'Firesalt',
      objectClass: 'Class 1 (實用)',
      description: '具有爆炸性的橙色小型晶體，是流浪者的自衛武器與主要熱源。',
      fullDescription:
          '火鹽是一種不穩定的橙色晶體。它在受到強力撞擊（如投擲）時會發生劇烈爆炸，釋放出強烈的火花與熱量。這使得它成為流浪者對抗實體的有效自衛武器。\n\n在非戰鬥場合，火鹽也極具價值。將一小粒火鹽溶於水中，會立即將水加熱至沸騰點，可用於烹飪或液體消毒。熔化後的液態火鹽甚至可以用作工業設備的燃料。',
      properties: [
        '投擲可觸發爆炸，威懾實體',
        '溶解於水可快速產生熱能與沸水',
        '可用作發電機或載具的替代燃料',
      ],
      dangerLevel: 'caution',
      imageUrl: 'assets/images/object_firesalt.png',
    ),
    BackroomsObject(
      id: 'liquid-pain',
      name: '液態痛苦',
      nameEn: 'Liquid Pain',
      objectClass: 'Class 3 (極度危險)',
      description: '一種深紅色的粘性有毒液體，外觀常被誤認為是有用的飲料。',
      fullDescription:
          '液態痛苦是後室中最陰險的陷阱之一。它呈現為深紅色的濃稠液體，外觀酷似強效補給品，但實際上含有致命毒素。接觸或飲用後，受害者會感受到全身如火燒、骨裂般的極度痛苦。\n\n這種液體會導致內臟衰竭與嚴重的溶血反應。它的獨特之處在於散發著淡淡的腐爛肉味，這通常是辨識它的唯一方式。它經常出現在層級陰暗處，或被隱藏在看似無害的求生物資包中。',
      properties: [
        '引發極度劇烈的全身痛覺',
        '導致多重器官衰竭與溶血',
        '具有誘騙性的外觀，帶有腐肉味',
      ],
      dangerLevel: 'danger',
      imageUrl: 'assets/images/object_liquid_pain.jpg',
    ),
    BackroomsObject(
      id: 'memory-jar',
      name: '記憶罐',
      nameEn: 'Memory Jar',
      objectClass: 'Class 2 (特殊)',
      description: '能承載並重現死者記憶的玻璃罐，是後室中極具價值的交易品。',
      fullDescription:
          '記憶罐是一種奇特的玻璃容器。當持有者在攜帶罐子的情況下死亡時，罐子會自動捕捉並儲存受害者生前最後一段時間的記憶。罐子內部會出現漂浮的微光球。\n\n其他流浪者觸碰光球後，可以親身體驗並觀看這些記憶片段。這對於獲取層級路徑、避開已知陷阱或追尋失蹤者具有不可估量的價值。在主要貿易基地（如 M.E.G. 據點），記憶罐被視為最重要的資源與交易貨幣。',
      properties: [
        '自動保存死者的最後記憶片段',
        '提供關鍵的層級情報與生存知識',
        '高品質的交易媒介與物資',
      ],
      dangerLevel: 'safe',
      imageUrl: 'assets/images/object_memory_jar.jpg',
    ),
    BackroomsObject(
      id: 'royal-rations',
      name: '皇家口糧',
      nameEn: 'Royal Rations',
      objectClass: 'Class 1 (珍貴)',
      description: '白色半透明的明膠食物，提供驚人營養，但具有成癮性的美味。',
      fullDescription:
          '皇家口糧是後室中最高級的補給物資。它呈現為白色、半透明的凝膠狀，每一口都能為流浪者提供巨大的熱量與完整的生理營養需求。只需少量攝取即可支撐多日的體力活動。\n\n然而，它最著名的特徵是其無與倫比的回甘與美味——許多流浪者將其譽為「一生中吃過最好吃的東西」。這種味覺享受極具成癮性，過量食用會引發強烈的渴望與心理依賴，甚至導致流浪者群體內部為了爭奪殘餘口糧而爆發衝突。',
      properties: [
        '極高密度的能量與全面營養',
        '極致的美味，具有強烈成癮性',
        '在生存者群體中具高度戰略價值',
      ],
      dangerLevel: 'safe',
      imageUrl: 'assets/images/object_royal_rations.jpg',
    ),
  ];
}
