#include "offer.h"
#include "DynamicArray.h"
#include "Repository.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Repository* createRepository(DynamicArray* dynamicArray)
{
	Repository* repo = malloc(sizeof(Repository));
	if(repo != NULL)
		repo->dynamicArray = dynamicArray;
	return repo;
}
void destroyRepository(Repository* repo)
{
	for (int i = 0; i < getLenghtOfDynamicArray(repo->dynamicArray); i++)
	{
		destroyOffer(repo->dynamicArray->elements[i]);
	}
	destroyDynamicArray(repo->dynamicArray);
	free(repo);
}


Offer* getOfferByPositionRepository(Repository* repo, int position)
{
	return getOfferByPositionDynamicArray(repo->dynamicArray, position);
}

int findAlreadyExistingOfferRepository(Repository* repo, Offer* offer)
{
	for (int i = 0; i < getLenghtOfDynamicArray(repo->dynamicArray); i++)
	{
		Offer* offerOfIndexI = getOfferByPositionDynamicArray(repo->dynamicArray, i);
		if ((strcmp(offerOfIndexI->destination, offer->destination) == 0) && (strcmp(offerOfIndexI->departureDate, offer->departureDate) == 0))
		{
			return i;
		}
	}
	return -1;
}
int addOfferRepository(Repository* repo, Offer* offer)
{
	if (findAlreadyExistingOfferRepository(repo, offer) != -1)
	{
		return 1; //the offer already exists
	}
	addElementInDynamicArray(repo->dynamicArray, offer);
	return 0; //offer added successfully
}

void removeElementRepository(Repository* repo, int position)
{
	removeElementFromDynamicArray(repo->dynamicArray, position);
		
}
void* getAllRepository(Repository* repo)
{
	return getAllElements(repo->dynamicArray);
}

int getLenghtOfDynamicArrayRepository(Repository* repo) {
	return getLenghtOfDynamicArray(repo->dynamicArray);
}


void initRepository(Repository* repo)
{
	char* typeArray[] = { "seaside", "mountain", "city", "seaside", "mountain", "city", "seaside", "mountain", "city", "seaside" };
	char* destinationArray[] = { "Miami", "Everest", "Vegas", "Mamaia", "Carpati", "Cluj", "Eforie", "Athos", "Bacau", "Maldive" };
	char* departudeDateArray[] = { "04.08.2003","23.03.2010", "06.10.2003", "04.08.2003", "29.08.2021", "30.08.2019", "02.07.2019", "17.02.2017", "14.05.2005", "19.09.2016" };
	int priceArray[] = { 300,650,860,2900,250,950,1000,980,200,1500 };
	for (int i = 0; i < 10; i++)
	{
		Offer* newOffer = createOffer(typeArray[i], destinationArray[i], departudeDateArray[i], priceArray[i]);
		addElementInDynamicArray(repo->dynamicArray, newOffer);
	}	
}

void copyRepo(Repository* repo, Repository* newRepo)
{
	for (int i = 0; i < repo->dynamicArray->lenght; i++)
		assignValues(&newRepo->dynamicArray->elements[i], *repo->dynamicArray->elements[i]);
}

Repository* duplicateRepo(Repository* repo)
{
	Repository* newRepo;
	newRepo->dynamicArray->capacity = repo->dynamicArray->capacity;
	newRepo->dynamicArray->lenght = repo->dynamicArray->lenght;

	newRepo->dynamicArray->elements = (Offer*)malloc(newRepo->dynamicArray->capacity * sizeof(Offer));

	copyRepo(repo, newRepo);
	return newRepo;

}