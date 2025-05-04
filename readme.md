# CUDA at Scale: Sobel Edge Detection

## Project Description

This project applies Sobel edge detection using CUDA to process a large number of grayscale PGM images. The code loads multiple images from the `images/` directory, applies a CUDA kernel in parallel, and outputs the edge-detected results in the same folder with `output_` prefix.

## Requirements

- NVIDIA GPU with CUDA support
- nvcc (CUDA compiler)
- Grayscale `.pgm` images placed in `images/` folder

## Usage

```bash
make
bash run.sh
