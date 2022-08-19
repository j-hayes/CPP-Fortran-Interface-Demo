// crectangle_class.cc
#include <iostream>
#include <vector>
using namespace std;

typedef struct
{
  int count;
  double *values;
} double_wrapper;

class CRectangle
{
  double width, height;

public:
  CRectangle(int, int);
  double area() { return (width * height); }
  void get_values(double_wrapper *values_pointer)
  {
    values_pointer->count = 10;
    values_pointer->values = new double[10];
    cout << "adding values in getter: " << endl;
    for (int i = 0; i < 10; i++)
    {
      values_pointer->values[i] = i*100+1.2;
    }
    cout << "added values in getter: " << endl;
  }
};
CRectangle::CRectangle(int a, int b)
{
  width = a;
  height = b;
}

namespace purefunctions
{
  double do_function(int b)
  {
    return 1.74 + b;
  }
} // namespace pure_functions

/* C wrapper interfaces to C++ routines */
extern "C"
{
  using namespace purefunctions;

  CRectangle *CRectangle__new(int a, int b)
  {
    return new CRectangle(a, b);
  }
  int CRectangle__area(CRectangle *This)
  {
    return This->area();
  }

  void CRectangle_get_values(CRectangle *This, double_wrapper* values_pointer)
  {
    This->get_values(values_pointer);
  }
  void CRectangle__delete(CRectangle *This)
  {
    delete This;
  }

  double CPure__dofunction(int b)
  {
    return do_function(b);
  }
}
/* example main() written in C++:
int main () {
  CRectangle rect;
  rect.set_values (3,4);
  cout << "area: " << rect.area();
  return 0;
}
*/
