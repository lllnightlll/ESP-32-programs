cmake_minimum_required(VERSION 3.16.0)

if(IDF_TARGET)
    include($ENV{IDF_PATH}/tools/cmake/project.cmake)
    project(esp32-programs)
else()
    project(esp32-programs LANGUAGES CXX)

    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)

    add_executable(esp32-programs src/main.cpp)
endif()
