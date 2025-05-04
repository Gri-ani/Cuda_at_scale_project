all:
	nvcc -std=c++11 -o sobel main.cu utils.cpp
