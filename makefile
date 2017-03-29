# Make
MAKEFLAGS += --no-print-directory

# Compiler
CC	:= clang
CXX	:= clang++

# Build Type
BUILD	?= Debug

# Project
PROJECT	:= $(shell grep "^project" CMakeLists.txt | cut -c9- | cut -d" " -f1)
CURRENT	:= $(shell grep "^CMAKE_BUILD_TYPE:STRING" build/llvm/CMakeCache.txt 2>/dev/null | cut -c25-)

# Sources
SOURCES	:= $(shell find src -type f)

# Targets
all: build/llvm/CMakeCache.txt $(SOURCES)
	@cmake --build build/llvm

build/llvm/CMakeCache.txt: build/llvm CMakeLists.txt
	@cd build/llvm && CC="$(CC)" CXX="$(CXX)" cmake -GNinja -DCMAKE_BUILD_TYPE=$(BUILD) -DCMAKE_INSTALL_PREFIX:PATH=../.. ../..

build/llvm:
	@mkdir -p build/llvm

clean:
	rm -rf build/llvm

run: all
	LD_LIBRARY_PATH=build/llvm build/llvm/$(PROJECT)

install: build/llvm
	@cmake --build build/llvm --target install