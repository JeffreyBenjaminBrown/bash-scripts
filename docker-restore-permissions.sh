#!/bin/bash

sudo chown jeff -R .
sudo chgrp users -R .
chmod 744 -R .
find . -type f -print0 | xargs -0 chmod 644
