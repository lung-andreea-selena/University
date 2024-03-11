#include "service.h"

Service::Service()
{
}

Service::Service(const Repository& repositoryy) :repository{ repositoryy }
{
}

Service::Service(const Service& service)
{
	this->repository = service.repository;

}

Service::~Service() = default;

bool Service::addService(const Dog& dog)
{
	if (this->repository.addRepository(dog))
		return true;
	else
		return false;
}

//void Service::initializeService()
//{
//	this->repository.initializeRepository();
//}

DynamicArray<Dog> Service::getAllService()
{
	return this->repository.getAllRepository();
}

int Service::getLenghtService()
{
	return this->repository.getLengthRepository();
}

bool Service::removeService(string breed, string name)
{
	int position = this->searchDogByBreedAndName(breed, name);
	if (position != -1)
	{
		this->repository.removeRepository(position);
		return true;
	}
	return false;
}

int Service::searchDogByBreedAndName(string breed, string name)
{
	int position;
	DynamicArray<Dog> dogs = this->repository.getAllRepository();
	for (position = 0; position < this->repository.getLengthRepository(); position++)
	{
		if (dogs[position].breedGetter() == breed && dogs[position].nameGetter() == name)
			return position;
	}
	return -1;
}

bool Service::updateService(string breed, string name, int newAge, string newPhoto)
{
	int position = this->searchDogByBreedAndName(breed, name);
	if (position != -1)
	{
		Dog newDog{ breed,name,newAge,newPhoto };
		this->repository.updateRepository(position, newDog);
		return true;
	}
	return false;

}
