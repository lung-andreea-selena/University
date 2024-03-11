#include "repositoryUser.h"
#include <string>

RepositoryUser::RepositoryUser()
{

}

RepositoryUser::RepositoryUser(const DynamicArray<Dog>& dynamicarray) : dynamicArray{ dynamicarray }
{
}

RepositoryUser::RepositoryUser(const RepositoryUser& repository)
{
	this->dynamicArray = repository.dynamicArray;
}

RepositoryUser::~RepositoryUser() = default;

bool RepositoryUser::addRepositoryUser(Dog dog)
{
	if (this->checkIfAlreadyAdopted(dog) == -1)
	{
		this->dynamicArray.add(dog);
		return true;
	}
	else
		return false;
}

int RepositoryUser::checkIfAlreadyAdopted(Dog dog)
{
	for (int i = 0; i < this->dynamicArray.getLengthOfDynamicArray(); i++)
	{
		Dog dogOfIndexI = this->dynamicArray[i];
		if (dogOfIndexI.breedGetter() == dog.breedGetter() && dog.nameGetter() == dogOfIndexI.nameGetter())
			return i;
	}
	return -1;
}

DynamicArray<Dog> RepositoryUser::getAllRepositoryUser()
{
	return this->dynamicArray;
}

int RepositoryUser::getLengthRepositoryUser()
{
	return this->dynamicArray.getLengthOfDynamicArray();
}



