import numpy as np
from dist_pts_ellipse import dist_pts_ellipse
ellipse = ((0,0),(20,10),0)
pts = (np.random.rand(200,2))*10
from timeit import Timer
t = Timer(lambda: dist_pts_ellipse(ellipse,pts))
print "Time required for cython"
print t.timeit(number=5)
