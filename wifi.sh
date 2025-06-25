#!/run/current-system/sw/bin/bash

# WiFi connection script
# Usage: wifi [jeff|mincit]

case "$1" in
    "jeff")
        nmcli connection up "Jeff's Galaxy"
        echo "can't do cargo (rust)"
        ;;
    "mincit")
        nmcli connection up WIFI_MOVILES_MINCIT
        echo "can ssh to github,"
        echo "can't do cargo (rust)"
        echo "can't do apt (ubuntu, debian)"
        ;;
    *)
        echo "Usage: wifi.sh [jeff|mincit]"
        echo "  jeff   - Connect to Jeff's Galaxy"
        echo "  mincit - Connect to WIFI_MOVILES_MINCIT"
        exit 1
        ;;
esac
