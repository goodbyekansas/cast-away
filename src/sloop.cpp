#include "sloop.h"

#include "base.h"

std::string Sloop::ShipType() const
{
    return "⛵";
}

BaseFactory *createFactory()
{
    return new ShipFactory<Sloop>();
}
