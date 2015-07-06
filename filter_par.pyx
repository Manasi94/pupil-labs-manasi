cimport cython
from cython.parallel cimport *

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


cdef inline int int_max(int a, int b) nogil: return a if a >= b else b
cdef inline int int_min(int a, int b) nogil: return a if a <= b else b

@cython.boundscheck(False)
@cython.wraparound(False)
cdef inline float area(int[:,::1] img,point_t size,point_t start,point_t end,point_t offset) nogil:
  return    img[offset.r + end.r ,offset.c + end.c]\
        + img[offset.r + start.r, offset.c + start.c]\
        - img[offset.r + start.r, offset.c + end.c]\
        - img[offset.r + end.r,offset.c + start.c]

@cython.cdivision(True)
cdef inline eye_t make_eye(int h) nogil:
    cdef int w = 3*h
    cdef eye_t eye
    eye.h = h
    eye.w = w
    eye.outer.s.r = 0
    eye.outer.s.c = 0
    eye.outer.e.r = w
    eye.outer.e.c = w
    eye.inner.s.r = h
    eye.inner.s.c = h
    eye.inner.e.r = h+h
    eye.inner.e.c = h+h
    eye.inner.a = h*h
    eye.outer.a = w*w
    eye.outer.f =  eye.outer.a
    eye.inner.f =  eye.inner.a
    eye.w_half = w/2
    return eye

@cython.boundscheck(False)
@cython.wraparound(False)
def fil(int[:,::1] img, int min_w=10,int max_w=100):
    cdef point_t img_size
    img_size.r = <int> img.shape[0]
    img_size.c = <int> img.shape[1]
    cdef int min_h = min_w/3
    cdef int max_h = max_w/3
    cdef int h=0, i=0, j=0
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



    #for h in prange(min_h,max_h,h_step):
    for h from min_h <= h < max_h by step:
      eye = make_eye(h)

      #for i in range(0,img_size.r-eye.w,step): #step is slow
      for i from 0 <= i < img_size.r-eye.w by step:
        #for j in range(0,img_size.c-eye.w,step): #step is slow
        for j from 0 <= j < img_size.c-eye.w by step:

          offset = point_t(i,j)
          response = eye.outer.f*area(img,img_size,eye.outer.s,eye.outer.e,offset)\
          +eye.inner.f*area(img,img_size,eye.inner.s,eye.inner.e,offset)
          if(response  > best_response):
            best_response = response
            best_pos = point_t(i,j)
            best_h = h


    cdef point_t window_lower = point_t(int_max(0,best_pos.r-step+1),int_max(0,best_pos.c-step+1))
    cdef point_t window_upper = point_t(int_min(img_size.r,best_pos.r+step),int_min(img_size.c,best_pos.c+step))
    for h from best_h-h_step+1 <= h < best_h+h_step by 1:
    #for h in range(best_h-h_step+1,best_h+h_step):
            eye = make_eye(h)

            for i from window_lower.r <= i < int_min(window_upper.r,img_size.r-eye.w) by 1:
            #for i in range(window_lower.r,int_min(window_upper.r,img_size.r-eye.w)) :
                for j from window_lower.c <= j < int_min(window_upper.c,img_size.c-eye.w) by 1:
                #for j in range(window_lower.c,int_min(window_upper.c,img_size.c-eye.w)):
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
    return  x_pos,y_pos,width,best_response
