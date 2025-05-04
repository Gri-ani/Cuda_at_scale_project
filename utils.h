// utils.h
#include <vector>
#include <string>
unsigned char* readPGM(const char* filename, int* width, int* height);
void writePGM(const char* filename, unsigned char* data, int width, int height);
std::vector<std::string> getPGMFiles(const std::string& folder);
