#pragma once
#include "offer.h"
#include "DynamicArray.h"
#include "Repository.h"
#include "undoRedo.h"

typedef struct
{
	Repository* repo;
	UndoRepo* undo_redo;
}Service;

Service* createService(Repository* repo);
void copy_repo_service(Service* service, UndoRepo* UndoRedo);
void destroyService(Service* service);
int addOfferService(Service* service, char* type, char* destination, char* departureDate, int price);
int removeOfferService(Service* service, char* destination, char* departureDate);
void initForRepositoryService(Service* service);
int updateOfferService(Service* service, char* destination, char* departureDate, char* newType, int newPrice);
int getLenghtOfDynamicArrayService(Service* service);
void* getAllService(Service* service);
void sortedAscendingByPrice(Service* service, TElem* offers);
