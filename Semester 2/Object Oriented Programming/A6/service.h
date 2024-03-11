#pragma once
#include "repository.h"

using namespace std;

class Service
{
private:
	Repository repository;

public:
	Service();

	Service(const Repository& repositoryy);

	//Service(const Service& service);

	~Service();

	bool addService(const Dog& dog);

	vector<Dog> getAllService();

	int getLenghtService();

	bool removeService(string breed, string name);

	bool updateService(string breed, string name, int newAge, string newPhoto);
};