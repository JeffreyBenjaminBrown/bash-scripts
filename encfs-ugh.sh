# The same command that would create the encrypted folder
# also mounts it if it already exists.

# Unmount with this:
# fusermount -u ~/ugh/une

encfs /home/jeff/ugh/enc /home/jeff/ugh/une
