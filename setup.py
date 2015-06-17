from distutils.core import setup
from Cython.Build import cythonize
import numpy

setup(
	ext_modules = cythonize("square_marker_detect.pyx"),
    include_dirs = [numpy.get_include()]

)
