#include "SMMIterator.h"
#include "SortedMultiMap.h"

SMMIterator::SMMIterator(const SortedMultiMap& d) : map(d){
	sortedArray = new TElem[map.size()];
	arraySize = map.size();
	currentIndex = 0;
	map.createSortedArray(sortedArray);
}
//Theta(1)

void SMMIterator::first(){
	currentIndex = 0;
}
//Theta(1)

void SMMIterator::next(){
	if (!valid()) {
		throw exception("Iterator is not valid.");
	}
	currentIndex++;
}
//Theta(1)

bool SMMIterator::valid() const{
	return currentIndex < arraySize;
}
//Theta(1)

TElem SMMIterator::getCurrent() const{
	if (!valid()) {
		throw exception("Iterator is not valid.");
	}
	return sortedArray[currentIndex];
}
//Theta(1)

ValueIterator::ValueIterator(const SortedMultiMap& map, TKey key)
{
	valueArray = map.search(key);
	current = 0;
}
//Theta(1)

void ValueIterator::first() {
	current = 0;
}//Theta(1)

void ValueIterator::next() {

	if (!valid()) {
		throw exception("Iterator is not valid.");
	}
	current++;
}//Theta(1)

bool ValueIterator::valid() const {
	return current < valueArray.size();
}//Theta(1)

TValue ValueIterator::getCurrent() const {
	if (!valid()) {
		throw exception("Iterator is not valid.");
	}
	return valueArray.at(current);
}//Theta(1)