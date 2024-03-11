#include "offer.h"
#include "DynamicArray.h"
#include <stdio.h>
#include <stdlib.h>

DynamicArray* createDynamicArray(int capacity)
{
	DynamicArray* dynamicArr = malloc(sizeof(DynamicArray));
	if (dynamicArr != NULL)
	{
		dynamicArr->lenght = 0;
		dynamicArr->capacity = capacity;
		dynamicArr->elements = (TElem*)malloc(sizeof(TElem) * dynamicArr->capacity);
	}
	return dynamicArr;
}

void destroyDynamicArray(DynamicArray* dynamicArr)
{
	if (dynamicArr == NULL)
	{
		return;
	}
	free(dynamicArr->elements); //free the space allocated for offers
	free(dynamicArr); //free the space allocated for the dynamic array
}

void resizeDynamicArray(DynamicArray* dynamicArr)
{
	dynamicArr->capacity *= 2; //double the capacity
	TElem* auxiliarElements = malloc(dynamicArr->capacity * sizeof(TElem)); // points to an array of elements with the new capacity
	if (auxiliarElements != NULL) 
	{
		for (int i = 0; i < dynamicArr->lenght; i++)
		{
			auxiliarElements[i] = dynamicArr->elements[i]; // each auxiliary element takes the value of each element 
		}
		free(dynamicArr->elements); //free the old elements with the old capacity
		dynamicArr->elements = auxiliarElements; //the elements of the dynamic array will be those with the new capacity (the previous elements are the old ones but different capacity)
	}
}

int getLenghtOfDynamicArray(DynamicArray* dynamicArr)
{
	return dynamicArr->lenght;
}

TElem getOfferByPositionDynamicArray(DynamicArray* dynamicArr, int position)
{
	return dynamicArr->elements[position];
}


void addElementInDynamicArray(DynamicArray* dynamicArr, TElem newElement)
{
	if (dynamicArr->capacity == dynamicArr->lenght)
	{
		resizeDynamicArray(dynamicArr);
	}
	dynamicArr->elements[dynamicArr->lenght++] = newElement;
}

void removeElementFromDynamicArray(DynamicArray* dynamicArr, int position)
{
	//free(dynamicArr->elements[position]);
	for (int i = position; i < dynamicArr->lenght-1; i++)
	{
		dynamicArr->elements[i] = dynamicArr->elements[i + 1];
	}
	dynamicArr->lenght--;
}

void* getAllElements(DynamicArray* dynamicArr)
{
	return dynamicArr->elements;
}



//void updateAnEelemntInDynamicArray(DynamicArray* dynamicArr, TElem newEelemnt, int position)
//{
//	dynamicArr->elements[position] = newEelemnt;
//}