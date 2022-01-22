#ifndef BASE_FACTORY_H
#define BASE_FACTORY_H

class Ship;

class BaseFactory
{
 public:
    virtual ~BaseFactory();
};


class ShipFactoryBase : public BaseFactory
{
 public:
    virtual Ship* BuildShip() const = 0;
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
