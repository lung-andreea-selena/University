#include "repositoryUser.h"
#include <string>

RepositoryUser::RepositoryUser()
{

}

RepositoryUser::RepositoryUser(const vector<Dog>& userDogVector) : userDogVector{userDogVector}
{
}


RepositoryUser::~RepositoryUser() = default;

bool RepositoryUser::addRepositoryUser(const Dog& dog)
{
	if (checkIfAlreadyAdopted(dog.breedGetter(), dog.nameGetter()) == false)
	{
		this->userDogVector.push_back(dog);
		return true;}
	else
		return false;}

bool RepositoryUser::checkIfAlreadyAdopted(string breed, string name)
{
	auto result = find_if(this->userDogVector.begin(), this->userDogVector.end(),
		[breed, name](const Dog& dog) {return(dog.breedGetter() == breed && dog.nameGetter() == name); });
	if (result != this->userDogVector.end())
		return true;
	else
		return false;}

vector<Dog> RepositoryUser::getAllRepositoryUser()
{
	return this->userDogVector;
}

int RepositoryUser::getLengthRepositoryUser()
{
	return this->userDogVector.size();
}



