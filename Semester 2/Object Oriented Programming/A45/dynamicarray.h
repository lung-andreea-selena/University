#pragma once
#include "domain.h"

template <typename TElem>
class DynamicArray
{
private:
	TElem* elements;
	int size;
	int capacity;

	void resize(int factor = 2);
public:
	DynamicArray(int capacity = 10);

	DynamicArray(const DynamicArray& dynamicArray);

	~DynamicArray();

	DynamicArray& operator=(const DynamicArray& dynamicArray);

	TElem& operator[](int position);

	void add(TElem element);

	int getLengthOfDynamicArray();

	void deleteElement(int position);

	void updateElement(int position, Dog newDog);

};

template<typename TElem>
void DynamicArray<TElem>::resize(int factor)
{
	this->capacity *= factor;

	TElem* newelements = new TElem[this->capacity];
	for (int i = 0; i < this->size; i++)
	{
		newelements[i] = this->elements[i];
	}
	delete[] this->elements;
	this->elements = newelements;
}

template<typename TElem>
DynamicArray<TElem>::DynamicArray(int capacity)
{
	this->capacity = capacity;
	this->size = 0;
	this->elements = new TElem[capacity];
}

template<typename TElem>
DynamicArray<TElem>::DynamicArray(const DynamicArray& dynamicArray)
{
	this->size = dynamicArray.size;
	this->capacity = dynamicArray.capacity;
	this->elements = new TElem[this->capacity];
	for (int i = 0; i < this->size; i++)
	{
		this->elements[i] = dynamicArray.elements[i];
	}
}

template<typename TElem>
DynamicArray<TElem>::~DynamicArray()
{
	delete[] this->elements;
}

template<typename TElem>
DynamicArray<TElem>& DynamicArray<TElem>::operator=(const DynamicArray& dynamicArray)
{
	if (this == &dynamicArray)
		return *this;

	this->size = dynamicArray.size;
	this->capacity = dynamicArray.capacity;
	auto aux = new TElem[this->capacity];
	delete[] this->elements;
	this->elements = aux;
	for (int i = 0; i < this->size; i++)
	{
		this->elements[i] = dynamicArray.elements[i];
	}
	return *this;
}

template<typename TElem>
TElem& DynamicArray<TElem> ::operator[](int position)
{
	return this->elements[position];
}

template<typename TElem>
inline void DynamicArray<TElem>::add(TElem element)
{
	if (this->size >= this->capacity)
		this->resize();
	this->elements[this->size] = element;
	this->size++;
}

template<typename TElem>
int DynamicArray<TElem>::getLengthOfDynamicArray()
{
	return this->size;
}


template<typename TElem>
void DynamicArray<TElem>::deleteElement(int position)
{
	int index;
	for (index = position; index < this->size-1; index++)
	{
		this->elements[index] = this->elements[index + 1];
	}
	this->size--;
}

template<typename TElem>
void DynamicArray<TElem>::updateElement(int position, Dog newDog)
{
	this->elements[position] = newDog;
}





