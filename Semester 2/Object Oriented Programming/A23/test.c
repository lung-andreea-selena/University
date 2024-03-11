#include "offer.h"
#include "DynamicArray.h"
#include "Repository.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Service.h"
#include "Ui.h"
#include <assert.h>
#include "test.h"

void testCreateDynamicArray()
{
    DynamicArray* dynamicArr = createDynamicArray(100);
    assert(dynamicArr->lenght == 0);
    assert(dynamicArr->capacity == 100);
    destroyDynamicArray(dynamicArr);
}

void testAddFunction()
{
    Offer* offer = createOffer("seaside", "Ibiza", "15.09.2030", 5100);
    DynamicArray* dynamicArr = createDynamicArray(3);
    addElementInDynamicArray(dynamicArr, offer);
    assert(strcmp(getType(dynamicArr->elements[0]), "seaside") == 0);
    assert(strcmp(getDestination(dynamicArr->elements[0]), "Ibiza") == 0);
    assert(strcmp(getDepartureDate(dynamicArr->elements[0]), "15.09.2030") == 0);
    assert(getPrice(dynamicArr->elements[0])==5100);
    destroyDynamicArray(dynamicArr);
}

void testDeleteFunction()
{
    Offer* offer = createOffer("seaside", "Ibiza", "15.09.2030", 5100);
    Offer* offer2 = createOffer("city", "Bucuresti", "29.05.2000", 900);
    DynamicArray* dynamicArr = createDynamicArray(3);
    addElementInDynamicArray(dynamicArr, offer);
    addElementInDynamicArray(dynamicArr, offer2);
    assert(strcmp(getType(dynamicArr->elements[1]), "city") == 0);
    assert(getLenghtOfDynamicArray(dynamicArr) == 2);
    removeElementFromDynamicArray(dynamicArr, 1);
    assert(getLenghtOfDynamicArray(dynamicArr) == 1);
    destroyDynamicArray(dynamicArr);

}

void testInItRepo()
{
    DynamicArray* dynamicarray = createDynamicArray(10);
    Repository* repo = createRepository(dynamicarray);
    initRepository(repo);
    assert(getLenghtOfDynamicArrayRepository(repo) == 10);
    assert(strcmp(getType(dynamicarray->elements[0]), "seaside") == 0);
    assert(strcmp(getType(dynamicarray->elements[8]), "city") == 0);
    assert(strcmp(getDestination(dynamicarray->elements[2]), "Vegas") == 0);
    assert(strcmp(getDestination(dynamicarray->elements[3]), "Buc") !=0);
    destroyRepository(repo);
}

void testService()
{
    DynamicArray* dynamicArr = createDynamicArray(10);
    Repository* repo = createRepository(dynamicArr);
    initRepository(repo);
    Service* service = createService(repo);
    addOfferService(service, "seaside", "Ibiza", "15.09.2030", 5100);
    assert(strcmp(getType(dynamicArr->elements[10]), "seaside") == 0);
    removeOfferService(service, "Ibiza", "15.09.2030");
    assert(getLenghtOfDynamicArrayService(service) == 10);
}



void testAll()
{
    testCreateDynamicArray();
    testAddFunction();
    testDeleteFunction();
    testService();
    testInItRepo();
}