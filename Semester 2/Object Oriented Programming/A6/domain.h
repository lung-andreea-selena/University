#pragma once
#pragma once
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>
#include <numeric>

using namespace std;

class Dog
{
private:
	string breed;
	string name;
	int age;
	string photo;

public:

	Dog(string breed = "empty", string name = "empty", int age = 0, string photo = "empty");

	Dog(const Dog& copyDog);

	Dog& operator=(const Dog& copyDog);

	string breedGetter() const;

	string nameGetter() const;

	int ageGetter() const;

	string photoGetter() const;

	void ageSetter(int newAge);

	void photoSetter(string newPhoto);

	~Dog();

};
