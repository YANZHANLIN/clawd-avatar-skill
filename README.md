# Clawd 小螃蟹形象生成器

Claude 吉祥物 **Clawd** 的像素风形象生成器，直接在终端里渲染。支持 15 种帽子、27 种道具、3 种面部配饰、27+ 身体颜色和完整的姿势控制 —— 全部用 ANSI 半块字符 + 真彩色渲染。

三种模式：终端 ANSI 渲染、浏览器 HTML 动画、**多角色像素全景大场景**。

![终端模式](https://img.shields.io/badge/模式-终端_ANSI-brightgreen) ![动画模式](https://img.shields.io/badge/模式-HTML_动画-blue) ![场景模式](https://img.shields.io/badge/模式-像素全景-orange)

## 效果展示

| 经典 | 路飞 | 哈利波特 | 鸣人 | 索隆 |
|:---:|:---:|:---:|:---:|:---:|
| ![Classic](assets/01-classic.png) | ![Luffy](assets/02-luffy.png) | ![Harry Potter](assets/03-harry-potter.png) | ![Naruto](assets/04-naruto.png) | ![Zoro](assets/05-zoro.png) |
| 默认造型 | 草帽+马甲 | 巫师帽+眼镜 | 忍者+螺旋丸 | 海贼+刀 |

| 晓组织 | 草裙舞 | 圣诞节 | 国王 | 程序员 |
|:---:|:---:|:---:|:---:|:---:|
| ![Akatsuki](assets/06-akatsuki.png) | ![Hula](assets/07-hula-dancer.png) | ![Christmas](assets/08-christmas.png) | ![King](assets/09-king.png) | ![Coder](assets/10-coder.png) |
| 斗笠+斗篷 | 花冠+草裙 | 圣诞帽 | 皇冠+爱心 | 笔记本电脑 |

## 快速开始

```bash
# 默认站立
bash scripts/render.sh

# 海贼王路飞
bash scripts/render.sh --hat straw --prop vest --eyes forward

# 哈利波特
bash scripts/render.sh --hat wizard --prop wand --accessory potter --color ruby

# 鸣人 + 螺旋丸
bash scripts/render.sh --hat ninja --prop rasengan --color orange --armR -3

# 粉色草裙舞者
bash scripts/render.sh --hat flower --prop hula --color hotpink --eyes sparkle --armL -3 --armR 1
```

## 三种模式

### 模式 A：终端模式

直接在终端里输出 ANSI 像素画。适合快速换装、生成静态造型。

```bash
bash scripts/render.sh --hat crown --eyes sparkle
```

### 模式 B：动画模式

生成自包含 HTML 文件，浏览器打开即可看动画。720×720 像素，30 FPS 无缝循环。适合单角色场景（吃东西、下雨、跳舞）。

### 模式 C：场景模式（v2 新增）

多角色像素风全景大场景 —— 类似 Pokemon 像素地图或清明上河图。

跟 Claude 说：
- 「画个春游大场景，很多螃蟹在公园里」
- 「像素公园全景图」
- 「清明上河图风格，很多螃蟹在做不同的事」

你会得到：
- **1440×1920 画布**（3:4 竖版），固定镜头，一眼看全
- **20-60 只螃蟹**做不同的事：野餐、钓鱼、放风筝、打篮球、做瑜伽、遛狗、画画、跳舞...
- **丰富地形**：湖泊、河流、桥梁、小路、花园、建筑（咖啡馆、凉亭、游乐场、集市摊位）
- **动态细节**：流水波纹、樱花花瓣、落叶、喷泉水花、蝴蝶、飘浮音符
- **边缘延伸**：建筑、树木、角色被画面边缘截断，暗示世界在画面外继续
- **16 种帽子**、裙子/服装颜色、完整的 16×9 Clawd 身体矩阵

场景模板在 `references/scene-template.html`，Claude 会读取它作为结构参考，根据你的主题生成对应的地形、建筑和角色活动。

## 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--eyes` | 眼睛方向/表情 | `forward` |
| `--armL` | 左手位置（-4 到 +4，负数=举高） | `0` |
| `--armR` | 右手位置（-4 到 +4） | `0` |
| `--legs` | 四条腿倾斜，逗号分隔 | `0,0,0,0` |
| `--hat` | 帽子/头饰 | `none` |
| `--prop` | 手持物品/场景道具 | `none` |
| `--color` | 身体颜色（预设名或 hex） | 默认橙 |
| `--accessory` | 面部配饰（可与 prop 共存） | `none` |

## 眼睛 (`--eyes`)

| 值 | 效果 |
|----|------|
| `forward` | 正视前方 |
| `right` / `left` | 左右看 |
| `up` / `down` | 上下看 |
| `blink` | 闭眼 |
| `sparkle` | 金色星星眼 |

## 帽子 (`--hat`)

| 值 | 说明 | 系列 |
|----|------|------|
| `none` | 无帽子 | - |
| `cap` | 棒球帽 | 基础 |
| `crown` | 皇冠 | 基础 |
| `party` | 派对帽 | 基础 |
| `chef` | 厨师帽 | 基础 |
| `purple` | 紫色礼帽 | 基础 |
| `headband` | 红色运动头带 | 基础 |
| `santa` | 圣诞帽 | 基础 |
| `flower` | 花冠 | 春日 |
| `straw` | 草帽（路飞） | 海贼王 |
| `pirate` | 三角海贼帽 | 海贼王 |
| `wizard` | 巫师帽（带星星） | 哈利波特 |
| `sorting` | 分院帽 | 哈利波特 |
| `ninja` | 忍者护额 | 火影忍者 |
| `akatsuki` | 晓组织斗笠 | 火影忍者 |

## 道具 (`--prop`)

### 基础
| 值 | 说明 |
|----|------|
| `heart` | 红色爱心 |
| `ball` | 足球 |
| `laptop` | 笔记本电脑 |
| `cake` | 生日蛋糕 |
| `scarf` | 红色围巾 |

### 运动
| 值 | 说明 |
|----|------|
| `surfboard` | 冲浪板 |
| `dumbbells` | 哑铃（跟随手臂） |
| `boxing` | 拳击手套（跟随手臂） |

### 春日 / 热带
| 值 | 说明 |
|----|------|
| `hula` | 草裙（三层流苏） |
| `bouquet` | 手捧花 |
| `lei` | 花环项链 |
| `butterfly` | 粉色蝴蝶 |
| `vest` | 红色马甲 |

### 哈利波特
| 值 | 说明 |
|----|------|
| `wand` | 魔杖（带星星） |
| `snitch` | 金色飞贼 |
| `broom` | 飞天扫帚 |
| `hpscarf` | 格兰芬多围巾 |

### 火影忍者
| 值 | 说明 |
|----|------|
| `kunai` | 苦无 |
| `shuriken` | 手里剑 |
| `rasengan` | 螺旋丸（跟随手臂） |
| `cloak` | 晓组织斗篷 |

### 海贼王
| 值 | 说明 |
|----|------|
| `katana` | 武士刀 |
| `meat` | 大肉腿 |
| `flag` | 海贼旗 |
| `barrel` | 酒桶 |

## 面部配饰 (`--accessory`)

可以和任何 `--prop` 同时使用：

| 值 | 说明 |
|----|------|
| `glasses` | 圆框眼镜 |
| `scar` | 闪电疤痕 |
| `potter` | 眼镜 + 疤痕组合 |

## 身体颜色 (`--color`)

**27 种预设色：**

| 暖色系 | 冷色系 | 紫色系 | 中性 |
|--------|--------|--------|------|
| `pink` `hotpink` `rose` | `sky` `blue` `sapphire` | `lavender` `violet` `purple` | `white` |
| `coral` `peach` `cherry` | `ocean` `turquoise` `teal` | | |
| `ruby` `red` `sunset` | `mint` `green` `emerald` | | |
| `tangerine` `orange` `amber` | `lime` | | |
| `gold` `yellow` `lemon` | | | |

**自定义 hex：** `--color FF6B9D` 或 `--color "#FF6B9D"`

不指定时使用经典 Clawd 橙 `#CD6E58`。

## 渲染层级

```
 1. 底层道具     (冲浪板、扫帚、蛋糕、笔记本、围巾)
 2. 身体
 3. 腿
 4. 覆盖层道具   (草裙、花环、斗篷、马甲)
 5. 手臂
 6. 眼睛
 7. 面部配饰     (眼镜、疤痕)
 8. 帽子
 9. 顶层道具     (魔杖、爱心、飞贼、刀、肉腿、旗帜等)
10. 跟随手臂道具 (哑铃、拳击手套、螺旋丸)
```

## 输出格式

```bash
# 终端 ANSI（默认）
bash scripts/render.sh --hat crown

# HTML 文件
bash scripts/render.sh --hat crown --html output.html

# PNG 图片（需要 ffmpeg）
bash scripts/render.sh --hat crown --png output.png
```

## 角色预设速查

| 角色 | 命令 |
|------|------|
| **路飞** | `--hat straw --prop vest --eyes forward` |
| **索隆** | `--hat pirate --prop katana --color emerald --eyes right` |
| **晓组织** | `--hat akatsuki --prop cloak` |
| **哈利波特** | `--hat wizard --prop wand --accessory potter` |
| **魁地奇** | `--hat sorting --prop snitch --accessory glasses --color gold` |
| **鸣人** | `--hat ninja --prop rasengan --color orange --armR -3` |

## 文件结构

```
clawd/
├── SKILL.md                  # Skill 定义（三模式路由、参数说明）
├── README.md                 # 本文件
├── scripts/
│   └── render.sh             # 核心渲染引擎（690 行）
└── references/
    ├── template.html         # 动画模式 HTML 模板
    ├── scene-template.html   # 场景模式 HTML 模板（v2）
    ├── ice-cream.html        # 动画参考：多阶段编排
    ├── clawd-kiss.html       # 动画参考：情绪/粒子效果
    ├── body-data.md          # 身体像素数据
    ├── decorations.md        # 帽子/道具像素数据
    └── presets.md             # 预设参数速查
```

## 更新日志

### v2 — 场景模式

- 新增**模式 C：场景模式** — 多角色像素全景大场景
- 1440×1920（3:4）画布，360×480 格网格
- 完整 16×9 Clawd 身体矩阵 + 16 种帽子 + 服装颜色
- 程序化地形生成：湖泊、河流、小溪、路径（基于噪声的草地变化）
- 建筑设施：咖啡馆、凉亭、游乐场、篮球场、集市摊位、瑜伽区
- 粒子系统：樱花花瓣、秋叶、喷泉水花
- 水面动画预计算，保证流畅性能
- 边缘延伸设计：无围墙，内容延伸到画面外
- 场景模板 `references/scene-template.html`

### v1 — 首次发布

- 终端模式：render.sh 渲染 ANSI 半块像素画
- 动画模式：单角色 HTML 动画（720×720）
- 15 种帽子、27 种道具、3 种面部配饰、27+ 身体颜色
- 动漫 cosplay 系列：海贼王、火影忍者、哈利波特

## 许可证

MIT
