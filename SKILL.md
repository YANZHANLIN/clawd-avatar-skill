---
name: clawd
description: Clawd 小螃蟹形象生成器（三模式）。静态造型在终端显示 ANSI 像素画，动画场景生成 HTML 文件在浏览器打开，大场景模式生成多角色像素全景图。当用户提到 clawd、小螃蟹、给螃蟹穿、画个小螃蟹、螃蟹动画、让螃蟹做某事、大场景、全景、清明上河图、很多螃蟹、或任何涉及 Clawd 螃蟹形象的需求时，务必使用此 skill。不要使用 canvas-design 或其他画图 skill。
---

# Clawd 小螃蟹形象生成器

用户给你一句话，你判断走哪个模式，直接输出结果。

## 路由规则

| 用户意图 | 模式 | 输出 |
|----------|------|------|
| 静态造型（戴帽子、换姿势、穿搭） | **终端模式** | 调用 render.sh 输出 ANSI 半块字符 |
| 单角色动画（吃东西、下雨、跳舞） | **动画模式** | 生成 HTML 文件，用 `start` 打开浏览器 |
| 多角色大场景（全景、很多螃蟹、像素公园） | **场景模式** | 生成大地图 HTML，用 `start` 打开浏览器 |

判断关键词：
- **终端模式**：戴、穿、站立、挥手、换个帽子、举手、静态类描述
- **动画模式**：在...、吃、跑、下雨、撑伞、动画、做一个动画、让螃蟹...（单角色动作性描述）
- **场景模式**：大场景、全景、很多螃蟹、清明上河图、像素公园、一群螃蟹在...、俯视、春游、集体活动

拿不准时默认用终端模式（更快）。用户可以说"做成动画"或"做成大场景"强制切换。

---

## 模式 A：终端模式

调用 render.sh 在终端直接显示 ANSI 像素画。

### 调用方式

```bash
bash ~/.claude/skills/clawd/scripts/render.sh \
  --eyes forward --armL 0 --armR 0 --legs 0,0,0,0 --hat none --prop none
```

### 参数

| 参数 | 值 | 默认 |
|------|----|------|
| `--eyes` | forward/right/left/down/up/blink/sparkle | forward |
| `--armL` | -4 到 +4（负=举高） | 0 |
| `--armR` | -4 到 +4 | 0 |
| `--legs` | 4个逗号分隔数字 | 0,0,0,0 |
| `--hat` | none/purple/santa/crown/wizard/chef/party/headband/cap | none |
| `--prop` | none/ball/wand/heart/laptop/dumbbells/surfboard/cake/boxing/scarf | none |

### 预设速查

| 触发词 | --eyes | --armL | --armR | --legs | --hat | --prop |
|--------|--------|--------|--------|--------|-------|--------|
| 站立 | forward | 0 | 0 | 0,0,0,0 | none | none |
| 挥手 | forward | 0 | -3 | 0,0,0,0 | none | none |
| 欢呼 | sparkle | -4 | -4 | -1,0,0,1 | none | none |
| 奔跑 | forward | -2 | 2 | -1,-1,1,1 | none | none |
| 踢球 | right | 0 | 0 | 0,0,0,2 | none | ball |
| 沮丧 | down | 3 | 3 | 0,0,0,0 | none | none |
| 睡觉 | blink | 0 | 0 | 0,0,0,0 | none | none |
| 举重 | forward | -3 | -3 | -1,0,0,1 | headband | dumbbells |
| 冲浪 | forward | 0 | 0 | 0,0,0,0 | none | surfboard |
| 拳击 | forward | -3 | -3 | -1,0,0,1 | headband | boxing |
| 巫师 | forward | 0 | -2 | 0,0,0,0 | wizard | wand |
| 圣诞 | sparkle | -4 | -4 | 0,0,0,0 | santa | none |
| 生日 | sparkle | -4 | -4 | 0,0,0,0 | party | cake |
| 厨师 | forward | 2 | 2 | 0,0,0,0 | chef | none |
| 写代码 | down | 2 | 2 | 0,0,0,0 | none | laptop |
| 跳舞 | sparkle | -3 | 1 | -2,0,0,2 | none | heart |

### 组合规则

- "戴皇冠踢球" → 踢球预设 + hat=crown
- "手再举高一点" → 当前 armL/armR 各 -1
- 帽子/道具冲突：后者覆盖

### 会话状态

记住当前参数组合。用户追加修改时在当前基础上调整。

---

## 模式 B：动画模式

生成自包含 HTML 像素风动画文件，在浏览器中打开。

### 流程

1. **解析意图**：提取核心动作、情绪、道具、场景氛围
2. **设计剧本**：3-6 个阶段，总时长 4-8 秒循环
3. **读取模板**：`~/.claude/skills/clawd/references/template.html`
4. **生成代码**：在 `YOUR ANIMATION HERE` 区域填入动画逻辑
5. **保存并打开**：`start <file>` 在浏览器中查看

### 设计规范

- 画布 720×720，逻辑网格 36×36（每格 20px）
- Clawd 14×8 扁平宽体，单色 `#CD6E58`，无渐变
- 眼睛 1×1 纯黑像素，**没有嘴巴**——情绪靠眼睛方向 + 粒子 + 气泡表达
- 背景装饰用 `drawFloatingDots(f)`（缓慢漂浮的半透明圆点），**不要用 drawStars**
- 单 HTML 文件，零依赖，30 FPS
- 动画首尾无缝循环

### 动画质量标准

- 必须有"起承转合"节奏感，不是匀速运动
- 用 easeOut 做进入，easeInOut 做移动
- 关键动作瞬间加粒子效果
- Clawd 表情配合剧情（发现东西时看向目标，开心时跳）
- 对话气泡用于关键情绪节点

### 新道具设计

场景需要模板中没有的道具时：
- 在 36×36 网格中设计，道具≤10×15格，颜色≤5种
- 包含高光点（白色像素），保持像素风简洁感
- 数据格式：二维数组 + palette 映射

### 复杂度边界

合理：单角色、单场景、简单叙事（吃冰淇淋、撑伞、收到信）
超出范围：多角色互动、场景切换、超 10 秒非循环叙事 → **改用场景模式**

### 参考文件

| 文件 | 何时读取 |
|------|---------|
| `references/template.html` | 每次生成动画都读 |
| `references/ice-cream.html` | 需要参考多阶段编排时 |
| `references/clawd-kiss.html` | 需要参考情绪/粒子表达时 |

---

## 模式 C：场景模式

生成多角色像素风大场景全景图，俯视视角，多只螃蟹在不同区域做不同的事。类似清明上河图 / Pokemon 像素地图风格。

### 流程

1. **解析主题**：提取场景主题（春游、派对、运动会、办公室等）
2. **设计地图**：规划区域布局（建筑、地形、设施），确保画面上下左右都满
3. **读取模板**：`references/scene-template.html`
4. **修改内容**：替换地形函数、建筑物、角色活动、粒子效果
5. **保存并打开**：`start <file>` 在浏览器中查看

### 技术规格

- 画布：1440×1920（3:4 竖版），逻辑网格 360×480，每格 T=4px
- 镜头固定，一眼看全，不平移
- 螃蟹用 16×9 格原版身体矩阵（比动画模式更大更精细）
- 支持 16 种帽子：flower/chef/party/cap/crown/headband/straw/santa/wizard/sunhat/beret/tophat/beanie/ribbon/bandana/tiara
- 裙子/dress 通过 `opts.dress` 颜色参数实现
- 静态地形渲染一次缓存到离屏 canvas，只有水面/角色/粒子每帧重绘
- 水面动画用 `precomputeWater()` 预计算坐标列表，避免全图遍历

### 场景设计原则

- **角色数量**：20-60 只螃蟹，分布在不同区域
- **活动类型**：1人独处、2人互动、3-5人群组，混搭分布
- **边缘处理**：不要围墙！建筑/树/角色被画面边缘截断，暗示世界继续延伸
- **地形丰富**：湖泊、河流、小溪、路径、草地、花田、沙地 —— 不留大片空白
- **建筑设施**：咖啡馆、凉亭、游乐场、球场、集市摊位、码头、桥梁等
- **粒子系统**：樱花花瓣、落叶、喷泉水花 —— 让画面有生命感
- **动画循环**：每只螃蟹有独立的动画周期（眼睛/手臂/位移），通过 `frame % N` 控制

### crab() 函数签名

```javascript
crab(cx, cy, {
  color: '#CD6E58',    // 身体颜色，默认螃蟹橙
  eyes: 'forward',     // forward/right/left/down/up/blink/sparkle
  armL: 0,             // -4 到 +4，负=举高（乘以2映射到格子偏移）
  armR: 0,
  hat: 'flower',       // 16种帽子之一，或 null
  dress: '#FF88AA',    // 裙子/下装颜色，或 null
})
```

### 参考文件

| 文件 | 何时读取 |
|------|---------|
| `references/scene-template.html` | 每次生成场景都读，作为完整参考（地形系统+crab函数+粒子+结构） |

---

## 静态模式参考文件

| 文件 | 何时读取 |
|------|---------|
| `references/presets.md` | 需要查完整预设参数表时 |
| `references/decorations.md` | 需要查帽子/道具详细像素数据时 |
| `references/body-data.md` | 需要查身体规格/参数范围时 |
