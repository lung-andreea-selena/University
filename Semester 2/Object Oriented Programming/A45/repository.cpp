#include "repository.h"
#include <string>

Repository::Repository()
{
	this->initializeRepository();
}

Repository::Repository(const DynamicArray<Dog>& dynamicarray): dynamicArray{dynamicarray}
{
}

Repository::Repository(const Repository& repository)
{
	this->dynamicArray = repository.dynamicArray;
}

Repository::~Repository() = default;

void Repository::initializeRepository()
{
	Dog dog1{ "American Bully", "Kevin", 7, "https://www.petfinder.com/static/2f2b42aeaecac9de8ac7c8fc42d19a97/68b46/AmericanBulldog_482x260.webp" };
	addRepository(dog1);
	Dog dog2{ "Beagle" , "Bobo", 3 , "https://www.petfinder.com/static/7b7fc58b7acebd254e4beb127614b234/0c5b9/beagle-card-large.webp" };
	addRepository(dog2);
	Dog dog3{ "Bichon", "Nick", 9 , "https://www.petfinder.com/static/22bb171d80368c760cfee0d6bb8e8568/0c5b9/bichon-frise-card-large.webp" };
	addRepository(dog3);
	Dog dog4{ "Chihuahua", "Mixie", 1, "https://www.petfinder.com/static/f0f4f062b99c0b3b9acc9c94e70475e0/0c5b9/chihuahua-card-large.webp" };
	addRepository(dog4);
	Dog dog5{ "Chow Chow", "Hello", 5, "https://www.petfinder.com/static/0fb8ebf4d61043e25ec44bacbb25c321/0c5b9/chow-chow-card-large.webp" };
	addRepository(dog5);
	Dog dog6{ "Dalmatian","Ben", 2, "https://www.petfinder.com/static/502d7ca10f151f8863c18538bc8d3e61/0c5b9/dalmatian-card-large.webp" };
	addRepository(dog6);
	Dog dog7{ "Enghlish Shepherd","Max",1,"https://www.petfinder.com/static/2e21e7bf546531934f6c88aa3a0f5330/d6259/English-Shepherd-600x260.webp" };
	addRepository(dog7);
	Dog dog8{ "Labrador","Paco",3,"https://www.petfinder.com/static/a71810ac65cbcac54a326e68ac309e6e/185bc/Labrador-600x260-sm.webp" };
	addRepository(dog8);
	Dog dog9{ "Husky","Jim",4,"https://www.petfinder.com/static/f31068aa2a8c93a5771ac4c66ba4199e/0c5b9/siberian-husky-card-large.webp" };
	addRepository(dog9);
	Dog dog10{ "Goldendoodle","Lilo", 6,"https://www.petfinder.com/static/0da3d244037a8a0a216522be345dde14/a647e/goldendoodle-dog-breed.webp" };
	addRepository(dog10);
}

bool Repository::addRepository(const Dog& dog)
{
	if (this->checkIfAlreadyExistDog(dog) == -1)
	{
		this->dynamicArray.add(dog);
		return true;
	}
	else
		return false;
}

int Repository::checkIfAlreadyExistDog(const Dog& dog)
{
	for (int i = 0; i < this->dynamicArray.getLengthOfDynamicArray(); i++)
	{
		Dog dogOfIndexI = this->dynamicArray[i];
		if (dogOfIndexI.breedGetter() == dog.breedGetter() && dog.nameGetter() == dogOfIndexI.nameGetter())
			return i;
	}
	return -1;
}

DynamicArray<Dog> Repository::getAllRepository()
{
	return this->dynamicArray;
}

int Repository::getLengthRepository()
{
	return this->dynamicArray.getLengthOfDynamicArray();
}

void Repository::removeRepository(int position)
{
	this->dynamicArray.deleteElement(position);
}

void Repository::updateRepository(int position, Dog newDog)
{
	this->dynamicArray.updateElement(position, newDog);
}






