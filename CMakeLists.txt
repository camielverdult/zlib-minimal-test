cmake_minimum_required(VERSION 3.22)
project(zlib_minimal_test)

set(CMAKE_CXX_STANDARD 17)

include(FetchContent)

FetchContent_Declare(
        zlib-minimal
        GIT_REPOSITORY https://github.com/camielverdult/zlib-minimal.git
        GIT_TAG        main
)

FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG        release-1.11.0
)

# for Windows: prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(zlib-minimal googletest)

include_directories(${zlib-minimal_SOURCE_DIR})

add_compile_options(-Wall -Wextra -Wpedantic -Werror -fno-omit-frame-pointer)

add_executable(zlib_minimal_test main.cpp)

target_link_libraries(zlib_minimal_test zlib-minimal gtest_main)