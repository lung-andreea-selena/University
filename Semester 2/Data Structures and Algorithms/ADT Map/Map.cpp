#include "Map.h"
#include "MapIterator.h"
using namespace std;

Map::Map() {
    this->capacity = 10;  // initial capacity
    this->sizeOfList = 0;      // empty map
    this->elems = new TElem[capacity];
    this->next = new int[capacity];
    this->head = -1;     // empty list
    this->firstEmpty = 0; // first empty slot
    // initialize the next array to link all slots as empty
    for (int i = 0; i < capacity - 1; i++) {
        next[i] = i + 1;
    }
    next[capacity - 1] = -1; // last slot points to null
    // initialize the elems array with NULL_TELEM
    for (int i = 0; i < capacity; i++) {
        elems[i] = NULL_TELEM;
    }
}
//theta(capacity)


Map::~Map() {
    delete[] this->elems;
    delete[] this->next;
}
//theta(1)

TValue Map::add(TKey c, TValue v){
    TValue oldValue = search(c);
    if (oldValue != NULL_TVALUE) {
        // key already exists in the map, update the value and return the old value
        int currentPosition = this->head;
        while (currentPosition != -1 && this->elems[currentPosition].first != c) {
            currentPosition = this->next[currentPosition];
        }
        this->elems[currentPosition].second = v;
        return oldValue;
    }
    else {
        // key does not exist, add a new pair
        if (this->firstEmpty == -1) {
            // array is full, need to resize
            int newCapacity = this->capacity * 2;
            TElem* newElems = new TElem[newCapacity];
            int* newNext = new int[newCapacity];
            // copy existing elements and next array to the new arrays
            for (int i = 0; i < this->capacity; i++) {
                newElems[i] = this->elems[i];
                newNext[i] = this->next[i];
            }
            // initialize the additional slots in the new arrays
            for (int i = this->capacity; i < newCapacity - 1; i++) {
                newNext[i] = i + 1;
            }
            newNext[newCapacity - 1] = -1;
            this->capacity = newCapacity;
            delete[] this->elems;
            delete[] this->next;
            this->elems = newElems;
            this->next = newNext;
            this->firstEmpty = this->capacity / 2;
        }
        // add the new key-value pair
        int newPosition = this->firstEmpty;
        this->firstEmpty = next[firstEmpty];
        this->elems[newPosition] = make_pair(c, v);
        this->next[newPosition] = -1;
        if (this->head == -1) {
            // added as the new head of the list
            this->head = newPosition;
        }
        else {
            // insert into the list
            int currentPosition = this->head;
            while (this->next[currentPosition] != -1) {
                currentPosition = this->next[currentPosition];
            }
            this->next[currentPosition] = newPosition;
        }
        this->sizeOfList++; // Increase the size of the map
        return NULL_TVALUE;
    }
}
//Best case: Theta(1)
// Worst case: Theta(n)
// Avarage case : O(n)

TValue Map::search(TKey c) const{
    int currentPosition = this->head;

    while (currentPosition != -1 && this->elems[currentPosition].first != c) {
        currentPosition = this->next[currentPosition];
    }

    if (currentPosition != -1) {
        // Key found, return the associated value
        return elems[currentPosition].second;
    }
    else {
        // Key not found, return NULL_TVALUE
        return NULL_TVALUE;
    }
}
//Best case: Theta(1)
// Worst case: Theta(n)
// Avarage case : O(n)

TValue Map::remove(TKey c){
    int currentPosition = this->head;
    int previousPosition = -1;

    while (currentPosition != -1 && this->elems[currentPosition].first != c) {
        previousPosition = currentPosition;
        currentPosition = this->next[currentPosition];
    }

    if (currentPosition != -1) {
        // key found, remove the key-value pair
        if (previousPosition == -1) {
            // removed pair is the head
            this->head = this->next[currentPosition];
        }
        else {
            // update the next pointer of the previous node
            this->next[previousPosition] = this->next[currentPosition];
        }
        // update the next pointer of the removed pair to point to the first empty slot
        this->next[currentPosition] = this->firstEmpty;
        // update the first empty slot
        this->firstEmpty = currentPosition;
        // retrieve the value to return
        TValue removedValue = this->elems[currentPosition].second;
        // set the removed slot to NULL_TELEM
        this->elems[currentPosition] = NULL_TELEM;

        this->sizeOfList--; // Decrease the size of the map
        return removedValue;
    }
    else {
        return NULL_TVALUE;
    }
}
//Best case: Theta(1)
// Worst case: Theta(n)
// Avarage case : O(n)

int Map::size() const {
    return this->sizeOfList;
}
//thata(1)

bool Map::isEmpty() const{
    if (this->sizeOfList == 0)
        return true;
	return false;
}
//theta(1)

void Map::empty() {
    delete[] this->elems;
    delete[] this->next;
    this->capacity = 10;
    this->sizeOfList= 0;
    this->head = -1;
    this->firstEmpty = 0;
    this->elems = new TElem[capacity];
    this->next = new int[capacity];
    // initialize the next array to create a linked list of available slots
    for (int i = 0; i < this->capacity - 1; i++) {
        this->next[i] = i + 1;
    }
    this->next[this->capacity - 1] = -1;
}
//theta(capacity)

MapIterator Map::iterator() const {
	return MapIterator(*this);
}



