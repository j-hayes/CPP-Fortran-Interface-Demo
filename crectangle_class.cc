// crectangle_class.cc
#include <iostream>
using namespace std;
class CRectangle
{
  int width, height;

public:
  CRectangle(int, int);
  int area() { return (width * height); }
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
