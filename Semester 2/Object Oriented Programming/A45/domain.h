#pragma once
#include <string>

using namespace std;

class Dog
{
private:
	string breed;
	string name;
	int age;
	string photo;

public:
	//Dog();

	Dog(string breed = "empty", string name = "empty", int age = 0, string photo = "empty");

	Dog(const Dog& copyDog);

	Dog& operator=(const Dog& copyDog);

	string breedGetter() const;

	string nameGetter() const;

	int ageGetter() const;

	string photoGetter() const;

	~Dog();

	//string ToString();

};
