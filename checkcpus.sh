#!/bin/bash
#
#  sudo | su | pbrun | pfexec | doas | dzdo | ksu
# 
#https://en.wikipedia.org/wiki/Comparison_of_open-source_configuration_management_software
hosts=("giacomo" "verebig" "alientelecom" "landolfi" "peppoloni" )
hosts=("aurora")
hosts=("peppoloni")
echo "Password"
stty_orig=`stty -g` # save original terminal setting.
stty -echo          # turn-off echoing.
read passwd         # read the password
stty $stty_orig     # restore terminal setting.

mkdir ~/.ssh/controlmasters

# Using Multiplexing
# https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing
#
# Alternative to this loop:
# exec 3< list.txt
# while read SERVER <&3 ; do
# done
# exec 3>&-
for i in "${hosts[@]}"
do
	CP="-oControlMaster=auto -oControlPersist=10m -S ~/.ssh/controlmasters/%%h-%%r percro@$i -t"
	GO="ssh $CP"
	echo "-Machine:" $i
	echo "GO is:" $GO
	# force close or check existing
	ssh -O exit $CP
	# then make a first connection passing password
	sshpass -p $passwd ssh $CP exit

	# continue
	echo "--Machine/CPU:" $i
	$GO "cat /proc/cpuinfo"
	echo "--Machine/MEM:" $i
	$GO "cat /proc/meminfo"
	echo "--Machine/Kernel:" $i
	$GO  "uname -r"
	echo "--Machine/Distro:" $i
	$GO  "lsb_release -a"
	echo "--Machine/GPU:" $i
	$GO  "nvidia-smi"
	echo "--Machine/pipML:" $i
	$GO "pip show tensorflow-gpu keras theano"
	echo "--Machine/CUDA:" $i
	$GO "ls /usr/local | grep cuda-"
	echo "--Machine/gcc:" $i
	$GO "gcc --version"
	echo "--Machine/nvcc:" $i
	$GO "nvcc --version"
	echo "--Machine/docker:",$i
	$GO "docker --version"
	echo "--Machine/nvidiadocker",$i
	$GO "dpkg -l nvidia-docker | grep amd64"
 	# byte
	ssh -O exit $CP

done