#pragma once
//DO NOT INCLUDE SETITERATOR

//DO NOT CHANGE THIS PART
#define NULL_TELEM -1111111
typedef int TElem;
class SetIterator;

// State enum for the hash table
typedef enum {
    EMPTY,
    OCCUPIED,
    DELETED
} status;

// Helper struct for the hash table
typedef struct {
    TElem value;
    status state;
} HashTableElement;

// Data structure: Hash table
class Set {
	//DO NOT CHANGE THIS PART
	friend class SetIterator;

    private:
        HashTableElement *elements;
        int capacity;
        double loadFactor;
        int nrOfElements;
        int PRIME;
        bool *sieve;

    public:
        //implicit constructor
        Set();

        //adds an element to the set
		//returns true if the element was added, false otherwise (if the element was already in the set and it was not added)
        bool add(TElem e);

        //removes an element from the set
		//returns true if e was removed, false otherwise
        bool remove(TElem e);

        //checks whether an element belongs to the set or not
        bool search(TElem elem) const;

        //returns the number of elements;
        int size() const;

        //check whether the set is empty or not;
        bool isEmpty() const;

        //return an iterator for the set
        SetIterator iterator() const;

        // Keep only those that do not appear in the set s
        // returns the number of elements removed
        int difference(const Set& s);

        // destructor
        ~Set();

private:

        // Resizes the array
        void resize();

        // Rehashes the array
        void rehash();

        // First hash function
        int hash1(TElem e) const;

        // Second hash function
        int hash2(TElem e) const;

        // Return if the array is full
        bool isFull();

        // Returns the first prime number smaller than n
        // Helper function for the hash table
        int prevPrime(int n);

        // Returns the first prime number larger than n
        int nextPrime(int n);

        // Set the sieve of Eratosthenes
        // Helper function for the hash table
        void setSieve();


};





