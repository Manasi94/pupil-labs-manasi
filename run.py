import numpy as np
from find_curve import GetAnglesPolyline
from timeit import Timer
pl = np.array([[[0, 1]],[[0, 1]],[[1, 1]],[[2, 1]],[[2, 2]],[[1, 3]],[[1, 4]],[[2,4]]], dtype=np.int32)
curvature = GetAnglesPolyline(pl,closed=0)
print curvature
t = Timer(lambda:GetAnglesPolyline(pl,closed=0))
print "Time required for getanglespoly"
print t.timeit(number=10)
