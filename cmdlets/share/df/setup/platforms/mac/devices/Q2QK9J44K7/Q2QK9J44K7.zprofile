# Zscaler gets in the way of loads of things. Kill it at startup on work mac.
 ps aux | grep -i zscaler | awk '{print $2}' | xargs sudo kill -9
