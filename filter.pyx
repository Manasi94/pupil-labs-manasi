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


cdef inline float area(img,point_t size,point_t start,point_t end,point_t offset):
    return    (img[(offset.r + end.r  ) * size.c + offset.c + end.c]+ img[(offset.r + start.r) * size.c + offset.c + start.c]- img[(offset.r + start.r) * size.c + offset.c + end.c]- img[(offset.r + end.r  ) * size.c + offset.c + start.c])

cpdef eye_t make_eye(int h):
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

cpdef void filter(img, int min_w=10,int max_w=100):

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


    for h in range(min_h,max_h,h_step):
      eye = make_eye(h)
      for i in range(0,img_size.r-eye.w,step):
        for j in range(0,img_size.c-eye.w,step):
          #// printf("|%2.0f",img[w,step):
          #// printf("|%2.0f",img[i * cols + j]);
          offset = {i,j}

          response = eye.outer.f*area(img,img_size,eye.outer.s,eye.outer.e,offset)+eye.inner.f*area(img,img_size,eye.inner.s,eye.inner.e,offset)
          #// printf("| %5.2f ",response)
          if(response  > best_response):
            #// printf("!");
            best_response = response
            best_pos = {i,j}
            #// printf("%i %i", (int)best_pos.r,(int)best_pos.c);
            best_h = eye.h
