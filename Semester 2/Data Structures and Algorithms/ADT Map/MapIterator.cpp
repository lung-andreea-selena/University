#include "Map.h"
#include "MapIterator.h"
#include <exception>
using namespace std;


MapIterator::MapIterator(const Map& d) : map(d), current(-1) {
	first();
}
//theta(1)


void MapIterator::first() {
	current = map.head; // set the iterator to the head of the linked list
}
//theta(1)


void MapIterator::next() {
	if (current == -1)
		throw exception(); // invalid iterator, cannot advance

	current = map.next[current]; // move to the next element in the linked list
}
//theta(1)


TElem MapIterator::getCurrent(){
	if (current == -1)
		throw exception(); // Invalid iterator, cannot retrieve current element

	return map.elems[current]; // Return the current element (key-value pair)
}
//theta(1)

bool MapIterator::valid() const {
	return current != -1; // Check if the iterator is valid (not at the end of the linked list)
}
//theta(1)


