// utils.cpp
#include "utils.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <dirent.h>

unsigned char* readPGM(const char* filename, int* width, int* height) {
    std::ifstream file(filename, std::ios::binary);
    std::string line;
    std::getline(file, line); // Magic number
    std::getline(file, line); // Comment or whitespace

    while (line[0] == '#') std::getline(file, line); // Skip comments

    std::istringstream iss(line);
    iss >> *width >> *height;
    int maxVal;
    file >> maxVal;
    file.ignore(1);

    unsigned char* data = new unsigned char[*width * *height];
    file.read(reinterpret_cast<char*>(data), *width * *height);
    return data;
}

void writePGM(const char* filename, unsigned char* data, int width, int height) {
    std::ofstream file(filename, std::ios::binary);
    file << "P5\n" << width << " " << height << "\n255\n";
    file.write(reinterpret_cast<char*>(data), width * height);
}

std::vector<std::string> getPGMFiles(const std::string& folder) {
    std::vector<std::string> files;
    DIR* dir = opendir(folder.c_str());
    struct dirent* ent;
    while ((ent = readdir(dir)) != nullptr) {
        if (std::string(ent->d_name).find(".pgm") != std::string::npos) {
            files.push_back(ent->d_name);
        }
    }
    closedir(dir);
    return files;
}
