import numpy as np
cimport numpy as np
cpdef GetAnglesPolyline(polyline,closed=False):
    
    points = polyline[:,0]
    if closed:
        a = np.roll(points,1,axis=0)
        b = points
        c = np.roll(points,-1,axis=0)
    else:
        a = points[0:-2] # all "a" points
        b = points[1:-1] # b
        c = points[2:]  # c points
    # ab =  b.x - a.x, b.y - a.y
    ab = b-a
    # cb =  b.x - c.x, b.y - c.y
    cb = b-c
    # float dot = (ab.x * cb.x + ab.y * cb.y); # dot product
    # print 'ab:',ab
    # print 'cb:',cb

    # float dot = (ab.x * cb.x + ab.y * cb.y) dot product
    # dot  = np.dot(ab,cb.T) # this is a full matrix mulitplication we only need the diagonal \
    # dot = dot.diagonal() #  because all we look for are the dotproducts of corresponding vectors (ab[n] and cb[n])
    dot = np.sum(ab * cb, axis=1) # or just do the dot product of the correspoing vectors in the first place!

    # float cross = (ab.x * cb.y - ab.y * cb.x) cross product
    cros = np.cross(ab,cb)

    # float alpha = atan2(cross, dot);
    alpha = np.arctan2(cros,dot)
    return alpha*(180./np.pi) #degrees
    # return alpha #radians
