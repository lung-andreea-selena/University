#pragma once

#include "SortedMultiMap.h"


class SMMIterator{
	friend class SortedMultiMap;
private:
	//DO NOT CHANGE THIS PART
	const SortedMultiMap& map;
	SMMIterator(const SortedMultiMap& map);

	TElem* sortedArray;
	int currentIndex;
	int arraySize;

public:
	void first();
	void next();
	bool valid() const;
   	TElem getCurrent() const;
};

// Create an iterator over the values associated to key k. If k is not in the SMM the iterator is invalid after creation, 
// otherwise, the current element is the first value associated to the key
// Create the ValueIterator class with the same operations as the regular smmi except that the constructor of theValueIterator receives as parameter the smmi
// and the key and the getCurrent operation returns a TValue

class ValueIterator {
	friend class SortedMultiMap;
private:
	//DO NOT CHANGE THIS PART
	vector<TValue> valueArray;
	int current;

public:
	ValueIterator(const SortedMultiMap& map, TKey key);
	void first();
	void next();
	bool valid() const;
	TValue getCurrent() const;
};


