cmake_minimum_required(VERSION 3.6 FATAL_ERROR)
project(json VERSION 0.1.0 LANGUAGES CXX)

# Compiler
if(MSVC)
  foreach(flag CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE)
    if(${flag} MATCHES "/MD")
      string(REPLACE "/MD" "/MT" ${flag} "${${flag}}")
    endif()
  endforeach()
  set(CMAKE_CXX_FLAGS "/permissive- /std:c++latest ${CMAKE_CXX_FLAGS} /utf-8")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /manifestuac:NO /ignore:4099 /ignore:4098")
  add_definitions(-D_UNICODE -DUNICODDE -DWIN32_LEAN_AND_MEAN -DNOMINMAX)
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -D_ATL_SECURE_NO_DEPRECATE)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_SCL_SECURE_NO_WARNINGS)
  add_definitions(-DWINVER=0x0A00 -D_WIN32_WINNT=0x0A00)
else()
  set(CMAKE_CXX_FLAGS "-std=c++1z -Wextra -Werror -Wno-unused-function -Wno-unused-parameter -Wno-unused-variable ${CMAKE_CXX_FLAGS} -fcolor-diagnostics")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pthread")
endif()

# Soureces
file(GLOB_RECURSE sources src/*.cpp src/*.hpp)

# Source Groups
foreach(source IN ITEMS ${sources})
  if(IS_ABSOLUTE ${source})
    file(RELATIVE_PATH source "${CMAKE_CURRENT_SOURCE_DIR}" "${source}")
  endif()
  get_filename_component(source_path "${source}" PATH)
  if(MSVC)
    string(REPLACE "/" "\\" source_path "${source_path}")
  endif()
  source_group("${source_path}" FILES "${source}")
endforeach()

# Executable
add_executable(${PROJECT_NAME} ${sources})
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR} src)
target_link_libraries(${PROJECT_NAME} PRIVATE $<$<CXX_COMPILER_ID:Clang>:c++experimental>)

# Install
install(TARGETS ${PROJECT_NAME} DESTINATION bin)

# Visual Studio
if(MSVC)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
  set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER build)
  set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME})
endif()