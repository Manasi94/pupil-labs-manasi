# How to download Cython on Linux:

Cython requires C compiler
1. Install the dependencies:
   sudo apt-get install build-essential
2. Download the newest Cython release from http://cython.org. Unpack the tarball or zip file, enter the directory, and then run:
python setup.py install
3. If python setup tools are already resent on your system , try : pip install cython

## How to work with cython:

1. Write your cython code and save that file as .pyx
2. Create another file named setup.py
3. The contents of the setup.py folder are as shown in the file
4. Once you have created the folders, go to your terminal
5. cd to the location you have saved setup.py file
6. Type the following command: ```python setup.py build_ext --inplace```
7. If there are no errors , means it is succesfully built
8. Start a python session and type: from file_name import function_name
9. Now you can use it in your code.



###Errors I faced:
1. While converting a code from python to cython remember to change function from *def* to *cpdef*
2. My complier kept crashing near the function definition. Solution was to change the argument name as the argument name was used in the function later and was undeclared earlier.

###Further notes about Cython
1. Function Definition: There are two kinds of function definition in Cython. Python functions are defined using the def statement, as in Python. They take Python objects as parameters and return Python objects.
C functions are defined using the new cdef statement. They take either Python objects or C values as parameters, and can return either Python objects or C values.
Within a Cython module, Python functions and C functions can call each other freely, but only Python functions can be called from outside the module by interpreted Python code. So, any functions that you want to “export” from your Cython module must be declared as Python functions using def. There is also a hybrid function, called cpdef. A cpdef can be called from anywhere, but uses the faster C calling conventions when being called from other Cython code.
2. If no type is specified for a parameter or return value, it is assumed to be a Python object. (Note that this is different from the C convention, where it would default to int.).The name object can also be used to explicitly declare something as a Python object.

####Cython errors and how to fix them
1. Define all the variables before using them using cdef.(if type know their type)
2. While giving a type to an array using numpy use : numpy.type_t : example: numpy.float32_t
####How to run the dist_pts_ellpise.pyx
1. Build the dist_pts_ellipse file by typing the following in the terminal ```python setup.py build_ext --inplace```
2. Open a python session and type the following code:

```python
import numpy as np
from dist_pts_ellipse import dist_pts_ellipse
ellipse = ((0,0),(20,10),0)
pts = (np.random.rand(200,2))*10
from timeit import Timer
t = Timer(lambda: dist_pts_ellipse(ellipse,pts))
print "Time required for numpy"
print t.timeit(number=5)
```


####Errors while writing dist_pts_ellipse
1. I had given the data type of the returned value of the function in the function definition itself. That throwed an error
2.  The dot product of pts and M_rot was modified since initially it showed error. Changed the syntax to this : ```python pts = pts.dot(M_rot) ```


####How to convert cython file to .html
1. Go to the command line and type the following instructions:
```terminal
sudo cython -a square_marker_detect.pyx
xdg-open square_marker_detect.html
```
