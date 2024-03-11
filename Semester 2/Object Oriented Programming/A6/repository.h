#pragma once
#pragma once
#include "domain.h"
#include <iostream>
#include <algorithm>
#include <vector>
#include <numeric>

using namespace std;

class Repository
{
private:
	vector<Dog> dogVector;
public:
	Repository();

	Repository(const vector<Dog>& dogVector);

	//Repository(const Repository& repository);

	~Repository();

	bool addRepository(const Dog& dog);

	bool checkIfAlreadyExistDog(string breed, string name);

	vector<Dog> getAllRepository();

	int getLengthRepository();

	bool removeRepository(string breed, string name);

	vector<Dog> ::iterator getIteratorByBreedAndName(string breed, string name);

	bool updateRepository(string breed,string name, int newAge, string newPhoto);


};
