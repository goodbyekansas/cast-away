#ifndef SLOOP_H
#define SLOOP_H

#include "ship.h"

class BaseFactory;

class SHIP_API Sloop : public Ship {
public:
  std::string ShipType() const;
};

#endif
