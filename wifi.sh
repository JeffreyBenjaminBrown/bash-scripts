#!/run/current-system/sw/bin/bash

# WiFi connection script
# Usage: wifi.sh [jeff|mincit]

case "$1" in
    "jeff")
        nmcli connection up "Jeff's Galaxy"
        echo ""
        echo "cannot do cargo (rust)"
        ;;
    "moviles")
        nmcli connection up WIFI_MOVILES_MINCIT
        echo ""
        echo "can ssh to github"
        echo "can fetch nix packages"
        echo "cannot do cargo (rust)"
        echo "cannot do apt (ubuntu, debian)"
        ;;
    "invitados")
        nmcli connection up "MCIT-INVITADOS"
        echo ""
        echo "can do apt"
        echo "can do cargo (as of <2025-04-29>; earlier it couldn't)"
        echo "cannot do Git"
        ;;
    *)
        echo "Usage: wifi.sh [jeff|mincit|invitados]"
        echo "  jeff      - Connect to Jeff's Galaxy"
        echo "  mincit    - Connect to WIFI_MOVILES_MINCIT"
        echo "  invitados - Connect to MCIT-INVITADOS"
        exit 1
        ;;
esac
