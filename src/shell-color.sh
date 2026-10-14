# >>> SHELL_COLOR_BEGIN v1
# Shell Color runtime
# Version: v1.33.7a
# Scope: xterm-256 Resolver + weiß/grau Textschema + farbige Sonderzeichen + IP/local + Weblink-/Zahlen-Rendering.
# Safety: keine automatischen Wrapper für sudo/ssh/scp/sftp/passwd/su/editor/pager/fullscreen/progress/pacman.

# Nur interaktive Bash-Shells beeinflussen, außer der CLI-Wrapper lädt
# die Funktionen ausdrücklich für einen einzelnen Befehl.
if [ "${SHELL_COLOR_FORCE_LOAD:-0}" != "1" ]; then
  case "$-" in
    *i*) ;;
    *) return 0 2>/dev/null || exit 0 ;;
  esac
fi

# Keine Shell durch Fehler im Farb-Layer schließen.
set +e
set +u
set +o pipefail 2>/dev/null || true

: "${SHELL_COLOR_THEME_FILE:=$HOME/.config/shell-color/color}"
: "${SHELL_COLOR_STYLE_FILE:=$HOME/.config/shell-color/ps1_style}"
: "${SHELL_COLOR_PATH_POSITION_FILE:=$HOME/.config/shell-color/path_position}"
: "${SHELL_COLOR_IP_MODE_FILE:=$HOME/.config/shell-color/ip_mode}"
: "${SHELL_COLOR_PUBLIC_IP_FILE:=$HOME/.config/shell-color/public_ip}"
: "${SHELL_COLOR_PUBLIC_IP_SERVICE:=https://api.ipify.org}"
: "${SHELL_COLOR_DEFAULT:=mint}"
: "${SHELL_COLOR_DEFAULT_STYLE:=compact}"
: "${SHELL_COLOR_DEFAULT_PATH_POSITION:=inside}"
: "${SHELL_COLOR_VERSION:=v1.33.7a}"

# ---- shell-color xterm-256 core begin ----------------------------------------
__shell_color_norm() {
  local s="${1:-}"
  s="$(printf '%s' "$s" | tr '[:upper:]' '[:lower:]')"
  s="${s// /}"
  s="${s//_/}"
  s="${s//-/}"
  s="${s//./}"
  printf '%s' "$s"
}

__shell_color_xterm_name() {
  case "${1:-}" in
    0) printf '%s\n' 'Black' ;;
    1) printf '%s\n' 'Maroon' ;;
    2) printf '%s\n' 'Green' ;;
    3) printf '%s\n' 'Olive' ;;
    4) printf '%s\n' 'Navy' ;;
    5) printf '%s\n' 'Purple' ;;
    6) printf '%s\n' 'Teal' ;;
    7) printf '%s\n' 'Silver' ;;
    8) printf '%s\n' 'Grey' ;;
    9) printf '%s\n' 'Red' ;;
    10) printf '%s\n' 'Lime' ;;
    11) printf '%s\n' 'Yellow' ;;
    12) printf '%s\n' 'Blue' ;;
    13) printf '%s\n' 'Fuchsia' ;;
    14) printf '%s\n' 'Aqua' ;;
    15) printf '%s\n' 'White' ;;
    16) printf '%s\n' 'Grey0' ;;
    17) printf '%s\n' 'NavyBlue' ;;
    18) printf '%s\n' 'DarkBlue' ;;
    19) printf '%s\n' 'Blue3' ;;
    20) printf '%s\n' 'Blue3' ;;
    21) printf '%s\n' 'Blue1' ;;
    22) printf '%s\n' 'DarkGreen' ;;
    23) printf '%s\n' 'DeepSkyBlue4' ;;
    24) printf '%s\n' 'DeepSkyBlue4' ;;
    25) printf '%s\n' 'DeepSkyBlue4' ;;
    26) printf '%s\n' 'DodgerBlue3' ;;
    27) printf '%s\n' 'DodgerBlue2' ;;
    28) printf '%s\n' 'Green4' ;;
    29) printf '%s\n' 'SpringGreen4' ;;
    30) printf '%s\n' 'Turquoise4' ;;
    31) printf '%s\n' 'DeepSkyBlue3' ;;
    32) printf '%s\n' 'DeepSkyBlue3' ;;
    33) printf '%s\n' 'DodgerBlue1' ;;
    34) printf '%s\n' 'Green3' ;;
    35) printf '%s\n' 'SpringGreen3' ;;
    36) printf '%s\n' 'DarkCyan' ;;
    37) printf '%s\n' 'LightSeaGreen' ;;
    38) printf '%s\n' 'DeepSkyBlue2' ;;
    39) printf '%s\n' 'DeepSkyBlue1' ;;
    40) printf '%s\n' 'Green3' ;;
    41) printf '%s\n' 'SpringGreen3' ;;
    42) printf '%s\n' 'SpringGreen2' ;;
    43) printf '%s\n' 'Cyan3' ;;
    44) printf '%s\n' 'DarkTurquoise' ;;
    45) printf '%s\n' 'Turquoise2' ;;
    46) printf '%s\n' 'Green1' ;;
    47) printf '%s\n' 'SpringGreen2' ;;
    48) printf '%s\n' 'SpringGreen1' ;;
    49) printf '%s\n' 'MediumSpringGreen' ;;
    50) printf '%s\n' 'Cyan2' ;;
    51) printf '%s\n' 'Cyan1' ;;
    52) printf '%s\n' 'DarkRed' ;;
    53) printf '%s\n' 'DeepPink4' ;;
    54) printf '%s\n' 'Purple4' ;;
    55) printf '%s\n' 'Purple4' ;;
    56) printf '%s\n' 'Purple3' ;;
    57) printf '%s\n' 'BlueViolet' ;;
    58) printf '%s\n' 'Orange4' ;;
    59) printf '%s\n' 'Grey37' ;;
    60) printf '%s\n' 'MediumPurple4' ;;
    61) printf '%s\n' 'SlateBlue3' ;;
    62) printf '%s\n' 'SlateBlue3' ;;
    63) printf '%s\n' 'RoyalBlue1' ;;
    64) printf '%s\n' 'Chartreuse4' ;;
    65) printf '%s\n' 'DarkSeaGreen4' ;;
    66) printf '%s\n' 'PaleTurquoise4' ;;
    67) printf '%s\n' 'SteelBlue' ;;
    68) printf '%s\n' 'SteelBlue3' ;;
    69) printf '%s\n' 'CornflowerBlue' ;;
    70) printf '%s\n' 'Chartreuse3' ;;
    71) printf '%s\n' 'DarkSeaGreen4' ;;
    72) printf '%s\n' 'CadetBlue' ;;
    73) printf '%s\n' 'CadetBlue' ;;
    74) printf '%s\n' 'SkyBlue3' ;;
    75) printf '%s\n' 'SteelBlue1' ;;
    76) printf '%s\n' 'Chartreuse3' ;;
    77) printf '%s\n' 'PaleGreen3' ;;
    78) printf '%s\n' 'SeaGreen3' ;;
    79) printf '%s\n' 'Aquamarine3' ;;
    80) printf '%s\n' 'MediumTurquoise' ;;
    81) printf '%s\n' 'SteelBlue1' ;;
    82) printf '%s\n' 'Chartreuse2' ;;
    83) printf '%s\n' 'SeaGreen2' ;;
    84) printf '%s\n' 'SeaGreen1' ;;
    85) printf '%s\n' 'SeaGreen1' ;;
    86) printf '%s\n' 'Aquamarine1' ;;
    87) printf '%s\n' 'DarkSlateGray2' ;;
    88) printf '%s\n' 'DarkRed' ;;
    89) printf '%s\n' 'DeepPink4' ;;
    90) printf '%s\n' 'DarkMagenta' ;;
    91) printf '%s\n' 'DarkMagenta' ;;
    92) printf '%s\n' 'DarkViolet' ;;
    93) printf '%s\n' 'Purple' ;;
    94) printf '%s\n' 'Orange4' ;;
    95) printf '%s\n' 'LightPink4' ;;
    96) printf '%s\n' 'Plum4' ;;
    97) printf '%s\n' 'MediumPurple3' ;;
    98) printf '%s\n' 'MediumPurple3' ;;
    99) printf '%s\n' 'SlateBlue1' ;;
    100) printf '%s\n' 'Yellow4' ;;
    101) printf '%s\n' 'Wheat4' ;;
    102) printf '%s\n' 'Grey53' ;;
    103) printf '%s\n' 'LightSlateGrey' ;;
    104) printf '%s\n' 'MediumPurple' ;;
    105) printf '%s\n' 'LightSlateBlue' ;;
    106) printf '%s\n' 'Yellow4' ;;
    107) printf '%s\n' 'DarkOliveGreen3' ;;
    108) printf '%s\n' 'DarkSeaGreen' ;;
    109) printf '%s\n' 'LightSkyBlue3' ;;
    110) printf '%s\n' 'LightSkyBlue3' ;;
    111) printf '%s\n' 'SkyBlue2' ;;
    112) printf '%s\n' 'Chartreuse2' ;;
    113) printf '%s\n' 'DarkOliveGreen3' ;;
    114) printf '%s\n' 'PaleGreen3' ;;
    115) printf '%s\n' 'DarkSeaGreen3' ;;
    116) printf '%s\n' 'DarkSlateGray3' ;;
    117) printf '%s\n' 'SkyBlue1' ;;
    118) printf '%s\n' 'Chartreuse1' ;;
    119) printf '%s\n' 'LightGreen' ;;
    120) printf '%s\n' 'LightGreen' ;;
    121) printf '%s\n' 'PaleGreen1' ;;
    122) printf '%s\n' 'Aquamarine1' ;;
    123) printf '%s\n' 'DarkSlateGray1' ;;
    124) printf '%s\n' 'Red3' ;;
    125) printf '%s\n' 'DeepPink4' ;;
    126) printf '%s\n' 'MediumVioletRed' ;;
    127) printf '%s\n' 'Magenta3' ;;
    128) printf '%s\n' 'DarkViolet' ;;
    129) printf '%s\n' 'Purple' ;;
    130) printf '%s\n' 'DarkOrange3' ;;
    131) printf '%s\n' 'IndianRed' ;;
    132) printf '%s\n' 'HotPink3' ;;
    133) printf '%s\n' 'MediumOrchid3' ;;
    134) printf '%s\n' 'MediumOrchid' ;;
    135) printf '%s\n' 'MediumPurple2' ;;
    136) printf '%s\n' 'DarkGoldenrod' ;;
    137) printf '%s\n' 'LightSalmon3' ;;
    138) printf '%s\n' 'RosyBrown' ;;
    139) printf '%s\n' 'Grey63' ;;
    140) printf '%s\n' 'MediumPurple2' ;;
    141) printf '%s\n' 'MediumPurple1' ;;
    142) printf '%s\n' 'Gold3' ;;
    143) printf '%s\n' 'DarkKhaki' ;;
    144) printf '%s\n' 'NavajoWhite3' ;;
    145) printf '%s\n' 'Grey69' ;;
    146) printf '%s\n' 'LightSteelBlue3' ;;
    147) printf '%s\n' 'LightSteelBlue' ;;
    148) printf '%s\n' 'Yellow3' ;;
    149) printf '%s\n' 'DarkOliveGreen3' ;;
    150) printf '%s\n' 'DarkSeaGreen3' ;;
    151) printf '%s\n' 'DarkSeaGreen2' ;;
    152) printf '%s\n' 'LightCyan3' ;;
    153) printf '%s\n' 'LightSkyBlue1' ;;
    154) printf '%s\n' 'GreenYellow' ;;
    155) printf '%s\n' 'DarkOliveGreen2' ;;
    156) printf '%s\n' 'PaleGreen1' ;;
    157) printf '%s\n' 'DarkSeaGreen2' ;;
    158) printf '%s\n' 'DarkSeaGreen1' ;;
    159) printf '%s\n' 'PaleTurquoise1' ;;
    160) printf '%s\n' 'Red3' ;;
    161) printf '%s\n' 'DeepPink3' ;;
    162) printf '%s\n' 'DeepPink3' ;;
    163) printf '%s\n' 'Magenta3' ;;
    164) printf '%s\n' 'Magenta3' ;;
    165) printf '%s\n' 'Magenta2' ;;
    166) printf '%s\n' 'DarkOrange3' ;;
    167) printf '%s\n' 'IndianRed' ;;
    168) printf '%s\n' 'HotPink3' ;;
    169) printf '%s\n' 'HotPink2' ;;
    170) printf '%s\n' 'Orchid' ;;
    171) printf '%s\n' 'MediumOrchid1' ;;
    172) printf '%s\n' 'Orange3' ;;
    173) printf '%s\n' 'LightSalmon3' ;;
    174) printf '%s\n' 'LightPink3' ;;
    175) printf '%s\n' 'Pink3' ;;
    176) printf '%s\n' 'Plum3' ;;
    177) printf '%s\n' 'Violet' ;;
    178) printf '%s\n' 'Gold3' ;;
    179) printf '%s\n' 'LightGoldenrod3' ;;
    180) printf '%s\n' 'Tan' ;;
    181) printf '%s\n' 'MistyRose3' ;;
    182) printf '%s\n' 'Thistle3' ;;
    183) printf '%s\n' 'Plum2' ;;
    184) printf '%s\n' 'Yellow3' ;;
    185) printf '%s\n' 'Khaki3' ;;
    186) printf '%s\n' 'LightGoldenrod2' ;;
    187) printf '%s\n' 'LightYellow3' ;;
    188) printf '%s\n' 'Grey84' ;;
    189) printf '%s\n' 'LightSteelBlue1' ;;
    190) printf '%s\n' 'Yellow2' ;;
    191) printf '%s\n' 'DarkOliveGreen1' ;;
    192) printf '%s\n' 'DarkOliveGreen1' ;;
    193) printf '%s\n' 'DarkSeaGreen1' ;;
    194) printf '%s\n' 'Honeydew2' ;;
    195) printf '%s\n' 'LightCyan1' ;;
    196) printf '%s\n' 'Red1' ;;
    197) printf '%s\n' 'DeepPink2' ;;
    198) printf '%s\n' 'DeepPink1' ;;
    199) printf '%s\n' 'DeepPink1' ;;
    200) printf '%s\n' 'Magenta2' ;;
    201) printf '%s\n' 'Magenta1' ;;
    202) printf '%s\n' 'OrangeRed1' ;;
    203) printf '%s\n' 'IndianRed1' ;;
    204) printf '%s\n' 'IndianRed1' ;;
    205) printf '%s\n' 'HotPink' ;;
    206) printf '%s\n' 'HotPink' ;;
    207) printf '%s\n' 'MediumOrchid1' ;;
    208) printf '%s\n' 'DarkOrange' ;;
    209) printf '%s\n' 'Salmon1' ;;
    210) printf '%s\n' 'LightCoral' ;;
    211) printf '%s\n' 'PaleVioletRed1' ;;
    212) printf '%s\n' 'Orchid2' ;;
    213) printf '%s\n' 'Orchid1' ;;
    214) printf '%s\n' 'Orange1' ;;
    215) printf '%s\n' 'SandyBrown' ;;
    216) printf '%s\n' 'LightSalmon1' ;;
    217) printf '%s\n' 'LightPink1' ;;
    218) printf '%s\n' 'Pink1' ;;
    219) printf '%s\n' 'Plum1' ;;
    220) printf '%s\n' 'Gold1' ;;
    221) printf '%s\n' 'LightGoldenrod2' ;;
    222) printf '%s\n' 'LightGoldenrod2' ;;
    223) printf '%s\n' 'NavajoWhite1' ;;
    224) printf '%s\n' 'MistyRose1' ;;
    225) printf '%s\n' 'Thistle1' ;;
    226) printf '%s\n' 'Yellow1' ;;
    227) printf '%s\n' 'LightGoldenrod1' ;;
    228) printf '%s\n' 'Khaki1' ;;
    229) printf '%s\n' 'Wheat1' ;;
    230) printf '%s\n' 'Cornsilk1' ;;
    231) printf '%s\n' 'Grey100' ;;
    232) printf '%s\n' 'Grey3' ;;
    233) printf '%s\n' 'Grey7' ;;
    234) printf '%s\n' 'Grey11' ;;
    235) printf '%s\n' 'Grey15' ;;
    236) printf '%s\n' 'Grey19' ;;
    237) printf '%s\n' 'Grey23' ;;
    238) printf '%s\n' 'Grey27' ;;
    239) printf '%s\n' 'Grey30' ;;
    240) printf '%s\n' 'Grey35' ;;
    241) printf '%s\n' 'Grey39' ;;
    242) printf '%s\n' 'Grey42' ;;
    243) printf '%s\n' 'Grey46' ;;
    244) printf '%s\n' 'Grey50' ;;
    245) printf '%s\n' 'Grey54' ;;
    246) printf '%s\n' 'Grey58' ;;
    247) printf '%s\n' 'Grey62' ;;
    248) printf '%s\n' 'Grey66' ;;
    249) printf '%s\n' 'Grey70' ;;
    250) printf '%s\n' 'Grey74' ;;
    251) printf '%s\n' 'Grey78' ;;
    252) printf '%s\n' 'Grey82' ;;
    253) printf '%s\n' 'Grey85' ;;
    254) printf '%s\n' 'Grey89' ;;
    255) printf '%s\n' 'Grey93' ;;
    *) printf '%s\n' "Color${1:-?}" ;;
  esac
}

__shell_color_xterm_rgb() {
  local n="${1:-}"
  case "$n" in
    ''|*[!0-9]*) return 1 ;;
  esac
  [ "$n" -ge 0 ] 2>/dev/null || return 1
  [ "$n" -le 255 ] 2>/dev/null || return 1

  if [ "$n" -lt 16 ]; then
    case "$n" in
      0)  printf '0 0 0\n' ;;
      1)  printf '128 0 0\n' ;;
      2)  printf '0 128 0\n' ;;
      3)  printf '128 128 0\n' ;;
      4)  printf '0 0 128\n' ;;
      5)  printf '128 0 128\n' ;;
      6)  printf '0 128 128\n' ;;
      7)  printf '192 192 192\n' ;;
      8)  printf '128 128 128\n' ;;
      9)  printf '255 0 0\n' ;;
      10) printf '0 255 0\n' ;;
      11) printf '255 255 0\n' ;;
      12) printf '0 0 255\n' ;;
      13) printf '255 0 255\n' ;;
      14) printf '0 255 255\n' ;;
      15) printf '255 255 255\n' ;;
    esac
    return 0
  fi

  if [ "$n" -le 231 ]; then
    local c=$((n - 16)) r g b levels
    r=$((c / 36))
    g=$(((c % 36) / 6))
    b=$((c % 6))
    case "$r" in 0) r=0 ;; 1) r=95 ;; 2) r=135 ;; 3) r=175 ;; 4) r=215 ;; 5) r=255 ;; esac
    case "$g" in 0) g=0 ;; 1) g=95 ;; 2) g=135 ;; 3) g=175 ;; 4) g=215 ;; 5) g=255 ;; esac
    case "$b" in 0) b=0 ;; 1) b=95 ;; 2) b=135 ;; 3) b=175 ;; 4) b=215 ;; 5) b=255 ;; esac
    printf '%s %s %s\n' "$r" "$g" "$b"
    return 0
  fi

  local v=$((8 + (n - 232) * 10))
  printf '%s %s %s\n' "$v" "$v" "$v"
}

__shell_color_xterm_hex() {
  local r g b
  read -r r g b <<EOF_SHELL_COLOR_RGB
$(__shell_color_xterm_rgb "${1:-}")
EOF_SHELL_COLOR_RGB
  printf '#%02x%02x%02x\n' "$r" "$g" "$b"
}

__shell_color_resolve() {
  local raw="${1:-}" key
  key="$(__shell_color_norm "$raw")"
  case "$key" in
    '' ) return 1 ;;
    *[!0-9]* ) ;;
    * )
      if [ "$key" -ge 0 ] 2>/dev/null && [ "$key" -le 255 ] 2>/dev/null; then
        printf '%s\n' "$key"
        return 0
      fi
      ;;
  esac

  case "$key" in
    aqua) printf '%s\n' '14' ;;
    aquamarine1) printf '%s\n' '86' ;;
    aquamarine2) printf '%s\n' '122' ;;
    aquamarine3) printf '%s\n' '79' ;;
    black) printf '%s\n' '0' ;;
    blau) printf '%s\n' '12' ;;
    blue) printf '%s\n' '12' ;;
    blue1) printf '%s\n' '21' ;;
    blue3) printf '%s\n' '19' ;;
    blueviolet) printf '%s\n' '57' ;;
    cadetblue) printf '%s\n' '72' ;;
    chartreuse1) printf '%s\n' '118' ;;
    chartreuse2) printf '%s\n' '82' ;;
    chartreuse3) printf '%s\n' '70' ;;
    chartreuse4) printf '%s\n' '64' ;;
    cornflowerblue) printf '%s\n' '69' ;;
    cornsilk1) printf '%s\n' '230' ;;
    cyan) printf '%s\n' '14' ;;
    cyan1) printf '%s\n' '51' ;;
    cyan2) printf '%s\n' '50' ;;
    cyan3) printf '%s\n' '43' ;;
    darkblue) printf '%s\n' '18' ;;
    darkcyan) printf '%s\n' '36' ;;
    darkgoldenrod) printf '%s\n' '136' ;;
    darkgreen) printf '%s\n' '22' ;;
    darkkhaki) printf '%s\n' '143' ;;
    darkmagenta) printf '%s\n' '90' ;;
    darkolivegreen1) printf '%s\n' '191' ;;
    darkolivegreen2) printf '%s\n' '155' ;;
    darkolivegreen3) printf '%s\n' '107' ;;
    darkorange) printf '%s\n' '208' ;;
    darkorange3) printf '%s\n' '130' ;;
    darkred) printf '%s\n' '52' ;;
    darkseagreen) printf '%s\n' '108' ;;
    darkseagreen1) printf '%s\n' '158' ;;
    darkseagreen2) printf '%s\n' '151' ;;
    darkseagreen3) printf '%s\n' '115' ;;
    darkseagreen4) printf '%s\n' '65' ;;
    darkslategray1) printf '%s\n' '123' ;;
    darkslategray2) printf '%s\n' '87' ;;
    darkslategray3) printf '%s\n' '116' ;;
    darkturquoise) printf '%s\n' '44' ;;
    darkviolet) printf '%s\n' '92' ;;
    deeppink1) printf '%s\n' '198' ;;
    deeppink2) printf '%s\n' '197' ;;
    deeppink3) printf '%s\n' '161' ;;
    deeppink4) printf '%s\n' '53' ;;
    deepskyblue1) printf '%s\n' '39' ;;
    deepskyblue2) printf '%s\n' '38' ;;
    deepskyblue3) printf '%s\n' '31' ;;
    deepskyblue4) printf '%s\n' '23' ;;
    dodgerblue1) printf '%s\n' '33' ;;
    dodgerblue2) printf '%s\n' '27' ;;
    dodgerblue3) printf '%s\n' '26' ;;
    fuchsia) printf '%s\n' '13' ;;
    gelb) printf '%s\n' '11' ;;
    gold1) printf '%s\n' '220' ;;
    gold3) printf '%s\n' '142' ;;
    grau) printf '%s\n' '8' ;;
    gray) printf '%s\n' '8' ;;
    gray0) printf '%s\n' '16' ;;
    gray100) printf '%s\n' '231' ;;
    gray11) printf '%s\n' '234' ;;
    gray15) printf '%s\n' '235' ;;
    gray19) printf '%s\n' '236' ;;
    gray23) printf '%s\n' '237' ;;
    gray27) printf '%s\n' '238' ;;
    gray3) printf '%s\n' '232' ;;
    gray30) printf '%s\n' '239' ;;
    gray35) printf '%s\n' '240' ;;
    gray37) printf '%s\n' '59' ;;
    gray39) printf '%s\n' '241' ;;
    gray42) printf '%s\n' '242' ;;
    gray46) printf '%s\n' '243' ;;
    gray50) printf '%s\n' '244' ;;
    gray53) printf '%s\n' '102' ;;
    gray54) printf '%s\n' '245' ;;
    gray58) printf '%s\n' '246' ;;
    gray62) printf '%s\n' '247' ;;
    gray63) printf '%s\n' '139' ;;
    gray66) printf '%s\n' '248' ;;
    gray69) printf '%s\n' '145' ;;
    gray7) printf '%s\n' '233' ;;
    gray70) printf '%s\n' '249' ;;
    gray74) printf '%s\n' '250' ;;
    gray78) printf '%s\n' '251' ;;
    gray82) printf '%s\n' '252' ;;
    gray84) printf '%s\n' '188' ;;
    gray85) printf '%s\n' '253' ;;
    gray89) printf '%s\n' '254' ;;
    gray93) printf '%s\n' '255' ;;
    green) printf '%s\n' '10' ;;
    green1) printf '%s\n' '46' ;;
    green3) printf '%s\n' '34' ;;
    green4) printf '%s\n' '28' ;;
    greenyellow) printf '%s\n' '154' ;;
    grey) printf '%s\n' '8' ;;
    grey0) printf '%s\n' '16' ;;
    grey100) printf '%s\n' '231' ;;
    grey11) printf '%s\n' '234' ;;
    grey15) printf '%s\n' '235' ;;
    grey19) printf '%s\n' '236' ;;
    grey23) printf '%s\n' '237' ;;
    grey27) printf '%s\n' '238' ;;
    grey3) printf '%s\n' '232' ;;
    grey30) printf '%s\n' '239' ;;
    grey35) printf '%s\n' '240' ;;
    grey37) printf '%s\n' '59' ;;
    grey39) printf '%s\n' '241' ;;
    grey42) printf '%s\n' '242' ;;
    grey46) printf '%s\n' '243' ;;
    grey50) printf '%s\n' '244' ;;
    grey53) printf '%s\n' '102' ;;
    grey54) printf '%s\n' '245' ;;
    grey58) printf '%s\n' '246' ;;
    grey62) printf '%s\n' '247' ;;
    grey63) printf '%s\n' '139' ;;
    grey66) printf '%s\n' '248' ;;
    grey69) printf '%s\n' '145' ;;
    grey7) printf '%s\n' '233' ;;
    grey70) printf '%s\n' '249' ;;
    grey74) printf '%s\n' '250' ;;
    grey78) printf '%s\n' '251' ;;
    grey82) printf '%s\n' '252' ;;
    grey84) printf '%s\n' '188' ;;
    grey85) printf '%s\n' '253' ;;
    grey89) printf '%s\n' '254' ;;
    grey93) printf '%s\n' '255' ;;
    gruen) printf '%s\n' '10' ;;
    grun) printf '%s\n' '10' ;;
    grün) printf '%s\n' '10' ;;
    honeydew2) printf '%s\n' '194' ;;
    hotpink) printf '%s\n' '205' ;;
    hotpink2) printf '%s\n' '169' ;;
    hotpink3) printf '%s\n' '132' ;;
    indianred) printf '%s\n' '131' ;;
    indianred1) printf '%s\n' '203' ;;
    khaki1) printf '%s\n' '228' ;;
    khaki3) printf '%s\n' '185' ;;
    lightcoral) printf '%s\n' '210' ;;
    lightcyan1) printf '%s\n' '195' ;;
    lightcyan3) printf '%s\n' '152' ;;
    lightgoldenrod1) printf '%s\n' '227' ;;
    lightgoldenrod2) printf '%s\n' '186' ;;
    lightgoldenrod3) printf '%s\n' '179' ;;
    lightgreen) printf '%s\n' '119' ;;
    lightpink1) printf '%s\n' '217' ;;
    lightpink3) printf '%s\n' '174' ;;
    lightpink4) printf '%s\n' '95' ;;
    lightsalmon1) printf '%s\n' '216' ;;
    lightsalmon3) printf '%s\n' '137' ;;
    lightseagreen) printf '%s\n' '37' ;;
    lightskyblue1) printf '%s\n' '153' ;;
    lightskyblue3) printf '%s\n' '109' ;;
    lightslateblue) printf '%s\n' '105' ;;
    lightslategray) printf '%s\n' '103' ;;
    lightslategrey) printf '%s\n' '103' ;;
    lightsteelblue) printf '%s\n' '147' ;;
    lightsteelblue1) printf '%s\n' '189' ;;
    lightsteelblue3) printf '%s\n' '146' ;;
    lightyellow3) printf '%s\n' '187' ;;
    lila) printf '%s\n' '129' ;;
    lime) printf '%s\n' '10' ;;
    magenta) printf '%s\n' '13' ;;
    magenta1) printf '%s\n' '201' ;;
    magenta2) printf '%s\n' '165' ;;
    magenta3) printf '%s\n' '127' ;;
    maroon) printf '%s\n' '1' ;;
    mediumorchid) printf '%s\n' '134' ;;
    mediumorchid1) printf '%s\n' '171' ;;
    mediumorchid3) printf '%s\n' '133' ;;
    mediumpurple) printf '%s\n' '104' ;;
    mediumpurple1) printf '%s\n' '141' ;;
    mediumpurple2) printf '%s\n' '135' ;;
    mediumpurple3) printf '%s\n' '97' ;;
    mediumpurple4) printf '%s\n' '60' ;;
    mediumspringgreen) printf '%s\n' '49' ;;
    mediumturquoise) printf '%s\n' '80' ;;
    mediumvioletred) printf '%s\n' '126' ;;
    mint) printf '%s\n' '85' ;;
    mintcyan) printf '%s\n' '50' ;;
    mintturquoise) printf '%s\n' '50' ;;
    minz) printf '%s\n' '85' ;;
    minze) printf '%s\n' '85' ;;
    minztuerkis) printf '%s\n' '50' ;;
    minzturkis) printf '%s\n' '50' ;;
    minztürkis) printf '%s\n' '50' ;;
    mistyrose1) printf '%s\n' '224' ;;
    mistyrose3) printf '%s\n' '181' ;;
    navajowhite1) printf '%s\n' '223' ;;
    navajowhite3) printf '%s\n' '144' ;;
    navy) printf '%s\n' '4' ;;
    navyblue) printf '%s\n' '17' ;;
    olive) printf '%s\n' '3' ;;
    orange) printf '%s\n' '208' ;;
    orange1) printf '%s\n' '214' ;;
    orange3) printf '%s\n' '172' ;;
    orange4) printf '%s\n' '58' ;;
    orangered1) printf '%s\n' '202' ;;
    orchid) printf '%s\n' '170' ;;
    orchid1) printf '%s\n' '213' ;;
    orchid2) printf '%s\n' '212' ;;
    palegreen1) printf '%s\n' '121' ;;
    palegreen3) printf '%s\n' '77' ;;
    paleturquoise1) printf '%s\n' '159' ;;
    paleturquoise4) printf '%s\n' '66' ;;
    palevioletred1) printf '%s\n' '211' ;;
    pink) printf '%s\n' '13' ;;
    pink1) printf '%s\n' '218' ;;
    pink3) printf '%s\n' '175' ;;
    plum1) printf '%s\n' '219' ;;
    plum2) printf '%s\n' '183' ;;
    plum3) printf '%s\n' '176' ;;
    plum4) printf '%s\n' '96' ;;
    purple) printf '%s\n' '5' ;;
    purple3) printf '%s\n' '56' ;;
    purple4) printf '%s\n' '54' ;;
    red) printf '%s\n' '9' ;;
    red1) printf '%s\n' '196' ;;
    red3) printf '%s\n' '124' ;;
    rosa) printf '%s\n' '205' ;;
    rosybrown) printf '%s\n' '138' ;;
    rot) printf '%s\n' '9' ;;
    royalblue1) printf '%s\n' '63' ;;
    salmon1) printf '%s\n' '209' ;;
    sandybrown) printf '%s\n' '215' ;;
    schwarz) printf '%s\n' '0' ;;
    seagreen1) printf '%s\n' '84' ;;
    seagreen2) printf '%s\n' '83' ;;
    seagreen3) printf '%s\n' '78' ;;
    silber) printf '%s\n' '7' ;;
    silver) printf '%s\n' '7' ;;
    skyblue1) printf '%s\n' '117' ;;
    skyblue2) printf '%s\n' '111' ;;
    skyblue3) printf '%s\n' '74' ;;
    skyblue) printf '%s\n' '39' ;;
    himmelblau) printf '%s\n' '39' ;;
    slateblue1) printf '%s\n' '99' ;;
    slateblue3) printf '%s\n' '61' ;;
    springgreen1) printf '%s\n' '48' ;;
    springgreen2) printf '%s\n' '42' ;;
    springgreen3) printf '%s\n' '35' ;;
    springgreen4) printf '%s\n' '29' ;;
    steelblue) printf '%s\n' '67' ;;
    steelblue1) printf '%s\n' '75' ;;
    steelblue3) printf '%s\n' '68' ;;
    tan) printf '%s\n' '180' ;;
    teal) printf '%s\n' '6' ;;
    thistle1) printf '%s\n' '225' ;;
    thistle3) printf '%s\n' '182' ;;
    tuerkis) printf '%s\n' '14' ;;
    turkis) printf '%s\n' '14' ;;
    turquoise2) printf '%s\n' '45' ;;
    turquoise4) printf '%s\n' '30' ;;
    türkis) printf '%s\n' '14' ;;
    violet) printf '%s\n' '177' ;;
    violett) printf '%s\n' '177' ;;
    weiss) printf '%s\n' '15' ;;
    weiß) printf '%s\n' '15' ;;
    wheat1) printf '%s\n' '229' ;;
    wheat4) printf '%s\n' '101' ;;
    white) printf '%s\n' '15' ;;
    yellow) printf '%s\n' '11' ;;
    yellow1) printf '%s\n' '226' ;;
    yellow2) printf '%s\n' '190' ;;
    yellow3) printf '%s\n' '148' ;;
    yellow4) printf '%s\n' '100' ;;
    *) return 1 ;;
  esac
}

__shell_color_ansi_fg() {
  local idx="$1"
  printf '\033[38;5;%sm' "$idx"
}

__shell_color_ansi_bg() {
  local idx="$1"
  printf '\033[48;5;%sm' "$idx"
}

__shell_color_reset() {
  printf '\033[0m'
}

__shell_color_sample() {
  local idx="$1" label="${2:-}"
  local name hex
  name="$(__shell_color_xterm_name "$idx")"
  hex="$(__shell_color_xterm_hex "$idx")"
  [ -n "$label" ] || label="$name"
  printf '%b%3s %-22s %s%b\n' "$(__shell_color_ansi_fg "$idx")" "$idx" "$name" "$hex" "$(__shell_color_reset)"
}
# ---- shell-color xterm-256 core end ------------------------------------------


__shell_color_current_index() {
  local raw idx
  if [ -n "${SHELL_COLOR:-}" ]; then
    raw="$SHELL_COLOR"
  elif [ -r "$SHELL_COLOR_THEME_FILE" ]; then
    raw="$(command cat "$SHELL_COLOR_THEME_FILE" 2>/dev/null | command tr -d '[:space:]')"
  else
    raw="$SHELL_COLOR_DEFAULT"
  fi

  idx="$(__shell_color_resolve "$raw" 2>/dev/null)" || idx="$(__shell_color_resolve "$SHELL_COLOR_DEFAULT" 2>/dev/null)" || idx=85
  printf '%s\n' "$idx"
}

__shell_color_prompt_escape() {
  printf '\\[\033[38;5;%sm\\]' "$1"
}

__shell_color_prompt_bold() {
  printf '\\[\033[1m\\]'
}

__shell_color_prompt_reset() {
  printf '\\[\033[0m\\]'
}

__shell_color_ansi_bold() {
  printf '[1m'
}

__shell_color_prompt_literal() {
  local ch="${1:-}"
  case "$ch" in
    "\\") printf '%s' '\\\\' ;;
    '$') printf '%s' '\$' ;;
    '`') printf '%s' '\`' ;;
    '!') printf '%s' '\!' ;;
    *) printf '%s' "$ch" ;;
  esac
}

__shell_color_is_special_char() {
  case "${1:-}" in
    '!'|'"'|'§'|'$'|'%'|'&'|'/'|'('|')'|'='|'_'|':'|';'|'-'|'<'|'>'|'#'|"'"|'+'|'*'|'~'|'?'|'.'|'@'|'['|']')
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

__shell_color_prompt_path_value() {
  local cwd="${PWD:-}"
  if [ -n "${HOME:-}" ]; then
    case "$cwd" in
      "$HOME") printf '%s\n' '~' ;;
      "$HOME"/*) printf '~/%s\n' "${cwd#"$HOME"/}" ;;
      *) printf '%s\n' "$cwd" ;;
    esac
  else
    printf '%s\n' "$cwd"
  fi
}

__shell_color_host_value() {
  hostname -s 2>/dev/null || hostname 2>/dev/null || printf 'host'
}

__shell_color_local_ip_value() {
  local ip
  ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
  [ -n "$ip" ] || ip="$(ip route get 1 2>/dev/null | awk '/src/ {for (i=1;i<=NF;i++) if ($i=="src") {print $(i+1); exit}}')"
  printf '%s' "${ip:-local}"
}

__shell_color_public_ip_fetch() {
  local ip=""
  if command -v curl >/dev/null 2>&1; then
    ip="$(curl -fsS --max-time 3 "$SHELL_COLOR_PUBLIC_IP_SERVICE" 2>/dev/null)"
  elif command -v wget >/dev/null 2>&1; then
    ip="$(wget -qO- -T 3 "$SHELL_COLOR_PUBLIC_IP_SERVICE" 2>/dev/null)"
  fi
  ip="$(printf '%s' "$ip" | tr -d '[:space:]')"
  case "$ip" in
    *[!0-9a-fA-F:.]*|'') return 1 ;;
    *) printf '%s' "$ip" ;;
  esac
}

__shell_color_current_ip_mode() {
  local mode=""
  if [ -n "${SHELL_COLOR_IP_MODE:-}" ]; then
    mode="$SHELL_COLOR_IP_MODE"
  elif [ -r "$SHELL_COLOR_IP_MODE_FILE" ]; then
    mode="$(command cat "$SHELL_COLOR_IP_MODE_FILE" 2>/dev/null | command tr -d '[:space:]')"
  else
    mode="none"
  fi
  case "$mode" in
    local|ip|none) printf '%s
' "$mode" ;;
    *) printf '%s
' 'none' ;;
  esac
}

__shell_color_ip_value() {
  local mode ip
  mode="$(__shell_color_current_ip_mode)"
  case "$mode" in
    local)
      __shell_color_local_ip_value
      ;;
    ip)
      if [ -r "$SHELL_COLOR_PUBLIC_IP_FILE" ]; then
        ip="$(command cat "$SHELL_COLOR_PUBLIC_IP_FILE" 2>/dev/null | command tr -d '[:space:]')"
      fi
      printf '%s' "${ip:-public-ip?}"
      ;;
    *)
      printf '%s' ''
      ;;
  esac
}

__shell_color_set_ip_mode() {
  local mode="${1:-none}" ip=""
  mkdir -p "$(dirname "$SHELL_COLOR_IP_MODE_FILE")" || return 1

  case "$mode" in
    local|lokal)
      mode="local"
      printf '%s
' "$mode" > "$SHELL_COLOR_IP_MODE_FILE" || return 1
      export SHELL_COLOR_IP_MODE="$mode"
      __shell_color_runtime_msg "$(__shell_color_current_index)" "ok" "IP-Anzeige: local -> $(__shell_color_local_ip_value)"
      ;;
    ip|public|public-ip|publicip|oeffentlich|öffentlich)
      mode="ip"
      ip="$(__shell_color_public_ip_fetch)" || {
        __shell_color_runtime_err "Öffentliche IP konnte nicht ermittelt werden. Benötigt curl oder wget und Netzwerkzugriff."
        return 1
      }
      printf '%s
' "$ip" > "$SHELL_COLOR_PUBLIC_IP_FILE" || return 1
      printf '%s
' "$mode" > "$SHELL_COLOR_IP_MODE_FILE" || return 1
      export SHELL_COLOR_IP_MODE="$mode"
      __shell_color_runtime_msg "$(__shell_color_current_index)" "ok" "IP-Anzeige: public -> $ip"
      ;;
    none|off|aus|unset|remove)
      mode="none"
      printf '%s
' 'none' > "$SHELL_COLOR_IP_MODE_FILE" || return 1
      rm -f -- "$SHELL_COLOR_PUBLIC_IP_FILE" 2>/dev/null || true
      export SHELL_COLOR_IP_MODE="none"
      __shell_color_runtime_msg "$(__shell_color_current_index)" "ok" "IP-Anzeige entfernt."
      ;;
    *)
      __shell_color_runtime_err "Unbekannter IP-Modus: $mode"
      return 2
      ;;
  esac

  case "$mode" in
    local|ip) __shell_color_enable_ip_style || return 1 ;;
    none) __shell_color_disable_ip_style || return 1 ;;
  esac

  shell-color-apply
  __shell_color_prompt_preview_by_index "$(__shell_color_current_index)"
}

__shell_color_unset_ip_mode() {
  __shell_color_set_ip_mode none
}

__shell_color_current_style() {
  local style=""
  if [ -n "${SHELL_COLOR_PS1_STYLE:-}" ]; then
    style="$SHELL_COLOR_PS1_STYLE"
  elif [ -r "$SHELL_COLOR_STYLE_FILE" ]; then
    style="$(command cat "$SHELL_COLOR_STYLE_FILE" 2>/dev/null | command tr -d '[:space:]')"
  else
    style="$SHELL_COLOR_DEFAULT_STYLE"
  fi

  case "$style" in
    keep|compact|compact-ip|arrow|brackets|arrow-ip|brackets-ip) printf '%s\n' "$style" ;;
    *) printf '%s\n' "$SHELL_COLOR_DEFAULT_STYLE" ;;
  esac
}

__shell_color_write_style() {
  local style="$1"
  mkdir -p "$(dirname "$SHELL_COLOR_STYLE_FILE")" || return 1
  printf '%s\n' "$style" > "$SHELL_COLOR_STYLE_FILE" || return 1
  export SHELL_COLOR_PS1_STYLE="$style"
}

__shell_color_enable_ip_style() {
  local style
  style="$(__shell_color_current_style)"
  case "$style" in
    compact) style="compact-ip" ;;
    arrow) style="arrow-ip" ;;
    brackets) style="brackets-ip" ;;
    *) return 0 ;;
  esac
  __shell_color_write_style "$style"
}

__shell_color_disable_ip_style() {
  local style
  style="$(__shell_color_current_style)"
  case "$style" in
    compact-ip) style="compact" ;;
    arrow-ip) style="arrow" ;;
    brackets-ip) style="brackets" ;;
    *) return 0 ;;
  esac
  __shell_color_write_style "$style"
}

__shell_color_set_style() {
  local style="${1:-}"
  case "$style" in
    1|keep|beibehalten|current|none) style="keep" ;;
    2|compact|standard|classic|klassisch) style="compact" ;;
    3|compact-ip|ip|with-ip|mit-ip|mitip) style="compact-ip" ;;
    4|arrow|pfeil) style="arrow" ;;
    5|brackets|klammern|bracket|box) style="brackets" ;;
    6|arrow-ip|arrowip|pfeil-ip|pfeilip) style="arrow-ip" ;;
    7|brackets-ip|bracketsip|bracket-ip|klammern-ip|klammernip|box-ip) style="brackets-ip" ;;
    list|--list|-l)
      __shell_color_style_list
      return 0
      ;;
    *)
      __shell_color_runtime_err "Unbekannter PS1-Style: $style"
      __shell_color_style_list >&2
      return 2
      ;;
  esac

  __shell_color_write_style "$style" || return 1

  # Jeder *-ip-Style aktiviert standardmäßig die lokale IP, wenn kein Modus gesetzt ist.
  case "$style" in
    compact-ip|arrow-ip|brackets-ip)
      if [ "$(__shell_color_current_ip_mode)" = "none" ]; then
        mkdir -p "$(dirname "$SHELL_COLOR_IP_MODE_FILE")" 2>/dev/null || true
        printf '%s\n' 'local' > "$SHELL_COLOR_IP_MODE_FILE" 2>/dev/null || true
        export SHELL_COLOR_IP_MODE="local"
      fi
      ;;
  esac

  shell-color-apply
  __shell_color_runtime_msg "$(__shell_color_current_index)" "ok" "PS1-Style gesetzt: $style"
  __shell_color_prompt_preview_by_index "$(__shell_color_current_index)"
}

__shell_color_style_list() {
  cat <<'SHELL_COLOR_STYLE_LIST'
PS1-Styles:
  1 keep        Shell beibehalten, keine PS1-Änderung
  2 compact     (user@host ~/folder/file.type) $
  3 compact-ip  (user@host[IP] ~/folder/file.type) $
  4 arrow       <user@host ~/folder/file.type> $
  5 brackets    [user@host ~/folder/file.type] $
  6 arrow-ip    <user@host(IP) ~/folder/file.type> $
  7 brackets-ip [user@host(IP) ~/folder/file.type] $
SHELL_COLOR_STYLE_LIST
}

__shell_color_current_path_position() {
  local position=""
  if [ -n "${SHELL_COLOR_PATH_POSITION:-}" ]; then
    position="$SHELL_COLOR_PATH_POSITION"
  elif [ -r "$SHELL_COLOR_PATH_POSITION_FILE" ]; then
    position="$(command cat "$SHELL_COLOR_PATH_POSITION_FILE" 2>/dev/null | command tr -d '[:space:]')"
  else
    position="$SHELL_COLOR_DEFAULT_PATH_POSITION"
  fi

  case "$position" in
    inside|outside) printf '%s\n' "$position" ;;
    *) printf '%s\n' "$SHELL_COLOR_DEFAULT_PATH_POSITION" ;;
  esac
}

__shell_color_set_path_position() {
  local position="${1:-}"
  case "$position" in
    inside|in|innen) position="inside" ;;
    outside|out|aussen|außen) position="outside" ;;
    *)
      __shell_color_runtime_err "Unbekannte Path-Position: ${position:-<leer>}. Nutze inside oder outside."
      return 2
      ;;
  esac

  mkdir -p "$(dirname "$SHELL_COLOR_PATH_POSITION_FILE")" || return 1
  printf '%s\n' "$position" > "$SHELL_COLOR_PATH_POSITION_FILE" || return 1
  export SHELL_COLOR_PATH_POSITION="$position"

  shell-color-apply
  __shell_color_runtime_msg "$(__shell_color_current_index)" "ok" "Path-Position gesetzt: $position"
  __shell_color_prompt_preview_by_index "$(__shell_color_current_index)"
}

__shell_color_token_is_url() {
  case "${1:-}" in
    http://*|https://*|ftp://*|www.*) return 0 ;;
    *) return 1 ;;
  esac
}

__shell_color_token_is_version() {
  local token="${1:-}"
  token="${token%,}"
  token="${token%;}"
  token="${token%)}"
  token="${token%]}"
  case "$token" in
    http://*|https://*|ftp://*|www.*) return 1 ;;
  esac
  [[ "$token" =~ ^v?[0-9]+([._-][0-9A-Za-z]+)+$ ]]
}

__shell_color_render_prompt_plain_token() {
  local idx="$1" token="${2:-}" reset textc i ch
  reset="$(__shell_color_prompt_reset)"
  textc="$(__shell_color_prompt_escape "$idx")"
  i=0
  while [ "$i" -lt "${#token}" ]; do
    ch="${token:i:1}"
    printf '%s' "$textc"
    __shell_color_prompt_literal "$ch"
    printf '%s' "$reset"
    i=$((i + 1))
  done
}

__shell_color_render_prompt_colored_token() {
  local idx="$1" text_idx="$2" token="${3:-}" bold="${4:-0}"
  local i ch reset textc accent numberc
  reset="$(__shell_color_prompt_reset)"
  textc="$(__shell_color_prompt_escape "$text_idx")"
  [ "$bold" = "1" ] && textc="$(__shell_color_prompt_bold)$textc"
  accent="$(__shell_color_prompt_bold)$(__shell_color_prompt_escape "$idx")"
  numberc="$(__shell_color_prompt_bold)$(__shell_color_prompt_escape 15)"

  i=0
  while [ "$i" -lt "${#token}" ]; do
    ch="${token:i:1}"
    if __shell_color_is_special_char "$ch"; then
      printf '%s' "$accent"
      __shell_color_prompt_literal "$ch"
      printf '%s' "$reset"
    elif [[ "$ch" =~ [0-9] ]]; then
      printf '%s' "$numberc"
      __shell_color_prompt_literal "$ch"
      printf '%s' "$reset"
    else
      printf '%s' "$textc"
      __shell_color_prompt_literal "$ch"
      printf '%s' "$reset"
    fi
    i=$((i + 1))
  done
}

__shell_color_render_text_prompt() {
  local idx="$1" text_idx="$2" text="${3:-}" bold="${4:-0}"
  local rest token ws
  rest="$text"
  while [ -n "$rest" ]; do
    if [[ "$rest" =~ ^([[:space:]]+) ]]; then
      ws="${BASH_REMATCH[1]}"
      __shell_color_render_prompt_plain_token "$text_idx" "$ws"
      rest="${rest:${#ws}}"
    elif [[ "$rest" =~ ^([^[:space:]]+) ]]; then
      token="${BASH_REMATCH[1]}"
      if __shell_color_token_is_url "$token"; then
        __shell_color_render_prompt_plain_token 244 "$token"
      elif __shell_color_token_is_version "$token"; then
        __shell_color_render_prompt_plain_token "$text_idx" "$token"
      else
        __shell_color_render_prompt_colored_token "$idx" "$text_idx" "$token" "$bold"
      fi
      rest="${rest:${#token}}"
    else
      __shell_color_render_prompt_plain_token "$text_idx" "$rest"
      break
    fi
  done
}

__shell_color_render_ansi_plain_token() {
  local idx="$1" token="${2:-}" reset textc
  reset="$(__shell_color_reset)"
  textc="$(__shell_color_ansi_fg "$idx")"
  printf '%b%s%b' "$textc" "$token" "$reset"
}

__shell_color_render_ansi_colored_token() {
  local idx="$1" text_idx="$2" token="${3:-}" bold="${4:-0}"
  local i ch reset textc accent numberc
  reset="$(__shell_color_reset)"
  textc="$(__shell_color_ansi_fg "$text_idx")"
  [ "$bold" = "1" ] && textc="$(__shell_color_ansi_bold)$textc"
  accent="$(__shell_color_ansi_bold)$(__shell_color_ansi_fg "$idx")"
  numberc="$(__shell_color_ansi_bold)$(__shell_color_ansi_fg 15)"

  i=0
  while [ "$i" -lt "${#token}" ]; do
    ch="${token:i:1}"
    if __shell_color_is_special_char "$ch"; then
      printf '%b%s%b' "$accent" "$ch" "$reset"
    elif [[ "$ch" =~ [0-9] ]]; then
      printf '%b%s%b' "$numberc" "$ch" "$reset"
    else
      printf '%b%s%b' "$textc" "$ch" "$reset"
    fi
    i=$((i + 1))
  done
}

__shell_color_render_text_ansi() {
  local idx="$1" text_idx="$2" text="${3:-}" bold="${4:-0}"
  local rest token ws
  rest="$text"
  while [ -n "$rest" ]; do
    if [[ "$rest" =~ ^([[:space:]]+) ]]; then
      ws="${BASH_REMATCH[1]}"
      printf '%s' "$ws"
      rest="${rest:${#ws}}"
    elif [[ "$rest" =~ ^([^[:space:]]+) ]]; then
      token="${BASH_REMATCH[1]}"
      if __shell_color_token_is_url "$token"; then
        __shell_color_render_ansi_plain_token 244 "$token"
      elif __shell_color_token_is_version "$token"; then
        __shell_color_render_ansi_plain_token "$text_idx" "$token"
      else
        __shell_color_render_ansi_colored_token "$idx" "$text_idx" "$token" "$bold"
      fi
      rest="${rest:${#token}}"
    else
      printf '%s' "$rest"
      break
    fi
  done
}

__shell_color_build_prompt() {
  local idx="$1" style="$2" user="$3" host="$4" ip="$5" path="$6" position="${7:-inside}"
  case "$style" in
    compact)
      __shell_color_render_text_prompt "$idx" 255 "(" 1
      __shell_color_render_text_prompt "$idx" 255 "$user" 1
      __shell_color_render_text_prompt "$idx" 250 "@$host" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_prompt "$idx" 255 ") " 1
        __shell_color_render_text_prompt "$idx" 250 "$path" 0
        __shell_color_render_text_prompt "$idx" 255 " $ " 1
      else
        __shell_color_render_text_prompt "$idx" 250 " $path" 0
        __shell_color_render_text_prompt "$idx" 255 ") $ " 1
      fi
      ;;
    compact-ip)
      __shell_color_render_text_prompt "$idx" 255 "(" 1
      __shell_color_render_text_prompt "$idx" 255 "$user" 1
      __shell_color_render_text_prompt "$idx" 250 "@$host" 0
      [ -n "$ip" ] && __shell_color_render_text_prompt "$idx" 244 "[$ip]" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_prompt "$idx" 255 ") " 1
        __shell_color_render_text_prompt "$idx" 250 "$path" 0
        __shell_color_render_text_prompt "$idx" 255 " $ " 1
      else
        __shell_color_render_text_prompt "$idx" 250 " $path" 0
        __shell_color_render_text_prompt "$idx" 255 ") $ " 1
      fi
      ;;
    arrow)
      __shell_color_render_text_prompt "$idx" 244 "<" 0
      __shell_color_render_text_prompt "$idx" 255 "$user" 1
      __shell_color_render_text_prompt "$idx" 250 "@$host" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_prompt "$idx" 244 "> " 0
        __shell_color_render_text_prompt "$idx" 250 "$path" 0
        __shell_color_render_text_prompt "$idx" 255 " $ " 1
      else
        __shell_color_render_text_prompt "$idx" 250 " $path" 0
        __shell_color_render_text_prompt "$idx" 255 "> $ " 1
      fi
      ;;
    brackets)
      __shell_color_render_text_prompt "$idx" 244 "[" 0
      __shell_color_render_text_prompt "$idx" 255 "$user" 1
      __shell_color_render_text_prompt "$idx" 250 "@$host" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_prompt "$idx" 244 "] " 0
        __shell_color_render_text_prompt "$idx" 250 "$path" 0
        __shell_color_render_text_prompt "$idx" 255 " $ " 1
      else
        __shell_color_render_text_prompt "$idx" 250 " $path" 0
        __shell_color_render_text_prompt "$idx" 255 "] $ " 1
      fi
      ;;
    arrow-ip)
      __shell_color_render_text_prompt "$idx" 244 "<" 0
      __shell_color_render_text_prompt "$idx" 255 "$user" 1
      __shell_color_render_text_prompt "$idx" 250 "@$host" 0
      [ -n "$ip" ] && __shell_color_render_text_prompt "$idx" 244 "($ip)" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_prompt "$idx" 244 "> " 0
        __shell_color_render_text_prompt "$idx" 250 "$path" 0
        __shell_color_render_text_prompt "$idx" 255 " $ " 1
      else
        __shell_color_render_text_prompt "$idx" 250 " $path" 0
        __shell_color_render_text_prompt "$idx" 255 "> $ " 1
      fi
      ;;
    brackets-ip)
      __shell_color_render_text_prompt "$idx" 244 "[" 0
      __shell_color_render_text_prompt "$idx" 255 "$user" 1
      __shell_color_render_text_prompt "$idx" 250 "@$host" 0
      [ -n "$ip" ] && __shell_color_render_text_prompt "$idx" 244 "($ip)" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_prompt "$idx" 244 "] " 0
        __shell_color_render_text_prompt "$idx" 250 "$path" 0
        __shell_color_render_text_prompt "$idx" 255 " $ " 1
      else
        __shell_color_render_text_prompt "$idx" 250 " $path" 0
        __shell_color_render_text_prompt "$idx" 255 "] $ " 1
      fi
      ;;
    *)
      return 0
      ;;
  esac
}

__shell_color_build_ansi() {
  local idx="$1" style="$2" user="$3" host="$4" ip="$5" path="$6" position="${7:-inside}"
  case "$style" in
    keep)
      __shell_color_render_text_ansi "$idx" 244 "Shell beibehalten: " 0
      __shell_color_render_text_ansi "$idx" 250 "PS1 wird nicht überschrieben. Mapping-Vorschau: " 0
      __shell_color_render_text_ansi "$idx" 255 "$user" 1
      __shell_color_render_text_ansi "$idx" 250 "@$host" 0
      __shell_color_render_text_ansi "$idx" 250 ":$path " 0
      __shell_color_render_text_ansi "$idx" 255 "$ " 1
      ;;
    compact)
      __shell_color_render_text_ansi "$idx" 255 "(" 1
      __shell_color_render_text_ansi "$idx" 255 "$user" 1
      __shell_color_render_text_ansi "$idx" 250 "@$host" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_ansi "$idx" 255 ") " 1
        __shell_color_render_text_ansi "$idx" 250 "$path" 0
        __shell_color_render_text_ansi "$idx" 255 " $ " 1
      else
        __shell_color_render_text_ansi "$idx" 250 " $path" 0
        __shell_color_render_text_ansi "$idx" 255 ") $ " 1
      fi
      ;;
    compact-ip)
      __shell_color_render_text_ansi "$idx" 255 "(" 1
      __shell_color_render_text_ansi "$idx" 255 "$user" 1
      __shell_color_render_text_ansi "$idx" 250 "@$host" 0
      [ -n "$ip" ] && __shell_color_render_text_ansi "$idx" 244 "[$ip]" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_ansi "$idx" 255 ") " 1
        __shell_color_render_text_ansi "$idx" 250 "$path" 0
        __shell_color_render_text_ansi "$idx" 255 " $ " 1
      else
        __shell_color_render_text_ansi "$idx" 250 " $path" 0
        __shell_color_render_text_ansi "$idx" 255 ") $ " 1
      fi
      ;;
    arrow)
      __shell_color_render_text_ansi "$idx" 244 "<" 0
      __shell_color_render_text_ansi "$idx" 255 "$user" 1
      __shell_color_render_text_ansi "$idx" 250 "@$host" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_ansi "$idx" 244 "> " 0
        __shell_color_render_text_ansi "$idx" 250 "$path" 0
        __shell_color_render_text_ansi "$idx" 255 " $ " 1
      else
        __shell_color_render_text_ansi "$idx" 250 " $path" 0
        __shell_color_render_text_ansi "$idx" 255 "> $ " 1
      fi
      ;;
    brackets)
      __shell_color_render_text_ansi "$idx" 244 "[" 0
      __shell_color_render_text_ansi "$idx" 255 "$user" 1
      __shell_color_render_text_ansi "$idx" 250 "@$host" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_ansi "$idx" 244 "] " 0
        __shell_color_render_text_ansi "$idx" 250 "$path" 0
        __shell_color_render_text_ansi "$idx" 255 " $ " 1
      else
        __shell_color_render_text_ansi "$idx" 250 " $path" 0
        __shell_color_render_text_ansi "$idx" 255 "] $ " 1
      fi
      ;;
    arrow-ip)
      __shell_color_render_text_ansi "$idx" 244 "<" 0
      __shell_color_render_text_ansi "$idx" 255 "$user" 1
      __shell_color_render_text_ansi "$idx" 250 "@$host" 0
      [ -n "$ip" ] && __shell_color_render_text_ansi "$idx" 244 "($ip)" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_ansi "$idx" 244 "> " 0
        __shell_color_render_text_ansi "$idx" 250 "$path" 0
        __shell_color_render_text_ansi "$idx" 255 " $ " 1
      else
        __shell_color_render_text_ansi "$idx" 250 " $path" 0
        __shell_color_render_text_ansi "$idx" 255 "> $ " 1
      fi
      ;;
    brackets-ip)
      __shell_color_render_text_ansi "$idx" 244 "[" 0
      __shell_color_render_text_ansi "$idx" 255 "$user" 1
      __shell_color_render_text_ansi "$idx" 250 "@$host" 0
      [ -n "$ip" ] && __shell_color_render_text_ansi "$idx" 244 "($ip)" 0
      if [ "$position" = "outside" ]; then
        __shell_color_render_text_ansi "$idx" 244 "] " 0
        __shell_color_render_text_ansi "$idx" 250 "$path" 0
        __shell_color_render_text_ansi "$idx" 255 " $ " 1
      else
        __shell_color_render_text_ansi "$idx" 250 " $path" 0
        __shell_color_render_text_ansi "$idx" 255 "] $ " 1
      fi
      ;;
    *)
      __shell_color_build_ansi "$idx" compact "$user" "$host" "$ip" "$path" "$position"
      ;;
  esac
}

__shell_color_apply_ps1() {
  local idx style user host ip path position rendered
  style="$(__shell_color_current_style)"
  [ "$style" = "keep" ] && return 0

  idx="$(__shell_color_current_index)"
  user="${USER:-user}"
  host="$(__shell_color_host_value)"
  ip="$(__shell_color_ip_value)"
  path="$(__shell_color_prompt_path_value)"
  position="$(__shell_color_current_path_position)"
  rendered="$(__shell_color_build_prompt "$idx" "$style" "$user" "$host" "$ip" "$path" "$position")"
  PS1="$rendered"
  # Optional owner-defined decorator; never eval arbitrary shell text.
  # UpdateWulf uses this to append its cached one-line status header after
  # Shell-Color rebuilds PS1, regardless of profile load order.
  if [ -n "${SHELL_COLOR_PS1_DECORATOR:-}" ] &&
     declare -F "$SHELL_COLOR_PS1_DECORATOR" >/dev/null 2>&1; then
    "$SHELL_COLOR_PS1_DECORATOR"
  fi
}

__shell_color_install_prompt_command() {
  # Bash 5+ can represent PROMPT_COMMAND as an indexed array. Converting that
  # array into a scalar silently destroys user hooks (including UpdateWulf).
  # Keep the original representation, contents and execution order intact.
  if declare -p PROMPT_COMMAND 2>/dev/null | grep -q '^declare -a '; then
    local entry
    for entry in "${PROMPT_COMMAND[@]}"; do
      case "$entry" in
        *__shell_color_apply_ps1*) return 0 ;;
      esac
    done
    PROMPT_COMMAND+=(__shell_color_apply_ps1)
    return 0
  fi
  case "${PROMPT_COMMAND:-}" in
    *__shell_color_apply_ps1*) return 0 ;;
  esac
  if [ -n "${PROMPT_COMMAND:-}" ]; then
    PROMPT_COMMAND="__shell_color_apply_ps1; ${PROMPT_COMMAND}"
  else
    PROMPT_COMMAND="__shell_color_apply_ps1"
  fi
}

__shell_color_osc4() {
  local idx="$1" hex="$2"
  printf '\033]4;%s;%s\007' "$idx" "$hex"
}

__shell_color_terminal_global_enabled() {
  [ "${SHELL_COLOR_TERMINAL_GLOBAL:-0}" = "1" ]
}

__shell_color_apply_xterm_palette() {
  [ -t 1 ] || return 0
  [ "${TERM:-}" = "dumb" ] && return 0
  # OSC 4 changes terminal-emulator state and survives SSH/session exit.
  # Keep shell-color shell-local by default; terminal-global recoloring is opt-in.
  __shell_color_terminal_global_enabled || return 0
  [ "${SHELL_COLOR_DISABLE_OSC256:-}" = "1" ] && return 0

  local i hex
  i=0
  while [ "$i" -le 255 ]; do
    hex="$(__shell_color_xterm_hex "$i")"
    __shell_color_osc4 "$i" "$hex"
    i=$((i + 1))
  done
}

__shell_color_cursor_sequence() {
  local selected_hex="$1"
  # OSC 12 setzt die Farbe; DECSET 12 und DECSCUSR 1 fordern Blinken + Block an.
  printf '\033]12;%s\007\033[?12h\033[1 q' "$selected_hex"
}

__shell_color_apply_cursor() {
  [ -t 1 ] || return 0
  [ "${TERM:-}" = "dumb" ] && return 0
  # OSC 12 / DECSCUSR are terminal-global too; do not leak into parent shells.
  __shell_color_terminal_global_enabled || return 0
  [ "${SHELL_COLOR_DISABLE_CURSOR:-}" = "1" ] && return 0

  local idx selected_hex
  idx="$(__shell_color_current_index)"
  selected_hex="$(__shell_color_xterm_hex "$idx")"
  __shell_color_cursor_sequence "$selected_hex"
}

__shell_color_apply_less_man() {
  local idx accent standout
  idx="$(__shell_color_current_index)"
  accent="$(printf '\033[1;38;5;%sm' "$idx")"
  standout="$(printf '\033[48;5;%sm\033[38;5;15m' "$idx")"

  export LESS='-R'
  export LESS_TERMCAP_mb="${accent}"
  export LESS_TERMCAP_md="${accent}"
  export LESS_TERMCAP_me=$'\033[0m'
  export LESS_TERMCAP_se=$'\033[0m'
  export LESS_TERMCAP_so="${standout}"
  export LESS_TERMCAP_ue=$'\033[0m'
  export LESS_TERMCAP_us="${accent}"
}

shell-color-apply() {
  __shell_color_apply_ps1
  __shell_color_install_prompt_command
  __shell_color_apply_xterm_palette
  __shell_color_apply_cursor
  __shell_color_apply_less_man
  export COLORTERM=truecolor
}

shell-color-reset-palette() {
  # OSC 104: Palette, OSC 112: Cursorfarbe, DECSCUSR 0: Terminalstandard.
  [ -t 1 ] && printf '\033]104\007\033]112\007\033[0 q'
}

__shell_color_runtime_msg() {
  local idx="$1" label="$2"
  shift 2
  printf '%b%s%b ' "$(__shell_color_ansi_bold)$(__shell_color_ansi_fg "$idx")" "$label" "$(__shell_color_reset)"
  __shell_color_render_text_ansi "$idx" 250 "$*"
  printf '\n'
}

__shell_color_runtime_err() {
  printf '%bxx%b ' "$(__shell_color_ansi_fg 196)" "$(__shell_color_reset)" >&2
  __shell_color_render_text_ansi 196 250 "$*" >&2
  printf '\n' >&2
}

__shell_color_prompt_preview_by_index() {
  local idx="$1" style name hex user host ip cwd position
  style="$(__shell_color_current_style)"
  name="$(__shell_color_xterm_name "$idx")"
  hex="$(__shell_color_xterm_hex "$idx")"
  user="${USER:-user}"
  host="$(__shell_color_host_value)"
  ip="$(__shell_color_ip_value)"
  cwd="$(__shell_color_prompt_path_value)"
  position="$(__shell_color_current_path_position)"

  __shell_color_render_text_ansi "$idx" 250 "PS1 Vorschau"
  printf '  '
  __shell_color_render_text_ansi "$idx" 244 "$idx $name $hex style=$style path_position=$position"
  printf '\n'
  __shell_color_build_ansi "$idx" "$style" "$user" "$host" "$ip" "$cwd" "$position"
  printf '\n'
}

__shell_color_preview_styles_by_index() {
  local idx="$1" user host ip path position
  user="${USER:-user}"
  host="$(__shell_color_host_value)"
  ip="$(__shell_color_ip_value)"
  ip="${ip:-192.0.2.100}"
  path="~/folder/file.type"
  position="$(__shell_color_current_path_position)"

  __shell_color_render_text_ansi "$idx" 250 "PS1-Styles mit aktueller Farbe:"
  printf '\n'
  for style in keep compact compact-ip arrow brackets arrow-ip brackets-ip; do
    __shell_color_render_text_ansi "$idx" 244 "  $style  "
    __shell_color_build_ansi "$idx" "$style" "$user" "$host" "$ip" "$path" "$position"
    printf '\n'
  done
}

__shell_color_set() {
  local raw="${1:-}" idx name hex
  if [ -z "$raw" ]; then
    __shell_color_runtime_err "Farbe fehlt. Beispiel: shell-color --set mint"
    return 2
  fi

  case "$raw" in
    local|lokal)
      __shell_color_set_ip_mode local
      return $?
      ;;
    ip|public|public-ip|publicip|oeffentlich|öffentlich)
      __shell_color_set_ip_mode ip
      return $?
      ;;
  esac

  idx="$(__shell_color_resolve "$raw" 2>/dev/null)" || {
    __shell_color_runtime_err "Unbekannte Farbe: $raw"
    __shell_color_runtime_err "Nutze Nummer 0-255, xterm-Name oder Alias. Beispiel: shell-color --list"
    return 2
  }

  mkdir -p "$(dirname "$SHELL_COLOR_THEME_FILE")" || return 1
  printf '%s
' "$idx" > "$SHELL_COLOR_THEME_FILE" || return 1
  export SHELL_COLOR="$idx"

  shell-color-apply

  name="$(__shell_color_xterm_name "$idx")"
  hex="$(__shell_color_xterm_hex "$idx")"
  __shell_color_runtime_msg "$idx" "ok" "shell-color gesetzt: $raw -> $idx $name $hex"
  __shell_color_prompt_preview_by_index "$idx"
}

__shell_color_current() {
  local idx name hex style path_position ip_mode ip_value
  idx="$(__shell_color_current_index)"
  name="$(__shell_color_xterm_name "$idx")"
  hex="$(__shell_color_xterm_hex "$idx")"
  style="$(__shell_color_current_style)"
  path_position="$(__shell_color_current_path_position)"
  ip_mode="$(__shell_color_current_ip_mode)"
  ip_value="$(__shell_color_ip_value)"
  if [ -n "$ip_value" ]; then
    printf '%s %s %s style=%s path_position=%s ip_mode=%s ip=%s
' "$idx" "$name" "$hex" "$style" "$path_position" "$ip_mode" "$ip_value"
  else
    printf '%s %s %s style=%s path_position=%s ip_mode=%s
' "$idx" "$name" "$hex" "$style" "$path_position" "$ip_mode"
  fi
}

__shell_color_list() {
  local i
  i=0
  while [ "$i" -le 255 ]; do
    __shell_color_sample "$i"
    i=$((i + 1))
  done
}

__shell_color_aliases() {
  cat <<'SHELL_COLOR_ALIASES'
Deutsch/Englisch-Aliase:
  mint|minz|minze                -> 85 SeaGreen1 #5fffaf
  minztuerkis|minztürkis         -> 50 Cyan2 #00ffd7
  red|rot                        -> 9 Red #ff0000
  blue|blau                      -> 12 Blue #0000ff
  sky-blue|himmelblau            -> 39 DeepSkyBlue1 #00afff
  cyan|tuerkis|türkis            -> 14 Aqua #00ffff
  aquamarine1                    -> 86 Aquamarine1 #5fffd7
  aquamarine2                    -> 122 Aquamarine1 #87ffd7
  aquamarine3                    -> 79 Aquamarine3 #5fd7af

Alle xterm-256-Farben sind zusätzlich per Nummer 0-255 und xterm-Name auswählbar.
SHELL_COLOR_ALIASES
}

__shell_color_pacman_colorize() {
  local idx line
  idx="$(__shell_color_current_index)"
  while IFS= read -r line; do
    __shell_color_render_text_ansi "$idx" 250 "$line"
    printf '
'
  done
}

__shell_color_help() {
  cat <<'SHELL_COLOR_HELP'
Nutzung:
  shell-color --set mint
  shell-color --set minz
  shell-color --set blue
  shell-color --set blau
  shell-color --set sky-blue
  shell-color sky-blue

Befehle:
  shell-color --set <0-255|xterm-name|alias>   Farbe speichern und anwenden
  shell-color <0-255|xterm-name|alias>         PS1-Vorschau ohne Speichern
  shell-color --style <1-7|name>               PS1-Style speichern
  shell-color --style list                     PS1-Styles anzeigen
  shell-color --path-position <inside|outside> Pfad innerhalb/außerhalb der Klammer anzeigen
  shell-color --preview-styles                 alle PS1-Styles als Vorschau anzeigen
  shell-color --current                        aktuelle Farbe, Style und IP-Modus anzeigen
  shell-color --list                           alle 256 xterm-Farben anzeigen
  shell-color --aliases                        Deutsch/Englisch-Aliase anzeigen
  shell-color --apply                          gespeicherte Farbe erneut anwenden
  shell-color --reset-palette                  Palette, Cursorfarbe und Cursorform zurücksetzen
  shell-color --version                        installierte Version anzeigen

IP/local nach der Installation:
  shell-color --set local                      lokale IP anzeigen und passenden *-ip-Style wählen
  shell-color --unset local                    IP entfernen und zum passenden Basis-Style wechseln
  shell-color --set ip                         öffentliche IP abrufen und passenden *-ip-Style wählen
  shell-color --unset ip                       IP entfernen und zum passenden Basis-Style wechseln

Output-Rendering:
  Weblinks werden grau gerendert.
  Zahlen werden leuchtend/fett weiß gerendert.
  Versionen wie 1.2.3 oder v1.2.3 und URLs behalten ihr eigenes Coloring.
  Sonderzeichen: ! " § $ % & / ( ) = _ : ; - < > # ' + * ~ ? . @ [ ]

Pacman:
  shell-color hijackt pacman nicht automatisch.
  Sichere Variante für Such-/Listenoutput:
    pacman -Ss paketname | shell-color --pacman-colorize
  Für Install-/Update-Transaktionen pacman direkt laufen lassen, damit TTY, Rückfragen und Exitcodes unverändert bleiben.
SHELL_COLOR_HELP
}

shell-color() {
  local cmd="${1:-}" idx arg
  case "$cmd" in
    --set|-s|set)
      shift
      __shell_color_set "${1:-}"
      ;;
    --unset|unset)
      shift
      arg="${1:-}"
      case "$arg" in
        local|lokal|ip|public|public-ip|publicip|oeffentlich|öffentlich)
          __shell_color_unset_ip_mode
          ;;
        *)
          __shell_color_runtime_err "Unbekanntes unset-Ziel: ${arg:-<leer>}. Nutze: shell-color --unset local oder shell-color --unset ip"
          return 2
          ;;
      esac
      ;;
    --style|style)
      shift
      __shell_color_set_style "${1:-list}"
      ;;
    --path-position|path-position)
      shift
      __shell_color_set_path_position "${1:-}"
      ;;
    --preview-styles|preview-styles|styles)
      idx="$(__shell_color_current_index)"
      __shell_color_preview_styles_by_index "$idx"
      ;;
    --current|current|show)
      __shell_color_current
      ;;
    --list|list|-l|ls)
      __shell_color_list
      ;;
    --aliases|aliases)
      __shell_color_aliases
      ;;
    --pacman-colorize|pacman-colorize)
      __shell_color_pacman_colorize
      ;;
    --apply|apply)
      shell-color-apply
      idx="$(__shell_color_current_index)"
      __shell_color_runtime_msg "$idx" "ok" "shell-color erneut angewendet."
      __shell_color_prompt_preview_by_index "$idx"
      ;;
    --reset-palette|reset-palette|reset)
      shell-color-reset-palette
      ;;
    --version|-V|version)
      printf 'shell-color %s\n' "$SHELL_COLOR_VERSION"
      ;;
    --help|-h|help|"")
      __shell_color_help
      ;;
    *)
      idx="$(__shell_color_resolve "$cmd" 2>/dev/null)" || {
        __shell_color_runtime_err "Unbekannte Farbe: $cmd"
        return 2
      }
      __shell_color_prompt_preview_by_index "$idx"
      ;;
  esac
}

# Beim Shell-Start anwenden: Terminal-Control/PS1, keine sichtbare Textausgabe.
shell-color-apply


# <<< SHELL_COLOR_END v1
