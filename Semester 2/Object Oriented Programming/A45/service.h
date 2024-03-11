#pragma once
#include "repository.h"

class Service
{
private:
	Repository repository;

public:
	Service();

	Service(const Repository& repositoryy);

	Service(const Service& service);

	~Service();

	bool addService(const Dog& dog);

	//void initializeService();
	DynamicArray<Dog> getAllService();

	int getLenghtService();

	bool removeService(string breed, string name);

	int searchDogByBreedAndName(string breed, string name);

	bool updateService(string breed, string name, int newAge, string newPhoto);
};