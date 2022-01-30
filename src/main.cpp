#include <iostream>

#include "loader.h"

#if not defined(STDLIB)
#define STDLIB "unknown"
#endif

int main(int argc, char **argv) {
    if (argc != 2) {
        std::cerr << "Please provide ship plugin to load" << std::endl;
        return 1;
    }

    std::cout << "Casting away 🏝 using C++ standard library \"" STDLIB "\"... 🚢" << std::endl;

    if (load_plugin(argv[1]) != 0) {
        return 1;
    }
    return 0;
}
