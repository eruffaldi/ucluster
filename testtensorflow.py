import sys,os
if len(sys.argv) > 1:
	os.environ["LD_LIBRARY_PATH"] = os.environ.get("LD_LIBRARY_PATH","") + ":" + os.path.join(sys.argv[1],"/lib64")
	os.environ["CUDA_HOME"] = sys.argv[1]
import tensorflow as tf
hello = tf.constant('Hello, TensorFlow!')
sess = tf.Session()
print(sess.run(hello))
a = tf.constant(10)
b = tf.constant(32)
print(sess.run(a + b))
