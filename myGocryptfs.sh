# The same command that would create the encrypted folder
# also mounts it if it already exists.

# Unmount with this:
# fusermount -u ~/ugh/une

gocryptfs /home/jeff/ugh/enc /home/jeff/ugh/une
