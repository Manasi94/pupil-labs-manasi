import numpy as np
cimport numpy as np
#from sklearn.utils.extmath import fast_dot

DTYPE = np.float64
ctypedef np.float_t DTYPE_t
@cython.boundscheck(False)
@cython.wraparound(False)
cpdef dist_pts_ellipse(object ellipse, np.ndarray pts):
    """
    return unsigned euclidian distances of points to ellipse
    """
    center, size, pyangle =ellipse
    ex, ey=center
    dx, dy=size
    #assert points.dtype == DTYPE
    cdef float rx= dx/2.0
    cdef float ry= dy/2.0
    cdef float angle = (pyangle/180.)*np.pi
    cdef np.ndarray norm_mag, norm_dist,ratio,scaled_error,real_error,error_mag
    pts = pts - np.array((ex,ey)) # move pts to ellipse appears at origin , with this we copy data -deliberatly!
    #M_rot = np.mat([[np.cos(angle),-np.sin(angle)],[np.sin(angle),np.cos(angle)]])
    #pts = np.array(pts*M_rot) #rotate so that ellipse axis align with coordinate system
    # print "rotated",pts

    pts /= np.array((rx,ry)) #normalize such that ellipse radii=1
    # print "normalize",norm_pts
    norm_mag = np.sqrt((pts*pts).sum(axis=1))
    norm_dist = abs(norm_mag-1) #distance of pt to ellipse in scaled space
    # print 'norm_mag',norm_mag
    #print 'norm_dist',norm_dist
    ratio = (norm_dist)/norm_mag #scale factor to make the pts represent their dist to ellipse
    # print 'ratio',ratio
    scaled_error = np.transpose(pts.T*ratio) # per vector scalar multiplication: makeing sure that boradcasting is done right
    # print "scaled error points", scaled_error
    real_error = scaled_error*np.array((rx,ry))
    # print "real point",real_error
    error_mag = np.sqrt((real_error*real_error).sum(axis=1))
    # print 'real_error',error_mag
    #print 'result:',error_mag
    return error_mag
