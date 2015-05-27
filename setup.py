from distutils.core import setup
from Cython.Build import cythonize

setup(
	ext_modules = cythonize("dist_pts_ellipse.pyx"),

)
