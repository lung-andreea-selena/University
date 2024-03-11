#include "Set.h"
#include "SetIterator.h"
#include <exception>
#include <new>

Set::Set() {
    // Initialize the capacity and the number of elements
    this->capacity = 103;
    this->loadFactor = 0.75;
    this->nrOfElements = 0;
    this->elements = new HashTableElement[this->capacity];
    for (int i = 0; i < this->capacity; i++) {
        this->elements[i].state = EMPTY;
    }

    // Initialize the sieve with true
    this->sieve = new bool[this->capacity];
    for (int i = 0; i < this->capacity; i++) {
        this->sieve[i] = true;
    }

    // Set the sieve
    this->setSieve();

    // Get the first prime number
    this->PRIME = this->prevPrime(this->capacity - 1);
}
// Time complexity: O(n), where n is the capacity of the set


bool Set::add(TElem elem) {
    // Search to see if the element is in the set
    if (this->search(elem)) {
        return false;
    }

    // Check if the array is full
    if (this->nrOfElements >= this->loadFactor * this->capacity) {
        this->resize();
    }

    // Add the element
    int probe = this->hash1(elem);
    int offset = this->hash2(elem);

    while (this->elements[probe].state == OCCUPIED) {
        probe = (probe + offset) % this->capacity;
    }

    // Add the element
    this->elements[probe].value = elem;
    this->elements[probe].state = OCCUPIED;
    this->nrOfElements++;

    return true;

}
// Time complexity
// Best case: theta(1) - when there is no collision
// Worst case: theta(n) - when there is a collision on every position


bool Set::remove(TElem elem) {
    // Return false if element is not in the set
    if (!this->search(elem)) {
        return false;
    }

    int probe = this->hash1(elem);
    int offset = this->hash2(elem);

    while (this->elements[probe].state != EMPTY) {
        if (this->elements[probe].state == OCCUPIED && this->elements[probe].value == elem) {
            this->elements[probe].state = DELETED;
            this->nrOfElements--;
            return true;
        }
        probe = (probe + offset) % this->capacity;
    }
    return false;

}
// Time complexity
// Best case: theta(1) - the element is on the first position
// Worst case: theta(n) - the element is on the last position

bool Set::search(TElem elem) const {
    if (this->isEmpty()) {
        return false;
    } else {
        int hash1Value = this->hash1(elem);
        int hash2Value = this->hash2(elem);
        int position = hash1Value;
        while (true) {
            if (this->elements[position].state == EMPTY) {
                return false;
            } else if (this->elements[position].state == OCCUPIED && this->elements[position].value == elem) {
                return true;
            }
            position = (position + hash2Value) % this->capacity;
            if (position == hash1Value) {
                return false;
            }
        }
    }
}
// Time complexity
// Best case: theta(1) - the element is on the first position
// Worst case: theta(n) - the element is on the last position


int Set::size() const {
    return this->nrOfElements;
}
// O(1)


bool Set::isEmpty() const {
    return this->nrOfElements == 0;
}
// O(1)


Set::~Set() {
    delete[] this->elements;
    delete[] this->sieve;
}



SetIterator Set::iterator() const {
	return SetIterator(*this);
}

void Set::resize() {
    // Set the new capacity
    int oldCapacity = this->capacity;
    this->capacity = this->capacity * 2;
    this->capacity = this->nextPrime(this->capacity);

    // Create a new array
    HashTableElement *newElements = new HashTableElement[this->capacity];

    // Set the new array
    for (int i = 0; i < this->capacity; i++) {
        newElements[i].state = EMPTY;
    }

    // Create a new sieve
    bool *newSieve = new bool[this->capacity];
    for (int i = 0; i < this->capacity; i++) {
        newSieve[i] = true;
    }
    delete[] this->sieve;
    this->sieve = newSieve;
    // Set the sieve
    this->setSieve();

    // Get the new prime number
    this->PRIME = this->prevPrime(this->capacity - 1);

    // Rehash the elements
    // Go through the old array and add the elements to the new in the right position
    for (int i = 0; i < oldCapacity; i++) {
        if (this->elements[i].state == OCCUPIED) {
            int probe = this->hash1(this->elements[i].value);
            int offset = this->hash2(this->elements[i].value);

            while (newElements[probe].state == OCCUPIED) {
                probe = (probe + offset) % this->capacity;
            }

            // Add the element
            newElements[probe].value = this->elements[i].value;
            newElements[probe].state = OCCUPIED;

            // Delete the old element
            this->elements[i].state = DELETED;

        }
    }


    // Delete the old array
    delete[] this->elements;
    this->elements = newElements;
}
// Time complexity: O(n), where n is the capacity of the set




int Set::hash1(TElem e) const {
    int hash = e % this->capacity;
    if (hash < 0) {
        hash += this->capacity;
    }
    return hash;
}
// O(1)

int Set::hash2(TElem e) const {
    return this->PRIME - (e % this->PRIME);
}
// O(1)

void Set::setSieve() {
    sieve[0] = sieve[1] = false;
    for (long long i = 2; i < this->capacity; i++) {
        if (sieve[i]) {
            for (long long j = i * i; j < this->capacity; j += i) {
                sieve[j] = false;
            }
        }
    }
}
// O(n)

int Set::prevPrime(int n) {
    while (!sieve[n]) {
        n--;
    }
    return n;
}
// Best case: theta(1) - when n is prime
// Worst case: theta(n) - when n is not prime and the previous prime is 2



bool Set::isFull() {
    return this->nrOfElements == this->capacity;
}
// O(1)

bool isPrime(int n) {
    if (n <= 1) return false;
    if (n <= 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;

    for (int i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) {
            return false;
        }
    }
    return true;
}
// O(sqrt(n))

int Set::nextPrime(int n) {
    if (n <= 2) {
        return 2;
    }
    if (n % 2 == 0 ) {
        n++;
    }
    bool found = false;
    while (!found) {
        n += 2;
        if (isPrime(n)) {
            found = true;
        }
    }
    return n;
}
// Best case: theta(1) - when n is prime
// Worst case: theta(n*sqrt(n)) - when n is not prime and the next prime is 2


int Set::difference(const Set &s) {
    int difference = 0;
    SetIterator it = s.iterator();

    while (it.valid()) {
        if (this->remove(it.getCurrent())) {
            difference++;
        }
        it.next();
    }

    return difference;
}
// Best case:
// Worst case: theta(len(s) * len(this)) - when all the elements in S are in this (the set)



