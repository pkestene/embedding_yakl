cmake_minimum_required(VERSION 3.18)

project(embedding_yakl
  LANGUAGES C CXX Fortran
  VERSION 1.0)

option(ENABLE_INSTALL "enable install (default: OFF)" OFF)

#
# Export compile commands to json (for editors like emacs, clion, vim, etc...).
#
set(CMAKE_EXPORT_COMPILE_COMMANDS on)

#
# default local cmake macro repository (located in abinit top level sources)
#
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

#
# Enforce user to use a build directory outside of source tree
#
include(prevent_in_source_build)
PREVENT_IN_SOURCE_BUILD()

#
# Set default compile optimization flag
#
if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(DEFAULT_BUILD_TYPE "RelWithDebInfo")
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING
    "Choose the type of build, options are: Debug, Release, RelWithDebInfo and MinSizeRel." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif ()

#
# External dependencies
#


set(MPI_DETERMINE_LIBRARY_VERSION TRUE)
find_package(MPI COMPONENTS Fortran)
if(MPI_FOUND)
  add_compile_definitions(HAVE_MPI)
endif()

# determine mpi vendor (MPI_VENDOR)
# possible values are : OpenMPI, MPICH or IntelMPI
include(get_mpi_vendor)
get_mpi_vendor()

if (NOT DEFINED MPI_VERSION AND DEFINED MPI_Fortran_VERSION)
  set(MPI_VERSION ${MPI_Fortran_VERSION})
  set(MPI_VERSION_MAJOR ${MPI_Fortran_VERSION_MAJOR})
  set(MPI_VERSION_MINOR ${MPI_Fortran_VERSION_MINOR})
endif()

#
# OpenMP
#
find_package(OpenMP)

#
# YAKL : https://github.com/mrnorman/YAKL
#
include(build_yakl)

if(YAKL_ARCH STREQUAL "CUDA")
  enable_language(CUDA)
endif()

##################### PRINT CONFIGURE STATUS ######################
message("//===================================================")
message("// ${PROJECT_NAME} build configuration:")
message("// ${PROJECT_NAME} version : ${PROJECT_VERSION}")
message("//===================================================")
message("  CMake version          : ${CMAKE_VERSION}")
if (NOT CMAKE_BUILD_TYPE)
  message("  CMake build type       : NOT SET !")
else()
  message("  CMake build type       : ${CMAKE_BUILD_TYPE}")
endif()
message("  CMake install prefix   : ${CMAKE_INSTALL_PREFIX}")
message("  CMake system processor : ${CMAKE_SYSTEM_PROCESSOR}")
message("  CMake system name (OS) : ${CMAKE_SYSTEM_NAME}")
message("")

message("  Fortran compiler Id      : ${CMAKE_Fortran_COMPILER_ID}")
message("  Fortran compiler version : ${CMAKE_Fortran_COMPILER_VERSION}")
message("  Fortran compiler exe     : ${CMAKE_Fortran_COMPILER}")
message("  Fortran flags            : ${CMAKE_Fortran_FLAGS}")
message("  Fortran compiler wrapper : ${CMAKE_Fortran_COMPILER_WRAPPER}")
message("")

message(STATUS "MPI config:")
message("    MPI found            : ${MPI_FOUND}")
message("    MPI standard version : ${MPI_Fortran_VERSION}")
# note : make sure you correctly your C, C++ and Fortran compiler
# through variable CC, CXX and FC
message("    MPI_VENDOR           : ${MPI_VENDOR}")
message("    MPI library version  : ${MPI_Fortran_LIBRARY_VERSION_STRING}")
message("    MPI fortran compiler : ${MPI_Fortran_COMPILER}")
message("    MPI headers          : ${MPI_Fortran_INCLUDE_DIRS}")
message("    MPI libraries        : ${MPI_Fortran_LIBRARIES}")
#message("    MPI link flags       : ${MPI_Fortran_LINK_FLAGS}")
message("")

message(STATUS "OpenMP config :")
message("    OpenMP found         : ${OpenMP_FOUND}")
message("    OpenMP version       : ${OpenMP_Fortran_VERSION}")
message("")

message(STATUS "Yakl config :")
message("    YAKL wanted         : ${EMBEDDINGYAKL_YAKL_WANTED}")
if(EMBEDDINGYAKL_YAKL_WANTED)
  message("    YAKL_ARCH           : ${YAKL_ARCH}")
endif()
message("")

#
# build project
#
add_subdirectory(src)

#
# Install
#
if(ENABLE_INSTALL)
  include(embedding_yakl_install)
endif()
