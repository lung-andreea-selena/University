#pragma once
#include "dynamicarray.h"

class RepositoryUser
{
private:
	DynamicArray<Dog> dynamicArray;
public:
	RepositoryUser();

	RepositoryUser(const DynamicArray<Dog>& dynamicarray);

	RepositoryUser(const RepositoryUser& repository);

	~RepositoryUser();

	bool addRepositoryUser(Dog dog);

	int checkIfAlreadyAdopted(Dog dog);

	DynamicArray<Dog> getAllRepositoryUser();

	int getLengthRepositoryUser();
};