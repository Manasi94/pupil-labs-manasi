from numpy.ctypeslib import ndpointer
from filter_par import fil


#def eye_filter(integral,min_w=10,max_w=100):
#    rows, cols = integral.shape[0],integral.shape[1]
#    min_w,max_w = int(min_w),int(max_w)
#    filter(integral)

### Debugging
if __name__ == '__main__':
    import numpy as np
    import cv2
    from timeit import Timer

    from c_methods import eye_filter

    img = np.ones((640,480),dtype= np.uint8)
    img = np.random.rand(img.shape[0]*img.shape[1]).reshape(img.shape)
    img *=20
    img = np.array(img,dtype = np.uint8)
    # img +=20
    img[50:52,100:102] = 0
    # print img
    integral = cv2.integral(img)
    # integrabbl =  np.array(integral,dtype=np.float32)
    #print integral.size
    print fil(integral)


    t = Timer(lambda: cv2.integral(img))
    print "Time required for integral"
    print t.timeit(number=1000)

    t = Timer(lambda: fil(integral))
    print "Time required for cython"
    print t.timeit(number=1000)

    # int 0.355319976807
    print eye_filter(np.float32(integral))
    t = Timer(lambda: eye_filter(np.float32(integral)))
    print "Time required for ctypes"
    print t.timeit(number=1000)
