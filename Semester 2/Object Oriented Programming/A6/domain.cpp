#include <string>
#include "domain.h"
using namespace std;


Dog::Dog(string breed, string name, int age, string photo)
	:breed{ breed }, name{ name }, age{ age }, photo{ photo }
{

}

Dog::Dog(const Dog& copyDog)
	: breed{ copyDog.breed }, name{ copyDog.name }, age{ copyDog.age }, photo{ copyDog.photo }
{

}

Dog& Dog::operator=(const Dog& copyDog)
{
	this->breed = copyDog.breed;
	this->name = copyDog.name;
	this->age = copyDog.age;
	this->photo = copyDog.photo;
	return *this;
}

string Dog::breedGetter() const
{
	return this->breed;
}

string Dog::nameGetter() const
{
	return this->name;
}

int Dog::ageGetter() const
{
	return this->age;
}

string Dog::photoGetter() const
{
	return this->photo;
}

void Dog::ageSetter(int newAge)
{
	this->age = newAge;
}

void Dog::photoSetter(string newPhoto)
{
	this->photo = newPhoto;
}

Dog::~Dog() = default;


