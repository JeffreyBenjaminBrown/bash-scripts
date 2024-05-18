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
  # TODO : To prevent the buildup of redundant messages,
  # this expires each message after 180 seconds
  # (specified in miliseconds).
  # If the condition that triggered the message persists,
  # then another message will appear in 180 seconds,
  # because 120 + 60 = 180.
  # It would be better if that math were done in the program,
  # and the wait times 60 and 120 were defined once,
  # rather than appearing in multiple places.
  acpi_message=`acpi`
  battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`

  if [ $battery_level -le $1          ] && \
     [[ $acpi_message = *'Discharging'* ]]; then
        notify-send          \
          -t 180000          \
          "Battery Low (${battery_level}%) and discharging"
        aplay -q ~/Audio/battery-low$suffix.wav
        sleep 120 # to prevent redundant notifications

  elif [ $battery_level -ge $2          ] && \
       [[ $acpi_message = *' Charging'* ]]; then
        notify-send          \
          -t 180000          \
          "Battery High (${battery_level}%) and charging"
        aplay -q ~/Audio/battery-high$suffix.wav
        sleep 120 # to prevent redundant notifications
  fi

  sleep 60
done
