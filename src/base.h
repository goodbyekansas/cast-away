#ifndef BASE_FACTORY_H
#define BASE_FACTORY_H

#define SHIP_API __attribute__ ((visibility("default")))

class Ship;

class SHIP_API BaseFactory
{
 public:
    virtual ~BaseFactory();
};


class ShipFactoryBase : public BaseFactory
{
 public:
    SHIP_API virtual Ship* BuildShip() const = 0;
};

template <class ShipType>
class ShipFactory : public ShipFactoryBase
{
 public:
    virtual Ship* BuildShip() const override
    {
        return new ShipType;
    }
};

#endif
