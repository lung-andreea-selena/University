#pragma once
#include "offer.h"
#include "DynamicArray.h"

typedef struct
{
	DynamicArray* dynamicArray;
}Repository;

Repository* createRepository(DynamicArray* dynamicArray);
void destroyRepository(Repository* repo);
Offer* getOfferByPositionRepository(Repository* repo, int position);
int findAlreadyExistingOfferRepository(Repository* repo, Offer* offer);
int addOfferRepository(Repository* repo, Offer* offer);
void removeElementRepository(Repository* repo,int position);
void initRepository(Repository* repo);
void* getAllRepository(Repository* repo);
int getLenghtOfDynamicArrayRepository(Repository* repo);
void copyRepo(Repository* repo, Repository* newRepo);
Repository* duplicateRepo(Repository* repo);