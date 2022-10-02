module m_my_kernels

  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env

  implicit none

interface

  subroutine square_bind(a,size) bind(c, name='square')
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env
    implicit none
    type(c_ptr), value :: a
    integer(int32), value :: size
  end subroutine square_bind

end interface

contains

  subroutine f_square(a,size)

    implicit none

    real(real32), contiguous, pointer :: a(:)
    integer(int32)                    :: size

    call square_bind(c_loc(a), size)

  end subroutine f_square

end module m_my_kernels
