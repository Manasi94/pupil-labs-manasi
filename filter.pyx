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


cdef float area(const float *img,point_t size,point_t start,point_t end,point_t offset):
    #// use like in numpy including start excluding end
    #// 0-based indecies
    #// this is because the integral image has w+1 and h+1
    return    (img[(offset.r + end.r  ) * size.c + offset.c + end.c]+ img[(offset.r + start.r) * size.c + offset.c + start.c]- img[(offset.r + start.r) * size.c + offset.c + end.c]- img[(offset.r + end.r  ) * size.c + offset.c + start.c])

cdef eye_t make_eye(int h):
    cdef int w = 3*h
    cdef eye_t eye
    eye.h = h
    eye.w = w
    eye.outer.s = {0,0}
    eye.outer.e = {w,w}
    eye.inner.s = {h,h}
    eye.inner.e = {h+h,h+h}
    eye.inner.a = h*h
    eye.outer.a = w*w
    eye.outer.f =  1.0/eye.outer.a
    eye.inner.f =  -1.0/eye.inner.a
    eye.w_half = w/2
    return eye

cdef filter(const float *img, const int rows, const int cols, int * x_pos,int *y_pos,int *width, int min_w,int max_w,float *response):
# Algorithm based on:
# Robust real-time pupil tracking in highly off-axis images
# Lech Świrski Andreas Bulling Neil A. Dodgson
# Computer Laboratory, University of Cambridge, United Kingdom
# Eye Tracking Research & Applications 2012

    cdef point_t img_size = {rows,cols}
    cdef int min_h = min_w/3
    cdef int max_h = max_w/3
    cdef int h, i, j
    cdef float best_response = -10000
    cdef point_t best_pos = {0,0}
    cdef int best_h = 0
    cdef int h_step = 4
    cdef int step = 5
    cdef eye_t eye
    cdef point_t offset
    cdef float b
    cdef float a
    cdef float c
    cdef float d

    for h in range(min_h,max_h,h_step):
      eye = make_eye(h)
      for i in range(0,rows-eye.w,step):
        for j in range(0,cols-eye.w,step):
          #// printf("|%2.0f",img[i * cols + j]);
          offset = {i,j}
          b = area(img,img_size,eye.outer.s,eye.outer.e,offset)
          a = eye.outer.f
          c = eye.inner.f
          d = area(img,img_size,eye.inner.s,eye.inner.e,offset)
          float response = a
          #// printf("| %5.2f ",response)
          if(response  > best_response):
            #// printf("!");
            best_response = response
            best_pos = {i,j}
            #// printf("%i %i", (int)best_pos.r,(int)best_pos.c);
            best_h = eye.h
