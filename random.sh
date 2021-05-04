# Takes a numerical argument: the number of characters you want.

# What is this?
#!/run/current-system/sw/bin/bash

head /dev/urandom | tr -dc A-Za-z0-9 | head -c $1 ; echo ''
