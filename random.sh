# Takes a numerical argument: the number of characters you want.

# PITFALL: This used to give capital letters too.
# I think it's easier to remember the password without those.
# To include them, insert A-Z after the a-z (sans whitespace).

# What is this?
#!/run/current-system/sw/bin/bash

head /dev/urandom | tr -dc a-z0-9 | head -c $1 ; echo ''
