#
# Option to enable / disable yakl
#
option(EMBEDDINGYAKL_YAKL_WANTED "Turn ON if you want to use yakl (default: ON)" ON)
option(EMBEDDINGYAKL_YAKL_MANAGED_MEMORY_WANTED "Turn ON if you want to use yakl managed memory (default: ON)" ON)
option(USE_MODIFIED_YAKL "default OFF" OFF)


if(EMBEDDINGYAKL_YAKL_WANTED)

  # define symbol HAVE_YAKL project-wide
  add_compile_definitions(HAVE_YAKL)

  if (NOT DEFINED YAKL_ARCH)
    message(FATAL_ERROR "You need to define variable YAKL_ARCH")
  endif()

  if ((NOT YAKL_ARCH MATCHES "CUDA")   AND
      (NOT YAKL_ARCH MATCHES "HIP")    AND
      (NOT YAKL_ARCH MATCHES "SYCL")   AND
      (NOT YAKL_ARCH MATCHES "OPENMP"))
    message(FATAL_ERROR "Variable YAKL_ARCH=${YAKL_ARCH} has an unknown value or correspond to unsupported backend")
  endif()

  message("[EmbeddingYakl] Building yakl from source with YAKL_ARCH=${YAKL_ARCH}")

  # define symbol YAKL_ARCH project-wide
  add_compile_definitions(YAKL_ARCH=${YAKL_ARCH})

  # let's do managed memory
  if ( (YAKL_ARCH STREQUAL "CUDA") OR
       (YAKL_ARCH STREQUAL "HIP") OR
       (YAKL_ARCH STREQUAL "SYCL") )
     add_compile_definitions(YAKL_MANAGED_MEMORY)
     message("[EmbeddingYakl] YAKL managed memory features is activated")
   endif()

  set_property(DIRECTORY PROPERTY EP_BASE ${CMAKE_BINARY_DIR}/external)

  #
  # Yakl doesn't provide releases yet, so just use latest commit (end of Sept. 2022)
  #
  include (FetchContent)

  if (USE_MODIFIED_YAKL)
    FetchContent_Declare( yakl_external
      GIT_REPOSITORY https://github.com/pkestene/YAKL.git
      GIT_TAG 9f85b5f9bbb6e5ee0bb08edb08cc5954a1f1e638
      )
  else()
    FetchContent_Declare( yakl_external
      GIT_REPOSITORY https://github.com/mrnorman/yakl.git
      GIT_TAG 3556a4ed619065175ee122e8fa4a54a65d5782a2
      )
  endif()

  # Import yakl targets (download, and call add_subdirectory)
  FetchContent_MakeAvailable(yakl_external)

  find_package(MPI COMPONENTS CXX)

  # make sure yakl links with MPI
  if (MPI_FOUND)
    target_link_libraries(yakl MPI::MPI_CXX)
  endif()

  # library alias
  add_library(yakl::yakl ALIAS yakl)

endif()
