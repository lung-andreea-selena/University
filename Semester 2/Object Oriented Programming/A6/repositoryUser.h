#pragma once
#include "domain.h"

using namespace std;

class RepositoryUser
{
private:
	vector<Dog> userDogVector;
public:
	RepositoryUser();

	RepositoryUser(const vector<Dog>& userDogVector);

	//RepositoryUser(const RepositoryUser& repository);

	~RepositoryUser();

	bool addRepositoryUser(const Dog& dog);

	bool checkIfAlreadyAdopted(string breed, string name);

	vector<Dog> getAllRepositoryUser();

	int getLengthRepositoryUser();

	//vector<Dog> ::iterator getIteratorByBreedAndName(string breed, string name);
};