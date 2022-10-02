#
# a library doing dummy computations
#
add_library(mykernels
  STATIC
  mykernels.F90
  mykernels.cu)

#
# test executable
#
add_executable(test_yakl
  test_yakl.F90)

# make sure gator_mod.mod is found when using regular yakl
# fortran gator module is located in yakl builds dir
if (NOT USE_MODIFIED_YAKL)
  target_include_directories(test_yakl
    PUBLIC
    ${YAKL_BINARY_DIR})
endif()

target_link_libraries(test_yakl
  PUBLIC
  yakl::yakl
  MPI::MPI_Fortran
  mykernels)
