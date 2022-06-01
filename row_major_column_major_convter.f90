Program matrix_converter
   IMPLICIT NONE

   REAL, DIMENSION(21) :: gamess = (/0.0, 1.0, 3.0, 6.0, 10.0, 15.0, 2.0, &
      4.0, 7.0, 11.0, 16.0, 5.0, 8.0, 12.0, 17.0, 9.0, 13.0, 18.0, 14.0, 19.0, 20.0/)
   Real, Dimension(21) :: libcchem = (/0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0/)
   call convert(gamess, libcchem)
   
   print*, gamess
   print*,"" 
   print*,
   
   
   print*, libcchem

contains

   subroutine convert(row_major_upper_T,  column_major_lower_T)
      implicit none
      REAL, DIMENSION(:), intent(in) :: row_major_upper_T !gamess style row major upper triangular matrix
      REAL, DIMENSION(:), intent(out) :: column_major_lower_T !column major lower triangular matrix 
      integer :: i, j, x, row_major_index, loop_start_index, column_major_i !indicies 
      integer :: N, dimensions, items_in_row ! array and matrix properties


      N = size(row_major_upper_T)
      dimensions = int(1.0/2.0*(1 + sqrt(8.0*N+1.0))-1)
      do i = 0, dimensions !loop over rows
         row_major_index = 0
         loop_start_index = 0
         do x = 0, i-1 !computer starting points in the array based on index
            row_major_index = + row_major_index + dimensions-x
            loop_start_index = loop_start_index + x + 2
         end do
         items_in_row = dimensions - i
         column_major_i = loop_start_index
         do j = 0, items_in_row -1 !put items from row into proper places in column_major_lower_T array
            column_major_lower_T(column_major_i+1) = row_major_upper_T(row_major_index+1)
            row_major_index = row_major_index + 1
            column_major_i = column_major_i + j+1+i
         end do
      end do

   end subroutine convert

end program matrix_converter
