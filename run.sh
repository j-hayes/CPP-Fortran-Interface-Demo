g++ -c crectangle_class.cc
gfortran -c crectangle_module.f90
gfortran -o crectangle crectangle_class.o crectangle_module.o -lstdc++
./crectangle