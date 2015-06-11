from numpy.ctypeslib import ndpointer
from filter import fil


#def eye_filter(integral,min_w=10,max_w=100):
#    rows, cols = integral.shape[0],integral.shape[1]
#    min_w,max_w = int(min_w),int(max_w)
#    filter(integral)

### Debugging
if __name__ == '__main__':
    import numpy as np
    import cv2
    from timeit import Timer


    img = np.ones((1000,1000),dtype= np.uint8)
    # img = np.random.rand((100))
    # img = img.reshape(10,-1)
    # img *=20;
    # img = np.array(img,dtype = c_uint8)
    # img +=20
    img[50:80,100:130] = 0
    # print img
    integral = cv2.integral(img)
    integral =  np.array(integral,dtype=np.float32)
    #print integral.size
    print fil(integral)
    t = Timer(lambda: fil(integral))
    print "Time required for cython"
    print t.timeit(number=5)
