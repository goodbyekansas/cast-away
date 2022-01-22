#ifndef SHIP_H
#define SHIP_H

#include <string>

class Ship {
 public:
    virtual ~Ship();
    virtual std::string ShipType() const = 0;
};

#endif
