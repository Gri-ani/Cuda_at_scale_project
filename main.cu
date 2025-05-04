#include <iostream>
#include <vector>
#include <string>
#include <dirent.h>
#include "utils.h"

#define BLOCK_SIZE 16

__global__ void sobelKernel(unsigned char* input, unsigned char* output, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= 1 && y >= 1 && x < width - 1 && y < height - 1) {
        int gx = -input[(y - 1) * width + (x - 1)] - 2 * input[y * width + (x - 1)] - input[(y + 1) * width + (x - 1)]
                 + input[(y - 1) * width + (x + 1)] + 2 * input[y * width + (x + 1)] + input[(y + 1) * width + (x + 1)];

        int gy = -input[(y - 1) * width + (x - 1)] - 2 * input[(y - 1) * width + x] - input[(y - 1) * width + (x + 1)]
                 + input[(y + 1) * width + (x - 1)] + 2 * input[(y + 1) * width + x] + input[(y + 1) * width + (x + 1)];

        output[y * width + x] = min(255, abs(gx) + abs(gy));
    }
}

void processImage(const std::string& inputPath, const std::string& outputPath) {
    int width, height;
    unsigned char* inputImage = readPGM(inputPath.c_str(), &width, &height);
    unsigned char* outputImage = new unsigned char[width * height];

    unsigned char *d_input, *d_output;
    cudaMalloc(&d_input, width * height);
    cudaMalloc(&d_output, width * height);

    cudaMemcpy(d_input, inputImage, width * height, cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 numBlocks((width + BLOCK_SIZE - 1) / BLOCK_SIZE, (height + BLOCK_SIZE - 1) / BLOCK_SIZE);

    sobelKernel<<<numBlocks, threadsPerBlock>>>(d_input, d_output, width, height);

    cudaMemcpy(outputImage, d_output, width * height, cudaMemcpyDeviceToHost);

    writePGM(outputPath.c_str(), outputImage, width, height);

    cudaFree(d_input);
    cudaFree(d_output);
    delete[] inputImage;
    delete[] outputImage;
}

int main() {
    std::vector<std::string> files = getPGMFiles("images/");
    for (const auto& file : files) {
        std::string inputPath = "images/" + file;
        std::string outputPath = "images/output_" + file;
        std::cout << "Processing " << inputPath << std::endl;
        processImage(inputPath, outputPath);
    }
    return 0;
}
