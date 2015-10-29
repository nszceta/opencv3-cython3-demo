import numpy as np
cimport numpy as np # for np.ndarray
from libcpp.string cimport string
from libc.string cimport memcpy
 
cdef extern from "opencv2/core/core.hpp":
  cdef int CV_WINDOW_AUTOSIZE
  cdef int CV_8UC3
 
cdef extern from "opencv2/core/core.hpp" namespace "cv":
  cdef cppclass Mat:
    Mat() except +
    void create(int, int, int)
    void* data
 
cdef extern from "opencv2/highgui/highgui.hpp" namespace "cv":
  void namedWindow(const string, int flag)
  void imshow(const string, Mat)
  int  waitKey(int delay)
 
 
cdef void ary2cvMat(np.ndarray ary, Mat& out):
  assert(ary.ndim==3 and ary.shape[2]==3, "ASSERT::3channel RGB only!!")
  ary = np.dstack((ary[...,2], ary[...,1], ary[...,0])) #RGB -> BGR
   
  cdef np.ndarray[np.uint8_t, ndim=3, mode = 'c'] np_buff = np.ascontiguousarray(ary, dtype = np.uint8)
  cdef unsigned int* im_buff = <unsigned int*> np_buff.data
  cdef int r = ary.shape[0]
  cdef int c = ary.shape[1]
  out.create(r, c, CV_8UC3)
  memcpy(out.data, im_buff, r*c*3)
 
 
cdef showMat(Mat m):
  namedWindow( "WIN", CV_WINDOW_AUTOSIZE )
  imshow( "WIN", m )
  waitKey(0)
 
def openImage(pil_img):
  cdef Mat m
  ary2cvMat(np.array(pil_img), m)
  showMat(m)
