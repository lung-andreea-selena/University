#include "offer.h"
#include "DynamicArray.h"
#include "Repository.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Service.h"
#include "undoRedo.h"

Service* createService(Repository* repo, UndoRepo* UndoRedo)
{
	Service* newService = malloc(sizeof(Service));
	if (newService != NULL)
	{
		newService->repo = repo;
		newService->undo_redo = UndoRedo;
		return newService;
	}	
}

void destroyService(Service* service)
{
	destroyRepository(service->repo);
	free(service);
}

int addOfferService(Service* service, char* type, char* destination, char* departureDate, int price)
{
	Offer* newOffer = createOffer(type, destination, departureDate, price);
	if (addOfferRepository(service->repo, newOffer) == 0)
		return 0;
	else return 1;
}

int removeOfferService(Service* service, char* destination, char* departureDate)
{
	void* offersList = getAllRepository(service->repo);
	TElem* castedList = (TElem*)offersList;
	int lengthOfDynamicArray = getLenghtOfDynamicArrayRepository(service->repo);
	for (int i = 0; i < lengthOfDynamicArray; i++)
	{
		Offer* OfferOfIndexI = getOfferByPositionRepository(service->repo, i);
		if ((strcmp(getDestination(OfferOfIndexI), destination) == 0) && (strcmp(getDepartureDate(OfferOfIndexI), departureDate) == 0))
		{
			removeElementRepository(service->repo,i);
			return 0; //deleted successfully
		}
	}
	return -1;
}

int updateOfferService(Service* service, char* destination, char* departureDate, char* newType, int newPrice)
{
	void* offersList = getAllRepository(service->repo);
	TElem* castedList = (TElem*)offersList;
	int lengthOfDynamicArray = getLenghtOfDynamicArrayRepository(service->repo);
	for (int i = 0; i < lengthOfDynamicArray; i++)
	{
		Offer* OfferOfIndexI = getOfferByPositionRepository(service->repo, i);
		if ((strcmp(getDestination(OfferOfIndexI), destination) == 0) || (strcmp(getDepartureDate(OfferOfIndexI), departureDate) == 0))
		{
			setType(OfferOfIndexI, newType);
			setPrice(OfferOfIndexI, newPrice);
			return 0; //updated successfully
		}
	}
	return -1;
}

int getLenghtOfDynamicArrayService(Service* service)
{
	return getLenghtOfDynamicArrayRepository(service->repo);
}

void* getAllService(Service* service)
{
	return getAllRepository(service->repo);
}

void sortedAscendingByPrice(Service* service, TElem* offers)
{
	for (int i = 0; i < getLenghtOfDynamicArrayRepository(service->repo) - 1; i++)
	{
		for (int j = 0; j < getLenghtOfDynamicArrayRepository(service->repo) - i - 1; j++)
		{
			if (getPrice(offers[j]) > getPrice(offers[j + 1]))
			{
				TElem aux = offers[j];
				offers[j] = offers[j + 1];
				offers[j + 1] = aux;
			}
		}
	}
}

void initForRepositoryService(Service* service)
{
	initRepository(service->repo);
}

void copy_repo_service(Service* service, UndoRepo* UndoRedo)
{
	service->repo->dynamicArray->lenght = UndoRedo->data[UndoRedo->currentPosition].dynamicArray->lenght;
	service->repo->dynamicArray->capacity = UndoRedo->data[UndoRedo->currentPosition].dynamicArray->capacity;
	for (int i = 0; i < UndoRedo->data[UndoRedo->currentPosition].dynamicArray->lenght; i++)
		service->repo->dynamicArray->elements[i] = UndoRedo->data[UndoRedo->currentPosition].dynamicArray->elements[i];
}