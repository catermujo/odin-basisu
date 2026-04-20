cmake_minimum_required(VERSION 3.20)

project(basisu_c)

add_subdirectory(basis_universal)

add_library(basisu_c STATIC basis_universal/encoder/basisu_wasm_api.cpp basis_universal/encoder/basisu_wasm_transcoder_api.cpp)
target_link_libraries(basisu_c PRIVATE basisu_encoder)