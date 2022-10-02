# see https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
include(GNUInstallDirs)

################################# EXPORT CONFIG #################################
include(CMakePackageConfigHelpers)

# setup some variables
set(version_config ${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake)
set(project_config_src ${PROJECT_SOURCE_DIR}/cmake/${PROJECT_NAME}-config.cmake.in)
set(project_config_dst ${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config.cmake)
set(targets_export_name ${PROJECT_NAME}-targets)

# important variables
set(INSTALL_BINDIR ${CMAKE_INSTALL_BINDIR} CACHE STRING
  "Installation directory for executables, relative to ${CMAKE_INSTALL_PREFIX}.")

set(INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR} CACHE STRING
  "Installation directory for libraries, relative to ${CMAKE_INSTALL_PREFIX}.")

set(INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE STRING
  "Installation directory for include files, relative to ${CMAKE_INSTALL_PREFIX}.")

set(INSTALL_PKGCONFIG_DIR ${CMAKE_INSTALL_LIBDIR}/pkgconfig CACHE PATH
  "Installation directory for pkgconfig (.pc) files, relative to ${CMAKE_INSTALL_PREFIX}.")

set(INSTALL_CMAKE_DIR ${CMAKE_INSTALL_LIBDIR}/cmake CACHE STRING
  "Installation directory for cmake files, relative to ${CMAKE_INSTALL_PREFIX}.")

# Generate the version, config and target files into the build directory.
write_basic_package_version_file(
  ${version_config}
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion)

# Generate cmake my_package-config.cmake file
configure_package_config_file(
  ${project_config_src}
  ${project_config_dst}
  INSTALL_DESTINATION ${INSTALL_CMAKE_DIR})

# Use a namespace because CMake provides better diagnostics
# for namespaced imported targets.
export(
  TARGETS mykernels test_yakl
  NAMESPACE embedding_yakl::
  APPEND FILE ${PROJECT_BINARY_DIR}/${targets_export_name}.cmake)

############################### INSTALL TARGETS ###########################

# install executables and libs
# archive => static libraries
# runtime => shared libraries
install(
  TARGETS test_yakl mykernels
  EXPORT ${targets_export_name}
  ARCHIVE DESTINATION ${INSTALL_LIBDIR} COMPONENT lib
  LIBRARY DESTINATION ${INSTALL_LIBDIR} COMPONENT lib
  RUNTIME DESTINATION ${INSTALL_BINDIR} COMPONENT bin
  )

# install cmake config and targets
install(
  FILES ${project_config_dst} ${version_config}
  DESTINATION ${INSTALL_CMAKE_DIR})

install(
  EXPORT ${targets_export_name}
  DESTINATION ${INSTALL_CMAKE_DIR}
  NAMESPACE embedding_yakl::)
