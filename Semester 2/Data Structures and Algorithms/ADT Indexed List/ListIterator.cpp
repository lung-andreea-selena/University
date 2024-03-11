#include "ListIterator.h"
#include "IndexedList.h"
#include <exception>
using namespace std;

ListIterator::ListIterator(const IndexedList& list) : list(list){
    this->current = 0;
}
//theta(1)

void ListIterator::first(){
    this->current = 0;
}
//theta(1)

void ListIterator::next(){
	if (valid() == true)
		this->current++;
	else
		throw exception();
}
//theta(1)

bool ListIterator::valid() const{
    if (this->current < this->list.size())
        return true;
	return false;
}
//theta(1)

TElem ListIterator::getCurrent() const{
	if (valid() == true)
		return this->list.getElement(this->current);
	else
		throw exception();
}//theta(1)