from numpy.ctypeslib import ndpointer


def eye_filter(integral,min_w=10,max_w=100):
    rows, cols = integral.shape[0],integral.shape[1]
    cdef int x, y, w
    cdef float response
    min_w,max_w = int(min_w),int(max_w)

    return x.value,y.value,w.value,response.value

### Debugging
if __name__ == '__main__':
    import numpy as np
    import cv2
    img = np.ones((1000,1000),dtype= uint8)
    # img = np.random.rand((100))
    # img = img.reshape(10,-1)
    # img *=20;
    # img = np.array(img,dtype = c_uint8)
    # img +=20
    img[50:80,100:130] = 0
    # print img
    integral = cv2.integral(img)
    integral =  np.array(integral,dtype=np.float32)
    print eye_filter(integral)
