#!/usr/bin/env bash
# Clawd TUI Avatar Renderer
# Usage: bash render.sh --eyes forward --armL 0 --armR -3 --legs 0,0,0,0 --hat santa --prop wand

set -euo pipefail

# ═══ CANVAS ═══
W=28; H=20
declare -a GRID
for ((i=0; i<W*H; i++)); do GRID[$i]=""; done

set_px() { # row col color_rgb
  local r=$1 c=$2 color=$3
  if ((r>=0 && r<H && c>=0 && c<W)); then
    GRID[$((r*W+c))]="$color"
  fi
}

# ═══ COLORS ═══
O="205;110;88"    # body
K="0;0;0"         # eyes
SP="255;215;0"    # sparkle
PP="68;51;136"    # deep purple
PD="153;119;204"  # light purple
PS="187;170;238"  # sparkle purple
GY="136;136;136"  # gray
RD="220;40;40"    # red
WH="240;240;240"  # white
YL="255;221;51"   # yellow
PK="255;136;170"  # pink
BL="51;102;204"   # blue
BK="51;51;51"     # dark
BR="139;85;32"    # brown
GN="68;170;68"    # green
WC="255;255;255"  # pure white
SB="34;136;221"   # surf blue
SG="34;187;102"   # surf green
WV="68;153;221"   # wave
W2="119;187;238"  # wave light
CK="153;102;51"   # cake brown
SC="204;34;34"    # scarf dark

# ═══ PARSE ARGS ═══
EYES="forward"; ARML=0; ARMR=0; LEGS="0,0,0,0"; HAT="none"; PROP="none"; OUTPUT="ansi"
PNG_FILE=""; HTML_FILE=""; COLOR=""; ACCESSORY="none"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --eyes)      EYES="$2"; shift 2;;
    --armL)      ARML="$2"; shift 2;;
    --armR)      ARMR="$2"; shift 2;;
    --legs)      LEGS="$2"; shift 2;;
    --hat)       HAT="$2"; shift 2;;
    --prop)      PROP="$2"; shift 2;;
    --color)     COLOR="$2"; shift 2;;
    --accessory) ACCESSORY="$2"; shift 2;;
    --html)      OUTPUT="html"; HTML_FILE="$2"; shift 2;;
    --png)       OUTPUT="png"; PNG_FILE="$2"; shift 2;;
    *) shift;;
  esac
done

# ═══ CUSTOM BODY COLOR ═══
if [[ -n "$COLOR" ]]; then
  case "$COLOR" in
    pink)       O="255;182;193";;
    coral)      O="255;127;80";;
    gold)       O="255;215;0";;
    sky)        O="135;206;235";;
    mint)       O="152;251;152";;
    lavender)   O="186;147;230";;
    peach)      O="255;218;185";;
    sunset)     O="255;99;71";;
    ocean)      O="0;119;190";;
    lime)       O="50;205;50";;
    hotpink)    O="255;105;180";;
    turquoise)  O="64;224;208";;
    ruby)       O="224;17;95";;
    emerald)    O="80;200;120";;
    sapphire)   O="15;82;186";;
    amber)      O="255;191;0";;
    violet)     O="138;43;226";;
    teal)       O="0;128;128";;
    rose)       O="255;0;127";;
    cherry)     O="222;49;99";;
    lemon)      O="255;247;0";;
    tangerine)  O="255;159;0";;
    white)      O="240;240;240";;
    red)        O="220;40;40";;
    blue)       O="51;102;204";;
    green)      O="68;170;68";;
    yellow)     O="255;221;51";;
    purple)     O="138;43;226";;
    orange)     O="255;165;0";;
    *)
      # hex color: FF6B9D or #FF6B9D
      hex="${COLOR#\#}"
      if [[ "$hex" =~ ^[0-9a-fA-F]{6}$ ]]; then
        O="$((16#${hex:0:2}));$((16#${hex:2:2}));$((16#${hex:4:2}))"
      fi
      ;;
  esac
fi

IFS=',' read -ra LEG_TILT <<< "$LEGS"
while ((${#LEG_TILT[@]}<4)); do LEG_TILT+=(0); done

# ═══ BODY ORIGIN ═══
OY=8; OX=6

# ═══ BODY DATA (16×8) ═══
BODY=(
  "0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0"
  "0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0"
  "0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0"
  "0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0"
  "0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0"
  "0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0"
  "0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,0"
  "0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,0"
)

# ═══ DRAW FUNCTIONS ═══

draw_body() {
  for ((r=0; r<6; r++)); do
    IFS=',' read -ra ROW <<< "${BODY[$r]}"
    for ((c=0; c<16; c++)); do
      # Skip arm zones (will draw separately)
      if ((r>=2 && r<=3 && (c<=2 || c>=13))); then continue; fi
      if [[ "${ROW[$c]}" == "1" ]]; then
        set_px $((OY+r)) $((OX+c)) "$O"
      fi
    done
  done
}

draw_eyes() {
  local lc=5 lr=1 rc=10 rr=1 color="$K"
  case "$EYES" in
    forward) ;;
    right)   ((lc++,1)); ((rc++,1));;
    left)    ((lc--,1)); ((rc--,1));;
    down)    ((lr++,1)); ((rr++,1));;
    up)      # Only 1px high when looking up
             set_px $((OY+lr-1)) $((OX+lc)) "$K"
             set_px $((OY+rr-1)) $((OX+rc)) "$K"
             return;;
    blink)   return;;
    sparkle) color="$SP";;
  esac
  set_px $((OY+lr))   $((OX+lc)) "$color"
  set_px $((OY+lr+1)) $((OX+lc)) "$color"
  set_px $((OY+rr))   $((OX+rc)) "$color"
  set_px $((OY+rr+1)) $((OX+rc)) "$color"
}

draw_arms() {
  # Left arm: 2×2 at (OY+2+armL, OX+1)
  local lr=$((OY+2+ARML))
  set_px $lr     $((OX+1)) "$O"; set_px $lr     $((OX+2)) "$O"
  set_px $((lr+1)) $((OX+1)) "$O"; set_px $((lr+1)) $((OX+2)) "$O"
  # Right arm: 2×2 at (OY+2+armR, OX+13)
  local rr=$((OY+2+ARMR))
  set_px $rr     $((OX+13)) "$O"; set_px $rr     $((OX+14)) "$O"
  set_px $((rr+1)) $((OX+13)) "$O"; set_px $((rr+1)) $((OX+14)) "$O"
}

draw_legs() {
  local leg_cols=(4 6 9 11)
  for ((i=0; i<4; i++)); do
    local c=${leg_cols[$i]}
    local t=${LEG_TILT[$i]}
    set_px $((OY+6)) $((OX+c)) "$O"
    set_px $((OY+7)) $((OX+c+t)) "$O"
  done
}

# ═══ HATS ═══
draw_hat() {
  case "$HAT" in
    none) ;;
    purple)
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY-1)) $((OX+c)) "$PP"; done
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-2)) $((OX+c)) "$PP"; set_px $((OY-3)) $((OX+c)) "$PD"; done
      for c in 5 6 7 8 9 10; do set_px $((OY-4)) $((OX+c)) "$PD"; done
      for c in 6 7 8 9; do set_px $((OY-5)) $((OX+c)) "$PD"; done
      set_px $((OY-6)) $((OX+7)) "$GY"; set_px $((OY-6)) $((OX+8)) "$GY"
      for c in 6 7 8 9; do set_px $((OY-7)) $((OX+c)) "$PS"; done
      set_px $((OY-8)) $((OX+7)) "$PS"; set_px $((OY-8)) $((OX+8)) "$PS"
      ;;
    santa)
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY-1)) $((OX+c)) "$WH"; done
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-2)) $((OX+c)) "$RD"; done
      for c in 5 6 7 8 9 10; do set_px $((OY-3)) $((OX+c)) "$RD"; done
      for c in 6 7 8 9; do set_px $((OY-4)) $((OX+c)) "$RD"; done
      for c in 7 8; do set_px $((OY-5)) $((OX+c)) "$RD"; done
      set_px $((OY-6)) $((OX+7)) "$WH"; set_px $((OY-6)) $((OX+8)) "$WH"
      ;;
    crown)
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-1)) $((OX+c)) "$YL"; set_px $((OY-2)) $((OX+c)) "$YL"; done
      set_px $((OY-3)) $((OX+4)) "$YL"; set_px $((OY-3)) $((OX+7)) "$YL"
      set_px $((OY-3)) $((OX+8)) "$YL"; set_px $((OY-3)) $((OX+11)) "$YL"
      set_px $((OY-2)) $((OX+6)) "$RD"; set_px $((OY-2)) $((OX+9)) "$RD"
      ;;
    wizard)
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY-1)) $((OX+c)) "$PP"; done
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-2)) $((OX+c)) "$PP"; done
      for c in 5 6 7 8 9 10; do set_px $((OY-3)) $((OX+c)) "$PP"; set_px $((OY-4)) $((OX+c)) "$PP"; done
      for c in 6 7 8 9; do set_px $((OY-5)) $((OX+c)) "$PP"; done
      for c in 7 8; do set_px $((OY-6)) $((OX+c)) "$PP"; done
      set_px $((OY-7)) $((OX+7)) "$PP"
      set_px $((OY-3)) $((OX+6)) "$PS"; set_px $((OY-4)) $((OX+9)) "$PS"
      set_px $((OY-2)) $((OX+8)) "$PS"; set_px $((OY-5)) $((OX+7)) "$PS"
      ;;
    chef)
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY-1)) $((OX+c)) "$WH"; done
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-2)) $((OX+c)) "$WH"; set_px $((OY-3)) $((OX+c)) "$WH"; done
      for c in 5 6 7 8 9 10; do set_px $((OY-4)) $((OX+c)) "$WH"; set_px $((OY-5)) $((OX+c)) "$WH"; done
      ;;
    party)
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-1)) $((OX+c)) "$PK"; done
      for c in 5 6 7 8 9 10; do set_px $((OY-2)) $((OX+c)) "$PK"; done
      for c in 6 7 8 9; do set_px $((OY-3)) $((OX+c)) "$PK"; done
      for c in 7 8; do set_px $((OY-4)) $((OX+c)) "$PK"; done
      set_px $((OY-5)) $((OX+7)) "$YL"; set_px $((OY-5)) $((OX+8)) "$YL"
      set_px $((OY-2)) $((OX+6)) "$YL"; set_px $((OY-2)) $((OX+9)) "$YL"
      ;;
    headband)
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY)) $((OX+c)) "$RD"; done
      ;;
    cap)
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY-1)) $((OX+c)) "$BL"; set_px $((OY)) $((OX+c)) "$BL"; done
      for c in 12 13 14 15; do set_px $((OY)) $((OX+c)) "$BL"; done
      ;;
    flower)
      # Flower crown: green vine with colorful flowers
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY-1)) $((OX+c)) "$GN"; done
      # Flowers: red, yellow, pink, blue, yellow
      set_px $((OY-2)) $((OX+3))  "$RD"; set_px $((OY-2)) $((OX+4))  "$PK"
      set_px $((OY-2)) $((OX+6))  "$YL"; set_px $((OY-2)) $((OX+7))  "$RD"
      set_px $((OY-2)) $((OX+9))  "$PK"; set_px $((OY-2)) $((OX+10)) "$BL"
      set_px $((OY-2)) $((OX+12)) "$YL"; set_px $((OY-2)) $((OX+11)) "$RD"
      # Flower centers
      set_px $((OY-3)) $((OX+4))  "$YL"
      set_px $((OY-3)) $((OX+7))  "$WC"
      set_px $((OY-3)) $((OX+10)) "$YL"
      set_px $((OY-3)) $((OX+12)) "$WC"
      ;;
    straw)
      # Straw hat for spring outing
      for c in 2 3 4 5 6 7 8 9 10 11 12 13; do set_px $((OY-1)) $((OX+c)) "$YL"; done
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY-2)) $((OX+c)) "$YL"; done
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-3)) $((OX+c)) "$YL"; done
      # Ribbon
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY-2)) $((OX+c)) "$PK"; done
      ;;
    ninja)
      # Ninja forehead protector (Konoha)
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY)) $((OX+c)) "$BL"; done
      for c in 5 6 7 8 9 10; do set_px $((OY)) $((OX+c)) "$GY"; done
      set_px $((OY)) $((OX+7)) "$BK"; set_px $((OY)) $((OX+8)) "$BK"
      set_px $((OY+1)) $((OX+13)) "$BL"; set_px $((OY+2)) $((OX+14)) "$BL"
      set_px $((OY+3)) $((OX+15)) "$BL"
      ;;
    pirate)
      # Tricorn pirate hat with skull
      for c in 2 3 4 5 6 7 8 9 10 11 12 13; do set_px $((OY-1)) $((OX+c)) "$BK"; done
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-2)) $((OX+c)) "$BK"; done
      for c in 5 6 7 8 9 10; do set_px $((OY-3)) $((OX+c)) "$BK"; done
      set_px $((OY-2)) $((OX+7)) "$WH"; set_px $((OY-2)) $((OX+8)) "$WH"
      set_px $((OY-3)) $((OX+7)) "$WH"; set_px $((OY-3)) $((OX+8)) "$WH"
      set_px $((OY-1)) $((OX+2)) "$SP"; set_px $((OY-1)) $((OX+13)) "$SP"
      ;;
    sorting)
      # Sorting Hat (brown, floppy tip)
      for c in 2 3 4 5 6 7 8 9 10 11 12 13; do set_px $((OY-1)) $((OX+c)) "$BR"; done
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-2)) $((OX+c)) "$BR"; done
      for c in 5 6 7 8 9 10; do set_px $((OY-3)) $((OX+c)) "$BR"; done
      for c in 6 7 8 9; do set_px $((OY-4)) $((OX+c)) "$BR"; done
      set_px $((OY-5)) $((OX+9)) "$BR"; set_px $((OY-5)) $((OX+10)) "$BR"
      set_px $((OY-6)) $((OX+11)) "$BR"
      set_px $((OY-3)) $((OX+6)) "$CK"; set_px $((OY-4)) $((OX+7)) "$CK"
      ;;
    akatsuki)
      # Akatsuki kasa (wide conical straw hat)
      for c in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do set_px $((OY-1)) $((OX+c)) "$YL"; done
      for c in 2 3 4 5 6 7 8 9 10 11 12 13; do set_px $((OY-2)) $((OX+c)) "$YL"; done
      for c in 4 5 6 7 8 9 10 11; do set_px $((OY-3)) $((OX+c)) "$YL"; done
      for c in 6 7 8 9; do set_px $((OY-4)) $((OX+c)) "$YL"; done
      set_px $((OY-5)) $((OX+7)) "$YL"; set_px $((OY-5)) $((OX+8)) "$YL"
      set_px $((OY-1)) $((OX+0)) "$RD"; set_px $((OY-1)) $((OX+15)) "$RD"
      set_px $((OY)) $((OX+1)) "$WH"; set_px $((OY+1)) $((OX+1)) "$WH"; set_px $((OY+2)) $((OX+1)) "$WH"
      set_px $((OY)) $((OX+14)) "$WH"; set_px $((OY+1)) $((OX+14)) "$WH"; set_px $((OY+2)) $((OX+14)) "$WH"
      ;;
  esac
}

# ═══ PROPS ═══
draw_prop() {
  case "$PROP" in
    none) ;;
    ball)
      set_px $((OY+5)) $((OX+16)) "$WC"; set_px $((OY+5)) $((OX+17)) "$GN"; set_px $((OY+5)) $((OX+18)) "$WC"
      set_px $((OY+6)) $((OX+16)) "$GN"; set_px $((OY+6)) $((OX+17)) "$WC"; set_px $((OY+6)) $((OX+18)) "$GN"
      set_px $((OY+7)) $((OX+16)) "$WC"; set_px $((OY+7)) $((OX+17)) "$GN"; set_px $((OY+7)) $((OX+18)) "$WC"
      ;;
    wand)
      for ((i=1; i<=5; i++)); do set_px $((OY-1-i)) $((OX+15)) "$BR"; done
      set_px $((OY-6)) $((OX+14)) "$SP"; set_px $((OY-6)) $((OX+15)) "$SP"; set_px $((OY-6)) $((OX+16)) "$SP"
      set_px $((OY-7)) $((OX+15)) "$SP"; set_px $((OY-5)) $((OX+15)) "$SP"
      ;;
    heart)
      set_px $((OY-2)) $((OX+16)) "$RD"; set_px $((OY-2)) $((OX+18)) "$RD"
      set_px $((OY-1)) $((OX+16)) "$RD"; set_px $((OY-1)) $((OX+17)) "$RD"; set_px $((OY-1)) $((OX+18)) "$RD"
      set_px $((OY))   $((OX+17)) "$RD"
      ;;
    laptop)
      for c in 5 6 7 8 9 10; do set_px $((OY+6)) $((OX+c)) "$BL"; done
      set_px $((OY+6)) $((OX+6)) "$WC"; set_px $((OY+6)) $((OX+8)) "$WC"
      for c in 5 6 7 8 9 10; do set_px $((OY+7)) $((OX+c)) "$GY"; done
      for c in 5 6 7 8 9 10; do set_px $((OY+8)) $((OX+c)) "$BK"; done
      ;;
    dumbbells)
      local al=$((OY+2+ARML)); local ar=$((OY+2+ARMR))
      set_px $((al-1)) $((OX+0)) "$GY"; set_px $((al-1)) $((OX+1)) "$GY"
      set_px $((al-2)) $((OX+0)) "$GY"; set_px $((al-2)) $((OX+1)) "$GY"
      set_px $((ar-1)) $((OX+14)) "$GY"; set_px $((ar-1)) $((OX+15)) "$GY"
      set_px $((ar-2)) $((OX+14)) "$GY"; set_px $((ar-2)) $((OX+15)) "$GY"
      ;;
    surfboard)
      for ((i=-2; i<18; i++)); do set_px $((OY+8)) $((OX+i)) "$SB"; done
      set_px $((OY+8)) $((OX-2)) "$SG"; set_px $((OY+8)) $((OX-1)) "$SG"
      set_px $((OY+8)) $((OX+16)) "$SG"; set_px $((OY+8)) $((OX+17)) "$SG"
      for ((i=0; i<W; i++)); do
        if (( i%4 < 2 )); then set_px $((OY+9)) $i "$WV"; else set_px $((OY+9)) $i "$W2"; fi
      done
      ;;
    cake)
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY+8)) $((OX+c)) "$CK"; done
      for c in 3 4 5 6 7 8 9 10 11 12; do
        if (( (c-3)%3 == 0 )); then set_px $((OY+9)) $((OX+c)) "$PK"
        else set_px $((OY+9)) $((OX+c)) "$CK"; fi
      done
      set_px $((OY+7)) $((OX+7)) "$WC"; set_px $((OY+7)) $((OX+8)) "$WC"
      set_px $((OY+6)) $((OX+7)) "$YL"; set_px $((OY+6)) $((OX+8)) "$YL"
      ;;
    boxing)
      local al=$((OY+2+ARML)); local ar=$((OY+2+ARMR))
      set_px $((al-1)) $((OX+1)) "$BK"; set_px $((al-1)) $((OX+2)) "$BK"
      set_px $((al-2)) $((OX+1)) "$BK"; set_px $((al-2)) $((OX+2)) "$BK"
      set_px $((ar-1)) $((OX+13)) "$BK"; set_px $((ar-1)) $((OX+14)) "$BK"
      set_px $((ar-2)) $((OX+13)) "$BK"; set_px $((ar-2)) $((OX+14)) "$BK"
      ;;
    scarf)
      for c in 3 4 5 6 7 8 9 10 11 12; do
        if (( (c-3)%2 == 0 )); then set_px $((OY+6)) $((OX+c)) "$RD"
        else set_px $((OY+6)) $((OX+c)) "$SC"; fi
      done
      set_px $((OY+7)) $((OX+12)) "$RD"
      set_px $((OY+8)) $((OX+12)) "$RD"
      set_px $((OY+9)) $((OX+12)) "$SC"
      ;;
    hula)
      # Grass skirt: colorful fringe below body, overwrites legs
      local HG="34;139;34"   # dark green
      local HY="154;205;50"  # yellow green
      local HL="255;255;0"   # bright yellow
      # Waistband
      for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY+5)) $((OX+c)) "$GN"; done
      # Fringe row 1
      for c in 3 4 5 6 7 8 9 10 11 12; do
        case $(( (c-3)%3 )) in
          0) set_px $((OY+6)) $((OX+c)) "$HG";;
          1) set_px $((OY+6)) $((OX+c)) "$HY";;
          2) set_px $((OY+6)) $((OX+c)) "$HL";;
        esac
      done
      # Fringe row 2 (offset)
      for c in 3 4 5 6 7 8 9 10 11 12; do
        case $(( (c-2)%3 )) in
          0) set_px $((OY+7)) $((OX+c)) "$HY";;
          1) set_px $((OY+7)) $((OX+c)) "$HL";;
          2) set_px $((OY+7)) $((OX+c)) "$HG";;
        esac
      done
      # Fringe tips row 3
      for c in 4 6 8 10 12; do set_px $((OY+8)) $((OX+c)) "$HG"; done
      ;;
    bouquet)
      # Flower bouquet held to the right
      set_px $((OY+1)) $((OX+16)) "$GN"; set_px $((OY+2)) $((OX+16)) "$GN"
      set_px $((OY+1)) $((OX+17)) "$GN"; set_px $((OY+2)) $((OX+17)) "$GN"
      # Flowers: multi-colored
      set_px $((OY+0)) $((OX+15)) "$RD"; set_px $((OY+0)) $((OX+16)) "$PK"
      set_px $((OY+0)) $((OX+17)) "$YL"; set_px $((OY+0)) $((OX+18)) "$BL"
      set_px $((OY-1)) $((OX+15)) "$YL"; set_px $((OY-1)) $((OX+16)) "$RD"
      set_px $((OY-1)) $((OX+17)) "$PK"; set_px $((OY-1)) $((OX+18)) "$RD"
      # White highlights
      set_px $((OY-2)) $((OX+16)) "$WC"; set_px $((OY-2)) $((OX+17)) "$WC"
      ;;
    lei)
      # Flower lei (necklace) across the body
      local colors=("$RD" "$YL" "$PK" "$BL" "$GN" "$YL" "$RD" "$PK" "$BL" "$GN")
      for ((i=0; i<10; i++)); do
        set_px $((OY+4)) $((OX+3+i)) "${colors[$i]}"
      done
      # Slightly lower center for draped effect
      set_px $((OY+5)) $((OX+6)) "$PK"; set_px $((OY+5)) $((OX+7)) "$YL"
      set_px $((OY+5)) $((OX+8)) "$RD"; set_px $((OY+5)) $((OX+9)) "$BL"
      ;;
    butterfly)
      # Butterfly near the crab
      set_px $((OY-3)) $((OX+17)) "$PK"; set_px $((OY-3)) $((OX+19)) "$PK"
      set_px $((OY-2)) $((OX+16)) "$PK"; set_px $((OY-2)) $((OX+17)) "$WC"
      set_px $((OY-2)) $((OX+18)) "$BK"; set_px $((OY-2)) $((OX+19)) "$WC"
      set_px $((OY-2)) $((OX+20)) "$PK"
      set_px $((OY-1)) $((OX+17)) "$PK"; set_px $((OY-1)) $((OX+19)) "$PK"
      ;;
    snitch)
      # Golden Snitch (ball + wings)
      set_px $((OY-2)) $((OX+17)) "$SP"; set_px $((OY-2)) $((OX+18)) "$SP"
      set_px $((OY-1)) $((OX+17)) "$SP"; set_px $((OY-1)) $((OX+18)) "$SP"
      # Wings
      set_px $((OY-3)) $((OX+16)) "$WH"; set_px $((OY-3)) $((OX+19)) "$WH"
      set_px $((OY-4)) $((OX+15)) "$WH"; set_px $((OY-4)) $((OX+20)) "$WH"
      ;;
    broom)
      # Flying broomstick (diagonal, under body)
      for ((i=0; i<8; i++)); do set_px $((OY+8-i)) $((OX+2+i)) "$BR"; done
      # Bristles
      set_px $((OY+9)) $((OX+0)) "$YL"; set_px $((OY+9)) $((OX+1)) "$YL"
      set_px $((OY+9)) $((OX+2)) "$YL"; set_px $((OY+9)) $((OX+3)) "$YL"
      set_px $((OY+10)) $((OX+1)) "$YL"; set_px $((OY+10)) $((OX+2)) "$YL"
      ;;
    hpscarf)
      # Hogwarts house scarf (red/gold Gryffindor)
      for c in 3 4 5 6 7 8 9 10 11 12; do
        if (( (c-3)%2 == 0 )); then set_px $((OY+4)) $((OX+c)) "$RD"
        else set_px $((OY+4)) $((OX+c)) "$SP"; fi
      done
      for c in 3 4 5 6 7 8 9 10 11 12; do
        if (( (c-3)%2 == 1 )); then set_px $((OY+5)) $((OX+c)) "$RD"
        else set_px $((OY+5)) $((OX+c)) "$SP"; fi
      done
      set_px $((OY+6)) $((OX+13)) "$RD"; set_px $((OY+7)) $((OX+13)) "$SP"
      set_px $((OY+8)) $((OX+13)) "$RD"
      ;;
    kunai)
      # Kunai knife (held right)
      set_px $((OY+3)) $((OX+16)) "$GY"
      set_px $((OY+2)) $((OX+16)) "$BR"; set_px $((OY+1)) $((OX+16)) "$BR"
      set_px $((OY+0)) $((OX+16)) "$GY"; set_px $((OY-1)) $((OX+16)) "$GY"
      set_px $((OY-2)) $((OX+16)) "$WH"
      ;;
    shuriken)
      # Throwing star (flying right)
      set_px $((OY))   $((OX+17)) "$BK"
      set_px $((OY-1)) $((OX+17)) "$GY"; set_px $((OY+1)) $((OX+17)) "$GY"
      set_px $((OY))   $((OX+16)) "$GY"; set_px $((OY))   $((OX+18)) "$GY"
      set_px $((OY-1)) $((OX+16)) "$GY"; set_px $((OY-1)) $((OX+18)) "$GY"
      set_px $((OY+1)) $((OX+16)) "$GY"; set_px $((OY+1)) $((OX+18)) "$GY"
      ;;
    rasengan)
      # Rasengan energy ball (follows right arm)
      local ar=$((OY+2+ARMR))
      local rx=$((OX+15))
      set_px $((ar-2)) $((rx)) "$SB"; set_px $((ar-2)) $((rx+1)) "$SB"; set_px $((ar-2)) $((rx+2)) "$SB"
      set_px $((ar-1)) $((rx)) "$SB"; set_px $((ar-1)) $((rx+1)) "$WC"; set_px $((ar-1)) $((rx+2)) "$SB"
      set_px $((ar))   $((rx)) "$SB"; set_px $((ar))   $((rx+1)) "$SB"; set_px $((ar))   $((rx+2)) "$SB"
      set_px $((ar-3)) $((rx+1)) "$BL"; set_px $((ar-1)) $((rx+3)) "$BL"
      ;;
    cloak)
      # Akatsuki cloak (black with red clouds)
      for r in 2 3 4 5; do
        for c in 3 4 5 6 7 8 9 10 11 12; do set_px $((OY+r)) $((OX+c)) "$BK"; done
      done
      # Red clouds
      set_px $((OY+3)) $((OX+5)) "$RD"; set_px $((OY+3)) $((OX+6)) "$RD"
      set_px $((OY+4)) $((OX+5)) "$RD"; set_px $((OY+4)) $((OX+6)) "$RD"
      set_px $((OY+3)) $((OX+9)) "$RD"; set_px $((OY+3)) $((OX+10)) "$RD"
      set_px $((OY+4)) $((OX+9)) "$RD"; set_px $((OY+4)) $((OX+10)) "$RD"
      # White outline
      set_px $((OY+3)) $((OX+4)) "$WH"; set_px $((OY+3)) $((OX+7)) "$WH"
      set_px $((OY+3)) $((OX+8)) "$WH"; set_px $((OY+3)) $((OX+11)) "$WH"
      # Cloak legs area
      for c in 4 5 6 7 8 9 10 11; do
        set_px $((OY+6)) $((OX+c)) "$BK"; set_px $((OY+7)) $((OX+c)) "$BK"
      done
      ;;
    katana)
      # Katana sword (right side, vertical)
      for ((i=0; i<6; i++)); do set_px $((OY+1-i)) $((OX+15)) "$GY"; done
      set_px $((OY-5)) $((OX+15)) "$WH"
      # Guard (tsuba)
      set_px $((OY+2)) $((OX+14)) "$SP"; set_px $((OY+2)) $((OX+15)) "$SP"; set_px $((OY+2)) $((OX+16)) "$SP"
      # Handle wrap
      set_px $((OY+3)) $((OX+15)) "$PP"; set_px $((OY+4)) $((OX+15)) "$PP"
      ;;
    meat)
      # Big drumstick (Luffy's favorite)
      set_px $((OY-2)) $((OX+16)) "$WH"; set_px $((OY-2)) $((OX+17)) "$WH"
      set_px $((OY-1)) $((OX+16)) "$WH"; set_px $((OY-1)) $((OX+17)) "$WH"
      set_px $((OY+0)) $((OX+16)) "$WH"
      # Meat chunk
      set_px $((OY+1)) $((OX+15)) "$BR"; set_px $((OY+1)) $((OX+16)) "$BR"; set_px $((OY+1)) $((OX+17)) "$BR"
      set_px $((OY+2)) $((OX+15)) "$BR"; set_px $((OY+2)) $((OX+16)) "$CK"; set_px $((OY+2)) $((OX+17)) "$BR"
      set_px $((OY+3)) $((OX+15)) "$BR"; set_px $((OY+3)) $((OX+16)) "$BR"; set_px $((OY+3)) $((OX+17)) "$BR"
      set_px $((OY+4)) $((OX+16)) "$WH"
      ;;
    flag)
      # Pirate flag (Jolly Roger)
      for ((i=-3; i<=7; i++)); do set_px $((OY+i)) $((OX+16)) "$BR"; done
      for r in -3 -2 -1 0; do
        for c in 17 18 19 20; do set_px $((OY+r)) $((OX+c)) "$BK"; done
      done
      set_px $((OY-2)) $((OX+18)) "$WH"; set_px $((OY-2)) $((OX+19)) "$WH"
      set_px $((OY-1)) $((OX+18)) "$WH"; set_px $((OY-1)) $((OX+19)) "$WH"
      ;;
    barrel)
      # Barrel (sake/treasure)
      for c in 16 17 18 19; do
        for r in 4 5 6 7; do set_px $((OY+r)) $((OX+c)) "$BR"; done
      done
      for c in 16 17 18 19; do
        set_px $((OY+4)) $((OX+c)) "$GY"; set_px $((OY+7)) $((OX+c)) "$GY"
      done
      set_px $((OY+5)) $((OX+17)) "$CK"; set_px $((OY+6)) $((OX+18)) "$CK"
      ;;
    vest)
      # Red vest (open front, Luffy style)
      for r in 2 3 4 5; do
        for c in 3 4 5 6; do set_px $((OY+r)) $((OX+c)) "$RD"; done
        for c in 9 10 11 12; do set_px $((OY+r)) $((OX+c)) "$RD"; done
      done
      ;;
  esac
}

# ═══ FACE ACCESSORIES ═══
draw_accessory() {
  case "$ACCESSORY" in
    none) ;;
    glasses)
      local GF="51;51;51"
      set_px $((OY))   $((OX+4)) "$GF"; set_px $((OY))   $((OX+5)) "$GF"; set_px $((OY))   $((OX+6)) "$GF"
      set_px $((OY+1)) $((OX+4)) "$GF";                                    set_px $((OY+1)) $((OX+6)) "$GF"
      set_px $((OY+2)) $((OX+4)) "$GF";                                    set_px $((OY+2)) $((OX+6)) "$GF"
      set_px $((OY+3)) $((OX+4)) "$GF"; set_px $((OY+3)) $((OX+5)) "$GF"; set_px $((OY+3)) $((OX+6)) "$GF"
      set_px $((OY))   $((OX+9))  "$GF"; set_px $((OY))   $((OX+10)) "$GF"; set_px $((OY))   $((OX+11)) "$GF"
      set_px $((OY+1)) $((OX+9))  "$GF";                                     set_px $((OY+1)) $((OX+11)) "$GF"
      set_px $((OY+2)) $((OX+9))  "$GF";                                     set_px $((OY+2)) $((OX+11)) "$GF"
      set_px $((OY+3)) $((OX+9))  "$GF"; set_px $((OY+3)) $((OX+10)) "$GF"; set_px $((OY+3)) $((OX+11)) "$GF"
      set_px $((OY+1)) $((OX+7)) "$GF"; set_px $((OY+1)) $((OX+8)) "$GF"
      ;;
    scar)
      set_px $((OY-1)) $((OX+4)) "$SP"
      set_px $((OY))   $((OX+3)) "$SP"; set_px $((OY)) $((OX+4)) "$SP"
      set_px $((OY+1)) $((OX+4)) "$SP"
      ;;
    potter)
      local GF="51;51;51"
      set_px $((OY))   $((OX+4)) "$GF"; set_px $((OY))   $((OX+5)) "$GF"; set_px $((OY))   $((OX+6)) "$GF"
      set_px $((OY+1)) $((OX+4)) "$GF";                                    set_px $((OY+1)) $((OX+6)) "$GF"
      set_px $((OY+2)) $((OX+4)) "$GF";                                    set_px $((OY+2)) $((OX+6)) "$GF"
      set_px $((OY+3)) $((OX+4)) "$GF"; set_px $((OY+3)) $((OX+5)) "$GF"; set_px $((OY+3)) $((OX+6)) "$GF"
      set_px $((OY))   $((OX+9))  "$GF"; set_px $((OY))   $((OX+10)) "$GF"; set_px $((OY))   $((OX+11)) "$GF"
      set_px $((OY+1)) $((OX+9))  "$GF";                                     set_px $((OY+1)) $((OX+11)) "$GF"
      set_px $((OY+2)) $((OX+9))  "$GF";                                     set_px $((OY+2)) $((OX+11)) "$GF"
      set_px $((OY+3)) $((OX+9))  "$GF"; set_px $((OY+3)) $((OX+10)) "$GF"; set_px $((OY+3)) $((OX+11)) "$GF"
      set_px $((OY+1)) $((OX+7)) "$GF"; set_px $((OY+1)) $((OX+8)) "$GF"
      set_px $((OY-1)) $((OX+3)) "$SP"
      set_px $((OY))   $((OX+2)) "$SP"; set_px $((OY)) $((OX+3)) "$SP"
      ;;
  esac
}

# ═══ RENDER (z-order) ═══
# 1. Bottom props
case "$PROP" in surfboard|cake|laptop|scarf|hpscarf|broom) draw_prop;; esac
# 2. Body
draw_body
# 2.5. Legs
draw_legs
# 3. Overlay props (drawn over body/legs)
case "$PROP" in hula|lei|cloak|vest) draw_prop;; esac
# 4. Arms
draw_arms
# 5. Eyes
draw_eyes
# 5.5. Face accessories (glasses, scar — drawn over eyes)
draw_accessory
# 6. Hat
draw_hat
# 7. Top props
case "$PROP" in ball|wand|heart|bouquet|butterfly|snitch|kunai|shuriken|katana|meat|flag|barrel) draw_prop;; esac
# 8. Arm-following props
case "$PROP" in dumbbells|boxing|rasengan) draw_prop;; esac

# ═══ OUTPUT ANSI ═══
# Find bounding box (trim empty rows/cols)
minR=$H; maxR=0; minC=$W; maxC=0
for ((r=0; r<H; r++)); do
  for ((c=0; c<W; c++)); do
    if [[ -n "${GRID[$((r*W+c))]}" ]]; then
      ((r<minR)) && minR=$r; ((r>maxR)) && maxR=$r
      ((c<minC)) && minC=$c; ((c>maxC)) && maxC=$c
    fi
  done
done

if ((minR>maxR)); then echo "(empty)"; exit 0; fi

if [[ "$OUTPUT" == "png" ]]; then
  # ═══ PNG OUTPUT (fixed 1:1 square canvas via PPM → ffmpeg) ═══
  SZ=$((W > H ? W : H))
  padTop=$(( (SZ - H) / 2 ))
  PPM_TMP="${PNG_FILE%.png}.ppm"
  {
    printf "P6\n%d %d\n255\n" "$SZ" "$SZ"
    for ((r=0; r<SZ; r++)); do
      for ((c=0; c<SZ; c++)); do
        gr=$((r - padTop))
        if ((gr >= 0 && gr < H && c < W)); then
          color="${GRID[$((gr*W+c))]}"
        else
          color=""
        fi
        if [[ -n "$color" ]]; then
          IFS=';' read -ra RGB <<< "$color"
          printf "\\x$(printf '%02x' "${RGB[0]}")\\x$(printf '%02x' "${RGB[1]}")\\x$(printf '%02x' "${RGB[2]}")"
        else
          printf "\\x11\\x11\\x11"
        fi
      done
    done
  } > "$PPM_TMP"
  ffmpeg -y -i "$PPM_TMP" -vf "scale=iw*20:ih*20:flags=neighbor" "$PNG_FILE" 2>/dev/null
  rm -f "$PPM_TMP"
  echo "$PNG_FILE"

elif [[ "$OUTPUT" == "html" ]]; then
  # ═══ HTML OUTPUT ═══
  PX=20  # pixel size
  cat > "$HTML_FILE" <<'HTMLHEAD'
<!DOCTYPE html><html><head><meta charset="utf-8"><title>Clawd</title>
<style>body{background:#111;display:flex;justify-content:center;align-items:center;min-height:100vh;margin:0}
.grid{display:grid;gap:0}</style></head><body><div class="grid" style="grid-template-columns:
HTMLHEAD
  cols=$(( maxC - minC + 1 ))
  printf "repeat(%d,%dpx);grid-template-rows:repeat(%d,%dpx)\">\n" "$cols" "$PX" "$(( maxR - minR + 1 ))" "$PX" >> "$HTML_FILE"
  for ((r=minR; r<=maxR; r++)); do
    for ((c=minC; c<=maxC; c++)); do
      color="${GRID[$((r*W+c))]}"
      if [[ -n "$color" ]]; then
        printf '<div style="background:rgb(%s)"></div>\n' "${color//;/,}" >> "$HTML_FILE"
      else
        printf '<div></div>\n' >> "$HTML_FILE"
      fi
    done
  done
  echo '</div></body></html>' >> "$HTML_FILE"
  echo "Saved: $HTML_FILE"
else
  # ═══ ANSI HALF-BLOCK OUTPUT ═══
  # Merge two rows into one line using ▀ (upper half block)
  # Foreground = top pixel, Background = bottom pixel → halves the line count
  # Pad maxR to even number of rows
  if (( (maxR - minR) % 2 == 0 )); then ((maxR++)); fi
  echo ""
  for ((r=minR; r<=maxR; r+=2)); do
    line=""
    for ((c=minC; c<=maxC; c++)); do
      top="${GRID[$((r*W+c))]}"
      bot="${GRID[$(((r+1)*W+c))]}"
      if [[ -n "$top" && -n "$bot" ]]; then
        line+="\033[38;2;${top}m\033[48;2;${bot}m▀"
      elif [[ -n "$top" ]]; then
        line+="\033[0m\033[38;2;${top}m▀"
      elif [[ -n "$bot" ]]; then
        line+="\033[0m\033[38;2;${bot}m▄"
      else
        line+="\033[0m "
      fi
    done
    line+="\033[0m"
    printf "${line}\n"
  done
  echo ""
fi
