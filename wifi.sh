#!/run/current-system/sw/bin/bash

# WiFi connection script
# Usage: wifi [jeff|mincit]

case "$1" in
    "jeff")
        nmcli connection up "Jeff's Galaxy"
        echo ""
        echo "WARNING: this network:"
        echo "  can't do cargo (rust)"
        ;;
    "mincit")
        nmcli connection up WIFI_MOVILES_MINCIT
        echo ""
        echo "WARNING: this network:"
        echo "  can't do cargo (rust)"
        echo "  can't do apt (ubuntu, debian)"
        echo "BUT it can:"
        echo "  ssh to github,"
        ;;
    *)
        echo "Usage: wifi.sh [jeff|mincit]"
        echo "  jeff   - Connect to Jeff's Galaxy"
        echo "  mincit - Connect to WIFI_MOVILES_MINCIT"
        exit 1
        ;;
esac
