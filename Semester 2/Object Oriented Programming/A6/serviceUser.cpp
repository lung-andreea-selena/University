#include "serviceUser.h"

ServiceUser::ServiceUser()
{

}

ServiceUser::ServiceUser(const RepositoryUser& repositoryy) :repository{ repositoryy }
{
}

ServiceUser::~ServiceUser() = default;

bool ServiceUser::addServiceUser(const Dog& dog)
{
	if (this->repository.addRepositoryUser(dog) == true)
		return true;
	else
		return false;}

int ServiceUser::getLenghtServiceUser()
{
	return this->repository.getLengthRepositoryUser();
}

vector<Dog> ServiceUser::getAllServiceUser()
{
	return this->repository.getAllRepositoryUser();
}
