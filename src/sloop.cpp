#include "sloop.h"

#include "base.h"

#include <iostream>
#include <typeindex>

std::string Sloop::ShipType() const
{
    return "⛵";
}

// Plugin interface
extern "C" BaseFactory *createFactory()
{
    return new ShipFactory<Sloop>();
}

extern "C" const std::type_index *getTypeId()
{
    return new std::type_index(typeid(ShipFactoryBase));
}
