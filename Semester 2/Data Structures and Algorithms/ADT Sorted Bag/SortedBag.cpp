#include "SortedBag.h"
#include "SortedBagIterator.h"
#include <exception>

using namespace std;

SortedBag::SortedBag(Relation r) {
	this->capacity = 1;
	this->nrElements = 0;
	this->elements = new TComp[this->capacity];
	this->relation = r;
}
// Theta(1)

void SortedBag::add(TComp e) {
	if (this->capacity <= 0)
		throw exception();
	else
	{
		if (this->capacity == this->nrElements)
				resize();
			if (this->nrElements == 0)
			{
				this->elements[this->nrElements++] = e;
			}
			else {
				int index = this->nrElements - 1;
				while (index >= 0 && this->relation(this->elements[index], e) == false)
				{
					this->elements[index + 1] = this->elements[index]; //move the elements that do not corespond
					index--;
				}
				this->elements[index + 1] = e;
				this->nrElements++;
			}
	}
	
}
// Best case: Theta(1)
// Worst case: Theta(nrElements)
// Total Complexity: O(nrElements)


bool SortedBag::remove(TComp e) {
	int index = 0;
	bool found = false;
	if (this->nrElements == 0)
		return false;
	else
	{
		while (index < this->nrElements && found == false)
		{
			if (this->elements[index] == e)
			{
				found = true;
			}
			else
				index++;
		}
		if (found == false)
			return false;
		else
		{
			while (index < nrElements - 1)
			{
				this->elements[index] = this->elements[index + 1];
				index++;
			}
			this->nrElements--;
			return true;

		}
	}
	
}
// Best case: Theta(1)
// Worst case: Theta(nrElements)
// Total Complexity: O(nrElements)


bool SortedBag::search(TComp elem) const {
	if (this->nrElements == 0)
		return false;
	else
	{
		for (int index = 0; index<this->nrElements;index++)
			if(this->elements[index] == elem)
				return true;
	}
	return false;
	
}
// Binary search for efficiency
// Best Case: Theta(1)
// Worst Case: Theta(nrElem)
// Total complexity: O(nrElem)


int SortedBag::nrOccurrences(TComp elem) const {
	int index = 0;
	int count = 0;
	while (index < nrElements)
	{
		if (this->elements[index] == elem)
			count++;
		index++;
	}
	if (count != 0)
		return count;
	else
		return 0;
}
// Best case: Theta(1)
// Worst case: Theta(nrElements)
// Total Complexity: O(nrElements)


int SortedBag::size() const {
	return this->nrElements;
}
// Theta(1)

bool SortedBag::isEmpty() const {
	if (this->nrElements == 0)
		return true;
	else
		return false;
}
// Theta(1)

SortedBagIterator SortedBag::iterator() const {
	return SortedBagIterator(*this);
}


SortedBag::~SortedBag() {
	delete[] this->elements;
}
void SortedBag::addOccurrences(int nr, TComp elem)
{
	if (nr < 0 || this->capacity <= 0)
		throw exception();
	else 
	{
		while (this->capacity <= this->nrElements + nr)
			resize();
		if (this->nrElements == 0)
		{
			int contor = 0;
			while (contor < nr)
			{
				this->elements[contor++] = elem;
				this->nrElements++;
			}
			
		}
		else {
			int index = this->nrElements - 1;
			while (index >= 0 && this->relation(this->elements[index], elem) == false)
			{
				this->elements[index + nr] = this->elements[index]; //move the elements that do not corespond
				index--;
			}
			for (int i = 1; i <= nr; i++)
			{
				this->elements[index + i ] = elem;
				this->nrElements++;
			}
			
			
		}
	}
}
// Best case: Theta(1)
// Worst case: Theta(nrElements)
// Total Complexity: O(nrElements)

void SortedBag::resize() {
	TComp* NewElements;
	NewElements = new TComp[this->capacity * 2];
	this->capacity = this->capacity * 2;
	for (int i = 0; i < this->nrElements; i++)
	{
		NewElements[i] = this->elements[i];
	}
	delete[] this->elements;
	this->elements = NewElements;
}
// Theta(nrElements)

