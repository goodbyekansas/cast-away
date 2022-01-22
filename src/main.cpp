#include <iostream>

#include <dlfcn.h>
#include <errno.h>
#include <typeindex>

#include "base.h"
#include "ship.h"

#if not defined(STDLIB)
#define STDLIB "unknown"
#endif

typedef BaseFactory* (*FactoryFunction)();
typedef std::type_index* (*GetTypeInfo)();

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

    GetTypeInfo getTypeInfo = (GetTypeInfo) dlsym(plugin, "getTypeId");
    BaseFactory *factory = ff();
    std::cout
        << "🃏 Type for ShipFactoryBase in host and plugin are equal? "
        << (std::type_index(typeid(ShipFactoryBase)) == *(getTypeInfo()) ? "✅ yes" : "❌ no")
        << std::endl;

    ShipFactoryBase *shipFactory = dynamic_cast<ShipFactoryBase*>(factory);

    if (!shipFactory) {
        std::cerr << "😭 Failed to cast factory to a ship factory when using " STDLIB "!" << std::endl;
        return 4;
    }

    Ship *ship = shipFactory->BuildShip();
    std::cout << "🚢 Ship type: " << ship->ShipType() << std::endl;
    delete ship;
    return 0;
}
