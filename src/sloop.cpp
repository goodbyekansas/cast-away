#include "sloop.h"

#include "base.h"

#include <iostream>
#include <typeindex>

std::string Sloop::ShipType() const
{
    return "⛵";
}

// Plugin interface
SHIP_API extern "C" BaseFactory *createFactory()
{
    return new ShipFactory<Sloop>();
}

SHIP_API extern "C" const std::type_index *getTypeId()
{
    return new std::type_index(typeid(ShipFactoryBase));
}
