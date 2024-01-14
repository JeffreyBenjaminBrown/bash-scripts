# PURPOSE
# This makes audible and visible announcements
# when the power cable should be connected or disconnected.

# USAGE
# Provide two numerical arguments from (say) 20 to 80,
# the first lower than the second.
# These are the percentages you would like the battery
# to remain between.

while true; do
  acpi_message=`acpi`
  battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`

  if [ $battery_level -le $1          ] && \
     [[ $acpi_message = *'Discharging'* ]]; then
    notify-send --urgency=CRITICAL \
                  "Battery Low" "Level: ${battery_level}%"
    aplay ~/Audio/battery-low.wav
    sleep 300 # to prevent redundant notifications

  elif [ $battery_level -ge $2          ] && \
       [[ $acpi_message = *' Charging'* ]]; then
    notify-send --urgency=CRITICAL \
                  "Battery High" "Level: ${battery_level}%"
    aplay ~/Audio/battery-high.wav
    sleep 300 # to prevent redundant notifications
  fi

  sleep 60
done
