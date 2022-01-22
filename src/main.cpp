#include <iostream>

#include <dlfcn.h>
#include <errno.h>

#include "base.h"
#include "ship.h"

#if not defined(STDLIB)
#define STDLIB "unknown"
#endif

typedef BaseFactory* (*FactoryFunction)();

int main(int argc, char **argv) {
    if (argc != 2) {
        std::cerr << "Please provide ship plugin to load" << std::endl;
        return 1;
    }

    std::cout << "Casting away 🏝 using C++ standard library \"" STDLIB "\"... 🚢" << std::endl;


    void *plugin = dlopen(argv[1], RTLD_NOW);
    if (plugin == nullptr) {
        std::cerr << "💣 Failed to load plugin " << argv[1] << ": " << dlerror() << std::endl;
        return 2;
    }

    FactoryFunction ff = (FactoryFunction) dlsym(plugin, "createFactory");
    if (!ff) {
        std::cerr << "🐐 Plugin " << argv[1] << " does not contain a 'createFactory' function" << std::endl;
        return 3;
    }

    BaseFactory *factory = ff();
    ShipFactoryBase *shipFactory = dynamic_cast<ShipFactoryBase*>(factory);

    if (!shipFactory) {
        std::cerr << "😭 Failed to cast factory to a ship factory when using " STDLIB "!" << std::endl;
        return 4;
    }

    Ship *ship = shipFactory->BuildShip();
    std::cout << "🚢 Ship type: " << ship->ShipType() << std::endl;
    return 0;
}
