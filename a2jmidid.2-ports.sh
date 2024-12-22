# details at "a2jmidid and aconnect",
# ~/org-roam/tech/a2jmidid_and_aconnect.org

  sudo modprobe -r snd-seq-dummy && \
    sleep 1                      && \
    sudo modprobe  snd-seq-dummy ports=2
