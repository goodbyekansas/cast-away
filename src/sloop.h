#ifndef SLOOP_H
#define SLOOP_H

#include "ship.h"
#include <typeindex>

class BaseFactory;

extern "C" BaseFactory *createFactory();
extern "C" const std::type_index *getTypeId();

class Sloop : public Ship
{
 public:
    std::string ShipType() const;
};

#endif
