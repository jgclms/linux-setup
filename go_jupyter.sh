#!/usr/bin/bash -i
for adapter in $(sed -n -e 's/^\(e[^:]*\): .*$/\1/p' /proc/net/dev); do
    ipv4=$(ip addr show $adapter | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
    echo "adapter=$adapter ($ipv4)"
    # extract ipv4 frm https://askubuntu.com/a/560466/806934
done

# eval $(conda shell.bash hook)
conda activate python3.7
NOTEBOOK_DIR=~/jupyter/notebooks
mkdir -p $NOTEBOOK_DIR
cd $NOTEBOOK_DIR
echo "to see jupyter try: http://$ipv4:8888/   (NOTEBOOK_DIR=$NOTEBOOK_DIR)"
jupyter notebook --no-browser --ip=0.0.0.0 --port=8888
