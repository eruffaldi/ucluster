

# Parallel notes

Quick replacement

	alias allpar="parallel --tag --slf my_cluster --onall :::"
	alias allpar0="parallel --tag --slf my_cluster --onall "

Check hostname

	allpar hostname

Check users logged

	allpar who 

Kernel and System version

	allpar "uname -r" "lsb_release -a | grep Release"

Check default gcc

	allpar "gcc --version | grep gcc"

Check all gcc
	
	allpar "dpkg -l | grep 'GNU C compiler'"

Check User Groups

	allpar groups

Check NVidia
	
	allpar nvidia-smi "nvcc --version" "ls -l /usr/local | grep cuda"

Check percentage of GPU free, can be improved

	allpar nvidia-smi

Check percentage of system free

	"top -bn1 | grep 'Cpu(s)' |sed 's/.*, *\([0-9.]*\)%* id.*/\1/'"

Check PIP Libraries

	allpar0 "echo {}; pip show {} | grep Version" ::: tensorflow tensorflow-gpu keras theano scikit-learn imbalanced-learn h5py

Other modules test

	allpar "dpkg -l | grep python-cairo | grep ii"
	
Check Docker

	allpar "dpkg -l | grep docker- | grep ii" "dpkg -l | grep nvidia-docker | grep ii"

Check Tensorflow version
	
	allpar "LD_LIBRARY_PATH=/usr/local/cuda/lib64 python -c 'import tensorflow; print(tensorflow.__version__)'"

Test Tensorflow with CUDA x

	allpar0 --transferfile testtensorflow.py ::: "LD_LIBRARY_PATH=/usr/local/cuda/lib64 python testtensorflow.py"

Check MATLAB 

	allpar "ls /usr/local/MATLAB"