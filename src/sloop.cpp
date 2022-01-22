#include "sloop.h"

#include "base.h"

#include <iostream>

std::string Sloop::ShipType() const
{
    return "⛵";
}

BaseFactory *createFactory()
{
    return new ShipFactory<Sloop>();
}

const std::type_index *getTypeId()
{
    return new std::type_index(typeid(ShipFactoryBase));
}
