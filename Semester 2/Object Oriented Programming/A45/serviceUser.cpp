#include "serviceUser.h"

ServiceUser::ServiceUser()
{

}

ServiceUser::ServiceUser(const RepositoryUser& repositoryy) :repository{ repositoryy }
{
}

ServiceUser::ServiceUser(const ServiceUser& service)
{
	this->repository = service.repository;
}

ServiceUser::~ServiceUser() = default;

int ServiceUser::addServiceUser(Dog dog)
{
	if (this->repository.addRepositoryUser(dog)==true)
		return true;
	else
		return false;
}

int ServiceUser::getLenghtServiceUser()
{
	return this->repository.getLengthRepositoryUser();
}

DynamicArray<Dog> ServiceUser::getAllServiceUser()
{
	return this->repository.getAllRepositoryUser();
}
