#include "SortedBagIterator.h"
#include "SortedBag.h"
#include <exception>

using namespace std;

SortedBagIterator::SortedBagIterator(const SortedBag& b) : bag(b) {
	this->current = 0;
}
// Theta(1)

TComp SortedBagIterator::getCurrent() {
	if (valid() == true)
		return this->bag.elements[this->current];
	else
		throw exception();
}
// Theta(1)

bool SortedBagIterator::valid() {
	if (this->current < this->bag.nrElements)
		return true;
	else return false;
}
// Theta(1)

void SortedBagIterator::next() {
	if (valid() == true)
		this->current++;
	else
		throw exception();
}
// Theta(1)

void SortedBagIterator::first() {
	this->current = 0; //reset the first
}
// Theta(1)

