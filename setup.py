from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize
import numpy
import subprocess
 
proc_libs = subprocess.check_output("pkg-config --libs /usr/local/Cellar/opencv3/3.0.0/lib/pkgconfig/opencv.pc".split())
proc_incs = subprocess.check_output("pkg-config --cflags /usr/local/Cellar/opencv3/3.0.0/lib/pkgconfig/opencv.pc".split())

libs = [lib for lib in str(proc_libs, "utf-8").split()]
print("OPENCV LIBS=" + str(libs))
 
setup(
  cmdclass = {'build_ext': build_ext},
  ext_modules = cythonize(
    Extension("opencvtest",
    sources = ["opencvtest.pyx"],
    language = "c++",
    include_dirs=[numpy.get_include(), "/usr/local/Cellar/opencv3/3.0.0/include/"],
    extra_link_args=libs
    )
  )
)
