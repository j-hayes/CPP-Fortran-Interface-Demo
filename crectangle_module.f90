! crectangle_module.f90

MODULE my_typedef
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE

END MODULE my_typedef

module CRectangle_module
   use, intrinsic :: ISO_C_Binding, only: C_int, C_ptr, C_NULL_ptr, C_double
   implicit none
   private
   type CRectangle_type
      private
      type(C_ptr) :: object = C_NULL_ptr
   end type CRectangle_type

   type, bind(c) :: double_wrappper
      integer(c_int) :: count
      type(c_ptr) :: values ! Maps to “double *d”
   end type double_wrappper
   
   interface
      function C_CRectangle__new (a, b) result(this) bind(C,name="CRectangle__new")
         import
         type(C_ptr) :: this
         integer(C_int), value :: a, b
      end function C_CRectangle__new
      subroutine C_CRectangle__delete (this) bind(C,name="CRectangle__delete")
         import
         type(C_ptr), value :: this
      end subroutine C_CRectangle__delete
      function C_CRectangle__area (this) result(the_area) bind(C,name="CRectangle__area")
         import
         integer(C_int) :: the_area
         type(C_ptr), value :: this
      end function C_CRectangle__area
      subroutine C_CRectangle_get_values (this, values_pointer)  bind(C,name="CRectangle_get_values")
         import
         type(C_ptr), value :: this
         type(double_wrappper) :: values_pointer
      end subroutine C_CRectangle_get_values
      function CPure__dofunction (a) result(b) bind(C,name="CPure__dofunction")
        import
        integer(C_int), value :: a
        real(C_double) :: b
      end function CPure__dofunction
            
   end interface
   
   interface new
      module procedure CRectangle__new
   end interface new
   interface delete
      module procedure CRectangle__delete
   end interface delete
   interface area
      module procedure CRectangle__area
   end interface area
   
   interface get_values
      module procedure CRectangle_get_values
   end interface get_values

   interface do_my_function
      module procedure Cdofunction
   end interface do_my_function
   public :: new, delete, area, CRectangle_type, do_my_function, double_wrappper, get_values
contains
! Fortran wrapper routines to interface C wrappers
   subroutine CRectangle__new(this,a,b)
      type(CRectangle_type), intent(out) :: this
      integer :: a,b
      this%object = C_CRectangle__new(int(a,C_int),int(b,C_int))
   end subroutine CRectangle__new
   subroutine CRectangle__delete(this)
      type(CRectangle_type), intent(inout) :: this
      call C_CRectangle__delete(this%object)
      this%object = C_NULL_ptr
   end subroutine CRectangle__delete
   function CRectangle__area(this) result(area_value)
      type(CRectangle_type), intent(in) :: this
      integer :: area_value
      area_value = C_CRectangle__area(this%object)
   end function CRectangle__area
   
   subroutine CRectangle_get_values(this, wrapper)
      type(CRectangle_type), intent(in) :: this
      type(double_wrappper) :: wrapper
      call C_CRectangle_get_values(this%object, wrapper)
   end subroutine CRectangle_get_values
   
   function Cdofunction(a) result(b)
    double precision :: b
    integer :: a
    b = CPure__dofunction(a)
   end function Cdofunction
end module CRectangle_module
program main
   use CRectangle_module
   use, intrinsic :: ISO_C_Binding

   REAL(c_double), POINTER :: fortran_values(:)
   type(CRectangle_type) :: rect
   type(double_wrappper) :: values
   call new(rect,3,4)
   write(*,*) 'rect area: ', area(rect)
   call delete(rect)   
   write(*,*) 'do function: ', do_my_function(3)
   call get_values(rect, values)
   call c_f_pointer (values%values, fortran_values, (/ N /))
   write(*,*) fortran_values(1)
   write(*,*) fortran_values(2)

end program main
