#!/bin/bash

#sed -n 's,\(!DIRBIN*DIRBIN=\)\(.*\),sarasa,p' Instalep.conf #| cut -d'=' -f2

#sed -n 's,^.*'$1',,p' dirconf/Instalep.conf | cut -d '=' -f 2
grep DIRBIN Instalep.conf | cut -d '=' -f 2


#cut -d'=' -f1,2 Instalep.conf

#sed -n s,^.*GRUPO,,p Instalep.conf | cut -d'=' -f2




#sed -n 's,^.*DIRBIN,,p' Instalep.conf | cut -d'=' -f2


#sed -n 's;\(.*//[^/]*\)/.*;\1;p' Instalep.conf