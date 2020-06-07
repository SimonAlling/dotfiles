readonly PRIMARY="DP-2"
readonly PRIMARY_WIDTH=2560
readonly PRIMARY_HEIGHT=1440

readonly SECONDARY_WIDTH=2560
readonly SECONDARY_HEIGHT=1440
readonly SECONDARY="DP-0"

readonly REFRESH_RATE=144

let primary_y=(${SECONDARY_WIDTH}-$PRIMARY_HEIGHT)/2

primary_mode="${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}_${REFRESH_RATE} @${PRIMARY_WIDTH}x${PRIMARY_HEIGHT} +0+${primary_y} {ViewPortIn=${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}, ViewPortOut=${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}+0+0}"

secondary_mode="${SECONDARY_WIDTH}x${SECONDARY_HEIGHT}_${REFRESH_RATE} @${SECONDARY_HEIGHT}x${SECONDARY_WIDTH} +${PRIMARY_WIDTH}+0 {ViewPortIn=${SECONDARY_HEIGHT}x${SECONDARY_WIDTH}, ViewPortOut=${SECONDARY_WIDTH}x${SECONDARY_HEIGHT}+0+0, Rotation=90}"

nvidia-settings --assign "CurrentMetaMode=${PRIMARY}: ${primary_mode}, ${SECONDARY}: ${secondary_mode}"
xrandr --output "${PRIMARY}" --primary
