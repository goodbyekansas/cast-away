#include "loader.h"

#include "base.h"
#include "ship.h"

#include <dlfcn.h>
#include <errno.h>
#include <typeindex>
#include <iostream>

typedef BaseFactory* (*FactoryFunction)();
typedef std::type_index* (*GetTypeInfo)();

int load_plugin(char *path)
{
    void *plugin = dlopen(path, RTLD_NOW);
    if (plugin == nullptr) {
        std::cerr << "💣 Failed to load plugin " << path << ": " << dlerror() << std::endl;
        return 2;
    }

    FactoryFunction createFactory = (FactoryFunction) dlsym(plugin, "createFactory");
    if (!createFactory) {
        std::cerr << "🐐 Plugin " << path << " does not contain a 'createFactory' function" << std::endl;
        return 3;
    }

    GetTypeInfo getTypeId = (GetTypeInfo) dlsym(plugin, "getTypeId");
    if (!getTypeId) {
        std::cerr << "🐐 Plugin " << path << " does not contain a 'getTypeId' function" << std::endl;
        return 3;
    }

    std::type_index *pluginType = getTypeId();
    std::cout
        << "🃏 Type for ShipFactoryBase in host and plugin are equal? "
        << (std::type_index(typeid(ShipFactoryBase)) == *pluginType ? "✅ yes" : "❌ no")
        << std::endl;
    delete pluginType;

    BaseFactory *factory = createFactory();
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
