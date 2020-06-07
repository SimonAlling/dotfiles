readonly PRIMARY="DP-2"
readonly PRIMARY_WIDTH=2560
readonly PRIMARY_HEIGHT=1440

readonly REFRESH_RATE=144

let primary_y=0

primary_mode="${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}_${REFRESH_RATE} @${PRIMARY_WIDTH}x${PRIMARY_HEIGHT} +0+${primary_y} {ViewPortIn=${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}, ViewPortOut=${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}+0+0}"

nvidia-settings --assign "CurrentMetaMode=${PRIMARY}: ${primary_mode}"
xrandr --output "${PRIMARY}" --primary
