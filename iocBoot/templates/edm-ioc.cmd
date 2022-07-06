#! /bin/bash

# Setup the common directory env variables
if [ -e      /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source   /reg/g/pcds/pyps/config/common_dirs.sh
elif [ -e    /afs/slac/g/pcds/pyps/config/common_dirs.sh ]; then
	source   /afs/slac/g/pcds/pyps/config/common_dirs.sh
fi

# Setup edm environment
source /reg/g/pcds/pyps/conda/py36env.sh

pushd $$IOCTOP/hpm900Screens

$$LOOP(HPM900)
$$IF(ONEPANEL)
pydm -m "DEV=$$BASE,IOC=$$IOC_PV" gasCabinet_onepanel.ui &
$$ELSE(ONEPANEL)
pydm -m "DEV=$$BASE,IOC=$$IOC_PV" gasCabinet.ui &
$$ENDIF(ONEPANEL)
$$ENDLOOP(HPM900)
