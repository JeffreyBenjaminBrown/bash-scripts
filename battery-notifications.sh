# PURPOSE
# This makes audible and visible announcements
# when the power cable should be connected or disconnected.

# USAGE
# Provide two numerical arguments from (say) 20 to 80,
# the first lower than the second.
# These are the percentages you would like the battery
# to remain between.
# If any third argument is passed,
# the quiet version of the file is used.

if [[ $# -gt 2 ]]; then
    suffix="-quiet"
else
    suffix=""
fi

while true; do
  acpi_message=`acpi`
  battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`

  if [ $battery_level -le $1          ] && \
     [[ $acpi_message = *'Discharging'* ]]; then
    notify-send --urgency=CRITICAL \
                  "Battery Low (${battery_level}%) and discharging"
    aplay -q ~/Audio/battery-low$suffix.wav
    echo    "~/Audio/battery-low$suffix.wav"
    sleep 180 # to prevent redundant notifications

  elif [ $battery_level -ge $2          ] && \
       [[ $acpi_message = *' Charging'* ]]; then
    notify-send --urgency=CRITICAL \
                  "Battery High (${battery_level}%) and charging"
    aplay -q ~/Audio/battery-high$suffix.wav
    echo    "~/Audio/battery-high$suffix.wav"
    sleep 180 # to prevent redundant notifications
  fi

  sleep 60
done
