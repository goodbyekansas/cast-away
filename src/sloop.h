#ifndef SLOOP_H
#define SLOOP_H

#include "ship.h"

class BaseFactory;

extern "C" BaseFactory *createFactory();

class Sloop : public Ship
{
 public:
    std::string ShipType() const;
};

#endif
