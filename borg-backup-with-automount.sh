mountPoint=/run/media/jeff/ssd_500g_samsung/

echo I started running \"borg create\" at:
echo $(date)

sudo mkdir $mountPoint
sudo mount /dev/sdb /run/media/jeff/ssd_500g_samsung/

cd /run/media/jeff/ssd_500g_samsung/borg-repo
borg create $(pwd)::$(date +%Y-%m-%d).hp17 /home/jeff \
  --exclude-from /home/jeff/bin/exclude-for-borg.txt

sudo umount $mountPoint
sudo rmdir $mountPoint
