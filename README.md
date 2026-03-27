# Clawd Avatar Skill

A pixel-art avatar generator for **Clawd** (the Claude mascot crab) that runs directly in your terminal. Supports 15 hats, 27 props, 3 face accessories, 27+ body colors, and full pose control — all rendered as ANSI half-block characters with true color.

Three modes: terminal ANSI rendering, browser-based HTML animations, and **multi-character pixel scene panoramas**.

![Terminal Mode](https://img.shields.io/badge/mode-terminal_ANSI-brightgreen) ![Animation Mode](https://img.shields.io/badge/mode-HTML_animation-blue) ![Scene Mode](https://img.shields.io/badge/mode-pixel_scene-orange)

## Gallery

| Classic | Luffy | Harry Potter | Naruto | Zoro |
|:---:|:---:|:---:|:---:|:---:|
| ![Classic](assets/01-classic.png) | ![Luffy](assets/02-luffy.png) | ![Harry Potter](assets/03-harry-potter.png) | ![Naruto](assets/04-naruto.png) | ![Zoro](assets/05-zoro.png) |
| Default | Straw hat + vest | Wizard + potter | Ninja + rasengan | Pirate + katana |

| Akatsuki | Hula Dancer | Christmas | King | Coder |
|:---:|:---:|:---:|:---:|:---:|
| ![Akatsuki](assets/06-akatsuki.png) | ![Hula](assets/07-hula-dancer.png) | ![Christmas](assets/08-christmas.png) | ![King](assets/09-king.png) | ![Coder](assets/10-coder.png) |
| Kasa + cloak | Flower + hula | Santa hat | Crown + heart | Laptop |

## Quick Start

```bash
# Default standing Clawd
bash scripts/render.sh

# Luffy from One Piece
bash scripts/render.sh --hat straw --prop vest --eyes forward

# Harry Potter
bash scripts/render.sh --hat wizard --prop wand --accessory potter --color ruby

# Naruto with Rasengan
bash scripts/render.sh --hat ninja --prop rasengan --color orange --armR -3

# Pink hula dancer with flower crown
bash scripts/render.sh --hat flower --prop hula --color hotpink --eyes sparkle --armL -3 --armR 1
```

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--eyes` | Eye direction / expression | `forward` |
| `--armL` | Left arm position (-4 to +4, negative = raised) | `0` |
| `--armR` | Right arm position (-4 to +4) | `0` |
| `--legs` | Four leg tilts, comma-separated | `0,0,0,0` |
| `--hat` | Headwear | `none` |
| `--prop` | Held item / scene prop | `none` |
| `--color` | Body color (preset name or hex) | default orange |
| `--accessory` | Face accessory (coexists with prop) | `none` |

## Eyes (`--eyes`)

| Value | Effect |
|-------|--------|
| `forward` | Looking straight ahead |
| `right` / `left` | Looking sideways |
| `up` / `down` | Looking up / down |
| `blink` | Eyes closed |
| `sparkle` | Golden star eyes |

## Hats (`--hat`)

| Value | Description | Series |
|-------|-------------|--------|
| `none` | No hat | - |
| `cap` | Baseball cap | Basic |
| `crown` | Golden crown | Basic |
| `party` | Party hat | Basic |
| `chef` | Chef hat | Basic |
| `purple` | Purple top hat | Basic |
| `headband` | Red sport headband | Basic |
| `santa` | Santa hat | Basic |
| `flower` | Flower crown | Spring |
| `straw` | Straw hat (Luffy) | One Piece |
| `pirate` | Tricorn pirate hat | One Piece |
| `wizard` | Wizard hat with stars | Harry Potter |
| `sorting` | Sorting Hat (floppy) | Harry Potter |
| `ninja` | Ninja forehead protector | Naruto |
| `akatsuki` | Akatsuki kasa with paper strips | Naruto |

## Props (`--prop`)

### Basic
| Value | Description |
|-------|-------------|
| `heart` | Red heart |
| `ball` | Soccer ball |
| `laptop` | Laptop computer |
| `cake` | Birthday cake with candle |
| `scarf` | Red scarf |

### Sport
| Value | Description |
|-------|-------------|
| `surfboard` | Surfboard with waves |
| `dumbbells` | Dumbbells (follow arms) |
| `boxing` | Boxing gloves (follow arms) |

### Spring / Tropical
| Value | Description |
|-------|-------------|
| `hula` | Grass skirt (3-layer fringe) |
| `bouquet` | Flower bouquet |
| `lei` | Flower lei necklace |
| `butterfly` | Pink butterfly |
| `vest` | Red vest (open front) |

### Harry Potter
| Value | Description |
|-------|-------------|
| `wand` | Magic wand with star |
| `snitch` | Golden Snitch with wings |
| `broom` | Flying broomstick |
| `hpscarf` | Gryffindor house scarf |

### Naruto
| Value | Description |
|-------|-------------|
| `kunai` | Kunai knife |
| `shuriken` | Throwing star |
| `rasengan` | Rasengan energy ball (follows arm) |
| `cloak` | Akatsuki cloak with red clouds |

### One Piece
| Value | Description |
|-------|-------------|
| `katana` | Katana sword |
| `meat` | Big drumstick |
| `flag` | Pirate Jolly Roger flag |
| `barrel` | Sake barrel |

## Face Accessories (`--accessory`)

Can be used alongside any `--prop`:

| Value | Description |
|-------|-------------|
| `glasses` | Round glasses |
| `scar` | Lightning bolt scar |
| `potter` | Glasses + scar combo |

## Body Colors (`--color`)

**27 preset names:**

| Warm | Cool | Purple | Neutral |
|------|------|--------|---------|
| `pink` `hotpink` `rose` | `sky` `blue` `sapphire` | `lavender` `violet` `purple` | `white` |
| `coral` `peach` `cherry` | `ocean` `turquoise` `teal` | | |
| `ruby` `red` `sunset` | `mint` `green` `emerald` | | |
| `tangerine` `orange` `amber` | `lime` | | |
| `gold` `yellow` `lemon` | | | |

**Custom hex:** `--color FF6B9D` or `--color "#FF6B9D"`

If omitted, the classic Clawd orange `#CD6E58` is used.

## Render Z-Order

```
 1. Bottom props     (surfboard, broom, cake, laptop, scarf, hpscarf)
 2. Body
 3. Legs
 4. Overlay props    (hula, lei, cloak, vest)
 5. Arms
 6. Eyes
 7. Face accessories (glasses, scar, potter)
 8. Hat
 9. Top props        (wand, heart, snitch, katana, meat, flag, etc.)
10. Arm-follow props (dumbbells, boxing, rasengan)
```

## Output Modes

```bash
# Terminal ANSI (default)
bash scripts/render.sh --hat crown

# HTML file
bash scripts/render.sh --hat crown --html output.html

# PNG file (requires ffmpeg)
bash scripts/render.sh --hat crown --png output.png
```

## Animation Mode

For dynamic scenes (eating, dancing, rain), the skill generates a self-contained HTML file using `references/template.html` as a base. These are 720×720 pixel-art animations at 30 FPS with seamless looping.

## Scene Mode (v2)

For multi-character panoramic scenes — think Pokemon pixel maps or 清明上河图 (Along the River During the Qingming Festival).

Tell Claude something like:
- "Draw a big scene with lots of crabs at a spring picnic"
- "Make a pixel park panorama"
- "清明上河图 style, many crabs doing different activities"

What you get:
- **1440×1920 canvas** (3:4 portrait), fixed camera, see everything at once
- **20-60 crabs** doing different things: picnicking, fishing, kite-flying, playing basketball, doing yoga, walking dogs, painting, dancing...
- **Rich terrain**: lakes, rivers, bridges, paths, flower gardens, buildings (cafes, gazebos, playgrounds, market stalls)
- **Animated details**: flowing water, cherry blossom petals, falling leaves, fountain spray, butterflies, floating music notes
- **Edge bleed**: buildings, trees, and crabs cut off at borders — the world extends beyond the frame
- **16 hat types**, dress/skirt colors, and the full 16×9 Clawd body matrix for detailed characters

The scene template lives at `references/scene-template.html`. Claude reads it as a structural reference and adapts the terrain, buildings, and character activities to match your theme.

## Character Presets

| Character | Command |
|-----------|---------|
| **Luffy** | `--hat straw --prop vest --eyes forward` |
| **Zoro** | `--hat pirate --prop katana --color emerald --eyes right` |
| **Akatsuki** | `--hat akatsuki --prop cloak` |
| **Harry Potter** | `--hat wizard --prop wand --accessory potter` |
| **Quidditch** | `--hat sorting --prop snitch --accessory glasses --color gold` |
| **Naruto** | `--hat ninja --prop rasengan --color orange --armR -3` |

## File Structure

```
clawd/
├── SKILL.md              # Skill definition (3-mode routing, parameters)
├── README.md             # This file
├── scripts/
│   └── render.sh         # Core rendering engine (690 lines)
└── references/
    ├── template.html     # Animation mode HTML template
    ├── scene-template.html # Scene mode HTML template (v2)
    ├── ice-cream.html    # Animation reference: multi-stage choreography
    ├── clawd-kiss.html   # Animation reference: emotion/particle effects
    ├── body-data.md      # Body pixel specifications
    ├── decorations.md    # Hat/prop pixel data
    └── presets.md        # Preset parameter quick reference
```

## Changelog

### v2 — Scene Mode

- Added **Mode C: Scene Mode** for multi-character pixel panoramas
- 1440×1920 (3:4) canvas with 360×480 tile grid
- Full 16×9 Clawd body matrix with 16 hat types and dress colors
- Procedural terrain: lakes, rivers, streams, paths with noise-based grass variation
- Buildings: cafes, gazebos, playgrounds, basketball courts, market stalls, yoga areas
- Particle systems: cherry blossoms, autumn leaves, fountain spray
- Pre-computed water tile lists for smooth animation performance
- Edge bleed design: no walls, content extends beyond frame borders
- Scene template at `references/scene-template.html`

### v1 — Initial Release

- Terminal mode: ANSI half-block pixel art with render.sh
- Animation mode: Single-character HTML animations (720×720)
- 15 hats, 27 props, 3 face accessories, 27+ body colors
- Anime cosplay series: One Piece, Naruto, Harry Potter

## License

MIT
