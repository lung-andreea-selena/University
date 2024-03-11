#include "SMMIterator.h"
#include "SortedMultiMap.h"
#include <iostream>
#include <vector>
#include <exception>
using namespace std;

int SortedMultiMap::hashFunction1(TKey key) const {
    return abs(key % capacity);
}
//Theta(1)

int SortedMultiMap::hashFunction2(TKey key) const {
    return abs(key % (capacity - 1)) + 1;
}
//Theta(1)

int SortedMultiMap::nextPosition(int currentPosition, int stepSize, int i) const {
    return (currentPosition + i * stepSize) % capacity;
}
//Theta(1)

void SortedMultiMap::resizeAndRehash() {
    int oldCapacity = capacity;
    capacity = 2 * oldCapacity; // Double the capacity

    Node* oldHashtable = hashtable;
    hashtable = new Node[capacity];

    // Reset the size since elements will be rehashed
    sizePairs = 0;

    // Rehash all the elements from the old hashtable
    for (int i = 0; i < oldCapacity; i++) {
        if (!oldHashtable[i].isDeleted) {
            TKey key = oldHashtable[i].element.first;
            TValue* values = oldHashtable[i].values;
            int numValues = oldHashtable[i].numValues;

            for (int j = 0; j < numValues; j++) {
                add(key, values[j]); // Add the key-value pair to the new hashtable
            }

            delete[] values;
        }
    }

    delete[] oldHashtable;
}
// Best case: Theta(1)
// Worst case: Theta(sizePairs) 
// Average case: O(sizePairs)

void SortedMultiMap::createSortedArray(TElem* sortedArray) const {
    int sortedIndex = 0;
    for (int i = 0; i < capacity; i++) {
        if (!hashtable[i].isDeleted) {
            sortedArray[sortedIndex] = hashtable[i].element;
            sortedIndex++;
        }
    }

    // Sort the array based on the relation
    for (int i = 0; i < sizePairs - 1; i++) {
        for (int j = i + 1; j < sizePairs; j++) {
            if (!relation(sortedArray[i].first, sortedArray[j].first)) {
                swap(sortedArray[i], sortedArray[j]);
            }
        }
    }
}
// Best case: Theta(capacity)
// Worst Case: Theta (sizePairs^2)
// Avarage case: o(sizePairs^2)

SortedMultiMap::SortedMultiMap(Relation r) {
    capacity = 10; // Initial capacity
    sizePairs = 0;
    relation = r;
    threshold = 0.75; // Threshold for load factor
    hashtable = new Node[capacity];
}
// Theta(1)

void SortedMultiMap::add(TKey c, TValue v) {
    if ((float)sizePairs / capacity >= threshold)
        resizeAndRehash();

    int currentPosition = hashFunction1(c);
    int stepSize = hashFunction2(c);

    for (int i = 0; i < capacity; i++) {
        int position = nextPosition(currentPosition, stepSize, i);

        if (hashtable[position].element.first == c) {
            // Found the key, add the value to the associated dynamic array
            Node& node = hashtable[position];
            int valueIndex = node.numValues;

            // Increase the size of the dynamic array by reallocating
            TValue* newValues = new TValue[node.numValues + 1];
            for (int j = 0; j < node.numValues; j++) {
                newValues[j] = node.values[j];
            }

            newValues[valueIndex] = v;

            delete[] node.values;
            node.values = newValues;
            node.numValues++;

            sizePairs++;
            return;
        }
        else if (hashtable[position].isDeleted) {
            // Found a deleted position, insert the key-value pair here
            //hashtable[position].element = make_pair(c, new TValue[1]{ v });
            new (&hashtable[position].element) TElem(c, v);
            hashtable[position].values = new TValue[1]{ v };
            hashtable[position].numValues = 1;
            hashtable[position].isDeleted = false;
            sizePairs++;
            return;
        }
    }

    // If the loop completes without finding an empty or deleted position,
    // the hashtable is full (unlikely in practice due to resizing)
    throw exception("Hashtable is full.");
}
// Best case: Theta(1)
// Worst case: Theta(capacity) function may need to iterate through the entire hash table before finding an empty or deleted position
// Avarage case: O(capacity)

vector<TValue> SortedMultiMap::search(TKey c) const {
    vector<TValue> values;

    int currentPosition = hashFunction1(c);
    int stepSize = hashFunction2(c);

    for (int i = 0; i < capacity; i++) {
        int position = nextPosition(currentPosition, stepSize, i);

        if (hashtable[position].element.first == c) {
            // Found the key, add all values to the vector
            Node& node = hashtable[position];
            for (int j = 0; j < node.numValues; j++) {
                values.push_back(node.values[j]);
            }
            return values;
        }
        else if (hashtable[position].isDeleted) {
            // Found a deleted position, no need to continue searching
            break;
        }
    }

    return values; // Return an empty vector if the key is not found
}
// Best case: Theta(1)
// Worst case: Theta(capacity) 
// Average case: O(capacity)

bool SortedMultiMap::remove(TKey c, TValue v) {
    int currentPosition = hashFunction1(c);
    int stepSize = hashFunction2(c);

    for (int i = 0; i < capacity; i++) {
        int position = nextPosition(currentPosition, stepSize, i);

        if (hashtable[position].element.first == c && !hashtable[position].isDeleted) {
            // Found the key
            Node& node = hashtable[position];

            for (int j = 0; j < node.numValues; j++) {
                if (node.values[j] == v) {
                    // Found the value, remove it from the dynamic array
                    for (int k = j; k < node.numValues - 1; k++) {
                        node.values[k] = node.values[k + 1];
                    }

                    node.numValues--;

                    if (node.numValues == 0) {
                        // No more values for the key, mark the position as deleted
                        node.isDeleted = true;
                    }

                    sizePairs--;
                    return true;
                }
            }

            break; // No need to continue searching
        }
        else if (hashtable[position].isDeleted) {
            // Found a deleted position, no need to continue searching
            break;
        }
    }

    return false; // Key-value pair not found
}
// Best case: Theta(1)
// Worst case: Theta(capacity) 
// Average case: O(capacity)


int SortedMultiMap::size() const {
	return sizePairs;
}
//Theta(1)

bool SortedMultiMap::isEmpty() const {
	return sizePairs == 0;
}
//Theta(1)

SMMIterator SortedMultiMap::iterator() const {
	return SMMIterator(*this);
}
//Theta(1)

SortedMultiMap::~SortedMultiMap() {
    for (int i = 0; i < capacity; i++) {
        delete[] hashtable[i].values;
    }
    delete[] hashtable;
}
//Theta(capacity)
