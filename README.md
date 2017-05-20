

# Parallel notes

Check hostname

	parallel --slf my_cluster --onall ::: hostname

Quick replacement

	alias allpar="parallel --tag --slf my_cluster --onall :::"
	alias allpar0="parallel --tag --slf my_cluster --onall "

Then

	allpar hostname

Check percentage of system free

	"top -bn1 | grep 'Cpu(s)' |sed 's/.*, *\([0-9.]*\)%* id.*/\1/'"


Check NVidia
	
	allpar nvidia-smi "nvcc --version" "ls -l /usr/local | grep cuda"

Check percentage of GPU free, can be improved

	allpar nvidia-smi

Check PIP Libraries

	allpar0 "echo {}; pip show {} | grep Version" ::: tensorflow tensorflow-gpu keras theano

Check User Groups

	allpar groups

Kernel and System version

	allpar "uname -r" "lsb_release -a | grep Release"

Check Docker

	allpar "dpkg -l | grep docker- | grep ii" "dpkg -l | grep nvidia-docker | grep ii"

Check Tensorflow version
	
	allpar "LD_LIBRARY_PATH=/usr/local/cuda/lib64 python -c 'import tensorflow; print(tensorflow.__version__)'"

Test Tensorflow with CUDA x

	allpar0 --transferfile testtensorflow.py ::: "LD_LIBRARY_PATH=/usr/local/cuda/lib64 python testtensorflow.py"
