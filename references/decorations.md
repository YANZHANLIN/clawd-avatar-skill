# Clawd 装饰数据 — 帽子和道具

所有坐标相对于身体原点 (ox=col 6, oy=row 8 in canvas)。

## 帽子

### purple — 紫色帽+星花
- oy-1: PP at cols 3-12
- oy-2: PP at cols 4-11
- oy-3: PD at cols 4-11
- oy-4: PD at cols 5-10
- oy-5: PD at cols 6-9
- oy-6: GY at cols 7-8 (茎)
- oy-7: PS at cols 6-9 (星花)
- oy-8: PS at cols 7-8

### santa — 圣诞帽
- oy-1: WH at cols 3-12 (白边)
- oy-2: RD at cols 4-11
- oy-3: RD at cols 5-10
- oy-4: RD at cols 6-9
- oy-5: RD at cols 7-8
- oy-6: WH at cols 7-8 (毛球)

### crown — 皇冠
- oy-1: YL at cols 4-11
- oy-2: YL at cols 4-11, RD at cols 6,9 (宝石)
- oy-3: YL at cols 4,7,8,11 (尖顶)

### wizard — 巫师帽
- oy-1: PP at cols 3-12
- oy-2: PP at cols 4-11, PS at col 8
- oy-3: PP at cols 5-10, PS at col 6
- oy-4: PP at cols 5-10, PS at col 9
- oy-5: PP at cols 6-9, PS at col 7
- oy-6: PP at cols 7-8
- oy-7: PP at col 7

### chef — 厨师帽
- oy-1: WH at cols 3-12
- oy-2: WH at cols 4-11
- oy-3: WH at cols 4-11
- oy-4: WH at cols 5-10
- oy-5: WH at cols 5-10

### party — 派对帽
- oy-1: PK at cols 4-11
- oy-2: PK at cols 5-10, YL at cols 6,9 (条纹)
- oy-3: PK at cols 6-9
- oy-4: PK at cols 7-8
- oy-5: YL at cols 7-8 (尖顶)

### headband — 头带
- oy (row 0): RD at cols 3-12

### cap — 鸭舌帽
- oy-1: BL at cols 3-12
- oy: BL at cols 3-15 (帽檐向右延伸)

## 道具

### ball — 足球 (3×3)
固定位置:
- oy+5: W at ox+16, GN at ox+17, W at ox+18
- oy+6: GN at ox+16, W at ox+17, GN at ox+18
- oy+7: W at ox+16, GN at ox+17, W at ox+18

### wand — 魔杖
固定位置:
- 杖身: BR at ox+15, rows oy-2 to oy-6
- 星花: SP cross at (oy-6, ox+14..16) + (oy-7, ox+15) + (oy-5, ox+15)

### heart — 爱心
固定位置:
- oy-2: RD at ox+16, ox+18
- oy-1: RD at ox+16, ox+17, ox+18
- oy: RD at ox+17

### laptop — 笔记本
固定位置:
- oy+6: BL at cols 5-10, W at cols 6,8 (屏幕)
- oy+7: GY at cols 5-10 (键盘)
- oy+8: BK at cols 5-10 (底座)

### dumbbells — 哑铃 (动态跟随手臂)
- 左: GY 2×2 at (oy+2+armL-2, ox+0) and (oy+2+armL-1, ox+0)
- 右: GY 2×2 at (oy+2+armR-2, ox+14) and (oy+2+armR-1, ox+14)

### surfboard — 冲浪板+波浪
- oy+8: SB from ox-2 to ox+17 (20 wide), SG at edges (ox-2..ox-1, ox+16..ox+17)
- oy+9: WV/W2 alternating across full canvas width (28 cols)

### cake — 蛋糕
- oy+8: CK at cols 3-12
- oy+9: alternating PK/CK at cols 3-12 (every 3rd = PK)
- oy+7: W at cols 7-8 (蜡烛)
- oy+6: YL at cols 7-8 (火焰)

### boxing — 拳套 (动态跟随手臂)
- 左: BK 2×2 at (oy+2+armL-2, ox+1) and (oy+2+armL-1, ox+1)
- 右: BK 2×2 at (oy+2+armR-2, ox+13) and (oy+2+armR-1, ox+13)

### scarf — 围巾
- oy+6: RD/#CC2222 alternating at cols 3-12 (覆盖腿 row 6)
- 垂尾: RD at (oy+7, ox+12), (oy+8, ox+12), #CC2222 at (oy+9, ox+12)
