
if(NOT "/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-subbuild/zlib-minimal-populate-prefix/src/zlib-minimal-populate-stamp/zlib-minimal-populate-gitinfo.txt" IS_NEWER_THAN "/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-subbuild/zlib-minimal-populate-prefix/src/zlib-minimal-populate-stamp/zlib-minimal-populate-gitclone-lastrun.txt")
  message(STATUS "Avoiding repeated git clone, stamp file is up to date: '/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-subbuild/zlib-minimal-populate-prefix/src/zlib-minimal-populate-stamp/zlib-minimal-populate-gitclone-lastrun.txt'")
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E rm -rf "/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-src"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-src'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/opt/homebrew/bin/git"  clone --no-checkout --config "advice.detachedHead=false" "https://github.com/camielverdult/zlib-minimal.git" "zlib-minimal-src"
    WORKING_DIRECTORY "/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps"
    RESULT_VARIABLE error_code
    )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once:
          ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/camielverdult/zlib-minimal.git'")
endif()

execute_process(
  COMMAND "/opt/homebrew/bin/git"  checkout main --
  WORKING_DIRECTORY "/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-src"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: 'main'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "/opt/homebrew/bin/git"  submodule update --recursive --init 
    WORKING_DIRECTORY "/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-src"
    RESULT_VARIABLE error_code
    )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-src'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy
    "/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-subbuild/zlib-minimal-populate-prefix/src/zlib-minimal-populate-stamp/zlib-minimal-populate-gitinfo.txt"
    "/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-subbuild/zlib-minimal-populate-prefix/src/zlib-minimal-populate-stamp/zlib-minimal-populate-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/Users/camiel-private/Documents/GitHub/zlib-minimal-test/cmake-build-debug/_deps/zlib-minimal-subbuild/zlib-minimal-populate-prefix/src/zlib-minimal-populate-stamp/zlib-minimal-populate-gitclone-lastrun.txt'")
endif()

