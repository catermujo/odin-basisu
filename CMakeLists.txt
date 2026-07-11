cmake_minimum_required(VERSION 3.20)

project(basisu_c)

option(BASISU_BUILD_SHARED "Build the Odin C API as a shared library" OFF)

add_subdirectory(basis_universal)

set_target_properties(basisu_encoder PROPERTIES POSITION_INDEPENDENT_CODE ON)

if(BASISU_BUILD_SHARED)
    add_library(basisu_c SHARED basis_universal/encoder/basisu_wasm_api.cpp basis_universal/encoder/basisu_wasm_transcoder_api.cpp)
else()
    add_library(basisu_c STATIC basis_universal/encoder/basisu_wasm_api.cpp basis_universal/encoder/basisu_wasm_transcoder_api.cpp)
endif()

target_link_libraries(basisu_c PRIVATE basisu_encoder)
