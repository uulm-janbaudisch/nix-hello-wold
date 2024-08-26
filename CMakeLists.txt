cmake_minimum_required(VERSION 3.5)

project(HelloWorld)

add_executable(hello main.c)

install(TARGETS hello)
