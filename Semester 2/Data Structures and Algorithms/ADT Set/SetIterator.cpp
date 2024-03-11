#include "SetIterator.h"
#include "Set.h"
#include <exception>


SetIterator::SetIterator(const Set& m) : set(m) {
    this->currentElement = 0;
    while (currentElement < set.capacity && set.elements[currentElement].state != OCCUPIED)
        currentElement++;
}
// Best case: theta(1) - when the first element is occupied
// Worst case: theta(m) - when the last element is occupied

void SetIterator::first() {
    currentElement = 0;
    while (currentElement < set.capacity && set.elements[currentElement].state != OCCUPIED)
        currentElement++;
}
// Best case: theta(1) - when the first element is occupied
// Worst case: theta(m) - when the last element is occupied


void SetIterator::next() {
    if (!valid())
        throw std::exception();
    currentElement++;
    while (currentElement < set.capacity && set.elements[currentElement].state != OCCUPIED)
        currentElement++;
}
// Best case: theta(1) - when the first element is occupied
// Worst case: theta(m) - when the last element is occupied


TElem SetIterator::getCurrent() {
    if (!valid())
        throw std::exception();

    return set.elements[currentElement].value;
}
// Total complexity: theta(1)

bool SetIterator::valid() const {
    return currentElement < set.capacity && set.elements[currentElement].state == OCCUPIED;
}
// Total complexity: theta(1)



