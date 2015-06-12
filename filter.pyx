import numpy as np
cimport numpy as np
DTYPE = np.float32
ctypedef np.float_t DTYPE_t

cdef struct point_t :
   int    r
   int    c

cdef struct square_t:
    point_t s
    point_t e
    int a
    float f

cdef struct eye_t:
    square_t outer
    square_t inner
    int w_half
    int w
    int h


cdef float area(np.ndarray[np.float32_t, ndim=2] img,point_t size,point_t start,point_t end,point_t offset):
  return    img[offset.r + end.r ,offset.c + end.c]\
        + img[offset.r + start.r, offset.c + start.c]\
        - img[offset.r + start.r, offset.c + end.c]\
        - img[offset.r + end.r,offset.c + start.c]

cdef eye_t make_eye(int h):
    cdef int w = 3*h
    cdef eye_t eye
    eye.h = h
    eye.w = w
    eye.outer.s = point_t(0,0)
    eye.outer.e = point_t(w,w)
    eye.inner.s = point_t(h,h)
    eye.inner.e = point_t(h+h,h+h)
    eye.inner.a = h*h
    eye.outer.a = w*w
    eye.outer.f =  1.0/eye.outer.a
    eye.inner.f =  -1.0/eye.inner.a
    eye.w_half = w/2
    return eye

cpdef fil(np.ndarray[np.float32_t, ndim=2] img, int min_w=10,int max_w=100):
    cdef point_t img_size
    img_size.r  = img.shape[0]
    img_size.c = img.shape[1]
    cdef int min_h = min_w/3
    cdef int max_h = max_w/3
    cdef int h, i, j
    cdef float best_response = -10000
    cdef point_t best_pos = point_t(0,0)
    cdef int best_h = 0
    cdef int h_step = 4
    cdef int step = 5
    cdef eye_t eye
    cdef point_t offset
    cdef int x_pos,y_pos,width
    cdef float response = 0
    cdef float a,c,
    cdef point_t b,d,e,f

    for h in xrange(min_h,max_h,h_step):
      eye = make_eye(h)
    #   a = eye.outer.f
    #   c = eye.inner.f
    #   b = eye.outer.s
    #   d = eye.outer.e
    #   e = eye.inner.s
    #   f = eye.inner.e
      for i in xrange(0,img_size.r-eye.w,step):
        for j in xrange(0,img_size.c-eye.w,step):
          offset = point_t(i,j)
          response =eye.outer.f*area(img,img_size,eye.outer.s,eye.outer.e,offset)\
          +eye.inner.f*area(img,img_size,eye.inner.s,eye.inner.e,offset)
          if(response  > best_response):
            best_response = response
            best_pos = point_t(i,j)
            best_h = h


    cdef point_t window_lower = point_t(max(0,best_pos.r-step+1),max(0,best_pos.c-step+1))
    cdef point_t window_upper = point_t(min(img_size.r,best_pos.r+step),min(img_size.c,best_pos.c+step))
    for h in xrange(best_h-h_step+1,best_h+h_step):
            eye = make_eye(h)
            # a = eye.outer.f
            # c = eye.inner.f
            # b = eye.outer.s
            # d = eye.outer.e
            # e = eye.inner.s
            # f = eye.inner.e
            for i in xrange(window_lower.r,min(window_upper.r,img_size.r-eye.w)) :
                for j in xrange(window_lower.c,min(window_upper.c,img_size.c-eye.w)):
                    offset = point_t(i,j)
                    response =eye.outer.f*area(img,img_size,eye.outer.s,eye.outer.e,offset)\
                    +eye.inner.f*area(img,img_size,eye.inner.s,eye.inner.e,offset)
                    if(response > best_response):
                        best_response = response
                        best_pos = point_t(i,j)
                        best_h = h

    x_pos = best_pos.r
    y_pos = best_pos.c
    width = best_h*3
    response = best_response
    return x_pos,y_pos,width,response
