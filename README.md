

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

Check only hardware (replace python with awk)

	allpar "nvidia-smi -L  | python -c \"import sys; print sys.stdin.readline().split('(')[0]\""
	
Example:

	percro@pelars	GPU 0: Tesla K20m (UUID: GPU-84f5c163-ab4d-e52c-485f-298f9925313f)
	percro@verebig	GPU 0: GeForce GTX 1080 (UUID: GPU-a7ea12b2-b450-2073-f8ed-cb36fbfc82e4)
	percro@landolfi	GPU 0: GeForce GTX 770 (UUID: GPU-37da2463-dfd7-f642-5773-84db45ac1e2b)
	percro@aurora	GPU 0: GeForce GTX 1080 (UUID: GPU-1b1c49ef-c38e-42fc-9fb3-7e070834dca1)
	percro@peppoloni	GPU 0: GeForce GTX 760 Ti OEM (UUID: GPU-8ee6f382-6b6d-d483-f726-fca985e18bb3)
	percro@bigdaddy	ssh: connect to host bigdaddy port 22: Network is unreachable


Check percentage of GPU free, can be improved

	allpar nvidia-smi

Check percentage of system free

	"top -bn1 | grep 'Cpu(s)' |sed 's/.*, *\([0-9.]*\)%* id.*/\1/'"

Check PIP Libraries

	allpar0 "echo {}; pip show {} | grep Version" ::: tensorflow tensorflow-gpu keras theano scikit-learn imbalanced-learn h5py coloredlogs

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

Check Postgres

	allpar "dpkg -l | grep postgres | grep ii"

Check Keras Default

	allpar "python -c 'from keras import backend'"

Work with sudo using explicit password

	parallel --slf my_cluster --tty --onall ::: "echo PASSWORD | sudo -S pip install --upgrade pip"

# Running our Leave 1 out

Maybe better manual sync due to the many syncs


Initial version
	
	allpar "mkdir ~/work" "mkdir ~/work/fatigue" 

	time parallel --workdir ./work/fatigue --transferfile . --line-buffer --tag --jobs 1 -S percro@verebig "LD_LIBRARY_PATH=/usr/local/cuda/lib64 BACKEND=tensorflow python leaveoneouttestpar.py -s 20 -w 90 -d jsondata --user {}" ::: $(seq -s ' ' 1 20)

Issues:
* parallel has to be issued FROM one of the cluster machine to avoid closing the client (e.g. laptop)
* final results have to be gathered (all output is not needed due to the printing of status along time)
* high-level progress monitoring
* colored output


# Alternatives

Written in other languages but same phylosophy

https://github.com/flesler/parallel
https://github.com/mmstick/parallel

# Checking CUDA

With CUDA example

	/usr/local/cuda-7.5/samples/bin/x86_64/linux/release/deviceQuery
		CUDA driver version is insufficient for CUDA runtime version

With pycuda

	pip install pycuda
	python -c "import pycuda.driver as cuda; import pycuda.autoinit"
	
# Custom Tensorflow

See Also: 	https://alliseesolutions.wordpress.com/2016/09/08/install-gpu-tensorflow-from-sources-w-ubuntu-16-04-and-cuda-8-0/


	git clone --depth 1 https://github.com/tensorflow/tensorflow  -b r1.2
	cd tensorflow
	sudo apt-get install python-numpy python-dev python-pip python-wheel
	sudo apt-get install libcupti-dev 

	NOTE on gcc 5 or later: the binary pip packages available on the TensorFlow website are built with gcc 4, which uses the older ABI. To make your build compatible with the older ABI, you need to add -cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" to your bazel build command. ABI compatibility allows custom ops built against the TensorFlow pip package to continue to work against your built package.


	export LD_LIBRARY_PATH=/usr/local/cuda-8.0/extra/CUPTI/lib64/
	bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package


