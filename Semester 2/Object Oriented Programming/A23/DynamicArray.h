#pragma once
#include "offer.h"

typedef Offer* TElem;

typedef struct
{
	TElem* elements;
	int lenght;
	int capacity;
}DynamicArray;

DynamicArray* createDynamicArray(int capacity);
void destroyDynamicArray(DynamicArray* dynamicArr);
void resizeDynamicArray(DynamicArray* dynamicArr);
int getLenghtOfDynamicArray(DynamicArray* dynamicArr);
TElem getOfferByPositionDynamicArray(DynamicArray* dynamicArr, int position);
void addElementInDynamicArray(DynamicArray* dynamicArr, TElem newElement);
void removeElementFromDynamicArray(DynamicArray* dynamicArr, int position);
void* getAllElements(DynamicArray* dynamicArr);