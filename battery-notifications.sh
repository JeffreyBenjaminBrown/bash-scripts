while true
do
  battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
   if [ $battery_level -ge 80 ]; then
      notify-send --urgency=CRITICAL "Battery Full" "Level: ${battery_level}%"
      paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
    elif [ $battery_level -le 75 ]; then
      notify-send --urgency=CRITICAL "Battery Low" "Level: ${battery_level}%"
      paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
      sleep 300 # to prevent redundant notifications
  fi
 sleep 60
done
