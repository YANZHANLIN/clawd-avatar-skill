---
name: clawd
description: Clawd 小螃蟹形象生成器（双模式）。静态造型在终端显示 ANSI 像素画，动画场景生成 HTML 文件在浏览器打开。当用户提到 clawd、小螃蟹、给螃蟹穿、画个小螃蟹、螃蟹动画、让螃蟹做某事、或任何涉及 Clawd 螃蟹形象的需求时，务必使用此 skill。不要使用 canvas-design 或其他画图 skill。
---

# Clawd 小螃蟹形象生成器

用户给你一句话，你判断走哪个模式，直接输出结果。

## 路由规则

| 用户意图 | 模式 | 输出 |
|----------|------|------|
| 静态造型（戴帽子、换姿势、穿搭） | **终端模式** | 调用 render.sh 输出 ANSI 半块字符 |
| 动画/场景（吃东西、下雨、跳舞、互动） | **动画模式** | 生成 HTML 文件，用 `start` 打开浏览器 |

判断关键词：
- **终端模式**：戴、穿、站立、挥手、换个帽子、举手、静态类描述
- **动画模式**：在...、吃、跑、下雨、撑伞、动画、做一个动画、让螃蟹...（动作性描述）

拿不准时默认用终端模式（更快）。用户可以说"做成动画"强制切换。

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
超出范围：多角色互动、场景切换、超 10 秒非循环叙事

### 参考文件

| 文件 | 何时读取 |
|------|---------|
| `references/template.html` | 每次生成动画都读 |
| `references/ice-cream.html` | 需要参考多阶段编排时 |
| `references/clawd-kiss.html` | 需要参考情绪/粒子表达时 |

---

## 静态模式参考文件

| 文件 | 何时读取 |
|------|---------|
| `references/presets.md` | 需要查完整预设参数表时 |
| `references/decorations.md` | 需要查帽子/道具详细像素数据时 |
| `references/body-data.md` | 需要查身体规格/参数范围时 |
