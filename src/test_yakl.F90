program test_yakl

  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env

  use mpi

  ! yakl memory allocator
  use gator_mod

  use m_my_kernels

  implicit none

  integer   :: nbTask, myRank, ierr, i

  !integer(int32), allocatable, target :: data(:)
  real(real32), contiguous, pointer :: data(:)
  integer(int32)                    :: data_size=12


  call MPI_Init(ierr)

  call MPI_COMM_SIZE(MPI_COMM_WORLD, nbTask, ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, myRank, ierr)

  call gator_init()

  write (*,*) 'I am task', myRank, 'out of',nbTask

  !allocate(data(data_size))
  call gator_allocate(data, (/data_size/))

  do i=1,data_size
     data(i) = data_size*myrank + i*1.0
  end do

  write(*,*) "before ", "rank=", myRank, "| data= ", data

  call f_square(data, data_size)

  write(*,*) "after  ", "rank=", myRank, "| data= ", data

  !deallocate(data)
  call gator_deallocate(data)


  call gator_finalize()

  call MPI_Finalize(ierr)

end program test_yakl
