#pragma once
#include "domain.h"
#include "dynamicarray.h"

class Repository
{
private:
	DynamicArray<Dog> dynamicArray;
public:
	Repository();
	
	Repository(const DynamicArray<Dog>& dynamicarray);

	Repository(const Repository& repository);

	~Repository();

	void initializeRepository();

	bool addRepository(const Dog& dog);

	int checkIfAlreadyExistDog(const Dog& dog);

	DynamicArray<Dog> getAllRepository();

	int getLengthRepository();

	void removeRepository(int position);

	void updateRepository(int position, Dog newDog);


};
