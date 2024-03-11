#include "service.h"

using namespace std;

Service::Service()
{
}

Service::Service(const Repository& repositoryy) :repository{ repositoryy }
{
}

Service::~Service() = default;

bool Service::addService(const Dog& dog)
{
	if (this->repository.addRepository(dog))
		return true;
	else
		return false;}

vector<Dog> Service::getAllService()
{
	return this->repository.getAllRepository();
}

int Service::getLenghtService()
{
	return this->repository.getLengthRepository();
}

bool Service::removeService(string breed, string name)
{
	if (this->repository.removeRepository(breed, name))
		return true;
	else
		return false;}

bool Service::updateService(string breed, string name, int newAge, string newPhoto)
{
	if(this->repository.updateRepository(breed,name,newAge,newPhoto))
		return true;
	else
		return false;}
