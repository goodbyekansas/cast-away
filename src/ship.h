#ifndef SHIP_H
#define SHIP_H

#include <string>

#include "base.h"

class SHIP_API Ship {
 public:
    virtual ~Ship();
    virtual std::string ShipType() const = 0;
};

#endif
