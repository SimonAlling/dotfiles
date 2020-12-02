readonly PRIMARY="DP-2"
readonly PRIMARY_WIDTH=2560
readonly PRIMARY_HEIGHT=1440

readonly SECONDARY_WIDTH=2560
readonly SECONDARY_HEIGHT=1440
readonly SECONDARY="DP-0"

readonly REFRESH_RATE=144

let secondary_y=(${PRIMARY_HEIGHT}-$SECONDARY_HEIGHT)/2

primary_mode="${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}_${REFRESH_RATE} @${PRIMARY_WIDTH}x${PRIMARY_HEIGHT} +0+0 {ViewPortIn=${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}, ViewPortOut=${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}+0+0}"

secondary_mode="${SECONDARY_WIDTH}x${SECONDARY_HEIGHT}_${REFRESH_RATE} @${SECONDARY_WIDTH}x${SECONDARY_HEIGHT} +${PRIMARY_WIDTH}+${secondary_y} {ViewPortIn=${SECONDARY_WIDTH}x${SECONDARY_HEIGHT}, ViewPortOut=${SECONDARY_WIDTH}x${SECONDARY_HEIGHT}+0+0}"

nvidia-settings --assign "CurrentMetaMode=${PRIMARY}: ${primary_mode}, ${SECONDARY}: ${secondary_mode}"
xrandr --output "${PRIMARY}" --primary
