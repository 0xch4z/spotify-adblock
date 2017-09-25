#!/bin/bash

CONFIG="/private/etc/hosts"
START_STMT="# start spotify-adblock"
END_STMT="# end spotify-adblock"

# check for root priv
if [ "$EUID" -ne 0 ]
then
  printf "[!] \`block.sh\` requires root privileges!\nPlease run as superuser."
  sleep 2
  exit
fi

# grep/remove old configs
start_ln=$(grep -n "$START_STMT" "$CONFIG" | grep -Eo '^[^:]+')
if [ "$start_ln" ]
then
  echo "[-] removing old spotify-adblock..."
  end_ln=$(grep -n "$END_STMT" "$CONFIG" | grep -Eo '^[^:]+')
  sed -i.bak -e "${start_ln},${end_ln}d" "$CONFIG"
fi

# pipe config
cat >> $CONFIG << EOF
# start spotify-adblock
0.0.0.0 pagead2.googlesyndication.com 
0.0.0.0 partner.googleservices.com
0.0.0.0 pubads.g.doubleclick.net
0.0.0.0 redirect.gvt1.com
0.0.0.0 s0.2mdn.net
0.0.0.0 securepubads.g.doubleclick.net
0.0.0.0 spclient.wg.spotify.com
0.0.0.0 tpc.googlesyndication.com
0.0.0.0 v.jwpcdn.com
0.0.0.0 video-ad-stats.googlesyndication.com
0.0.0.0 weblb-wg.gslb.spotify.com
0.0.0.0 www.googleservices.com
0.0.0.0 www.googletagservices.com
0.0.0.0 www.omaze.com
# end spotify-adblock
EOF

echo "done."
exit
