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
6. Type the following command: ```python python setup.py build_ext --inplace```
7. If there are no errors , means it is succesfully built
8. Start a python session and type: from file_name import function_name
9. Now you can use it in your code.



###Errors I faced:
1. While converting a code from python to cython remember to change functio from *def* to *cpdef*
2. My complier kept craching near the function definition. Solution was to change the argumant name as the argument name was used in the function later and was undeclared earlier.

